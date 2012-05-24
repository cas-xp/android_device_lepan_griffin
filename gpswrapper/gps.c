/******************************************************************************
 * GPS HAL wrapper
 * wrapps around Samsung GPS Libary and replaces a faulty pointer to
 * a faulty function from Samsung that will cause the system_server
 * to crash.
 *
 * Copyright 2010 - Kolja Dummann
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ******************************************************************************/

#include <hardware/hardware.h>
#include <hardware/gps.h>
#include <errno.h>
#include <dlfcn.h>

#define LOG_NDEBUG 0

#include <stdlib.h>
#define LOG_TAG "gps-wrapper"
#include <utils/Log.h>

#include <gpsshim.h>

GpsCallbacks *originalCallbacks;
static const OldGpsXtraInterface* oldXTRA = NULL;
static GpsXtraInterface newXTRA;
static const OldAGpsInterface* oldAGPS = NULL;
static AGpsInterface newAGPS;


#define ORIGINAL_HAL_PATH "/system/lib/libhardware_legaci.so"
GpsInterface* (*legacy_gps_get_interface)(void);

GpsInterface* stub_gps_get_interface()
{
    return NULL;
}


static const OldAGpsRilInterface* oldAGPSRIL = NULL;
static AGpsRilInterface newAGPSRIL;
static const OldGpsNiInterface* oldNI = NULL;
static GpsNiInterface newNI;

static const OldGpsInterface* originalGpsInterface = NULL;
static GpsInterface newGpsInterface;
static int gpsinitialized = 0;
/**
 * Load the file defined by the variant and if successful
 * return the dlopen handle and the hmi.
 * @return 0 = success, !0 = failure.
 */
static void location_callback_wrapper(OldGpsLocation *location) {
    static GpsLocation newLocation;
    LOGV("I have a location");
    newLocation.size = sizeof(GpsLocation);
    newLocation.flags = location->flags;
    newLocation.latitude = location->latitude;
    newLocation.longitude = location->longitude;
    newLocation.altitude = location->altitude;
    newLocation.speed = location->speed;
    newLocation.bearing = location->bearing;
    newLocation.accuracy = location->accuracy;
    newLocation.timestamp = location->timestamp;
    originalCallbacks->create_thread_cb("gpsshim-location",(void *)originalCallbacks->location_cb,(void *)&newLocation);
}

static void status_callback_wrapper(OldGpsStatus *status) {
    static GpsStatus newStatus;
    newStatus.size = sizeof(GpsStatus);
    LOGV("Status value is %u",status->status);
    newStatus.status = status->status;
    originalCallbacks->create_thread_cb("gpsshim-status",(void *)originalCallbacks->status_cb,(void *)&newStatus);
}

static void svstatus_callback_wrapper(OldGpsSvStatus *sv_info) {
    static GpsSvStatus newSvStatus;
    int i=0;
    LOGV("I have a svstatus");
    newSvStatus.size = sizeof(GpsSvStatus);
    newSvStatus.num_svs = sv_info->num_svs;
    for (i=0; i<newSvStatus.num_svs; i++) {
        newSvStatus.sv_list[i].size = sizeof(GpsSvInfo);
        newSvStatus.sv_list[i].prn = sv_info->sv_list[i].prn;
        newSvStatus.sv_list[i].snr = sv_info->sv_list[i].snr;
        newSvStatus.sv_list[i].elevation = sv_info->sv_list[i].elevation;
        newSvStatus.sv_list[i].azimuth = sv_info->sv_list[i].azimuth;
    }
    newSvStatus.ephemeris_mask = sv_info->ephemeris_mask;
    newSvStatus.almanac_mask = sv_info->almanac_mask;
    newSvStatus.used_in_fix_mask = sv_info->used_in_fix_mask;
    originalCallbacks->create_thread_cb("gpsshim-svstatus",(void *)originalCallbacks->sv_status_cb,(void *)&newSvStatus);
}

GpsUtcTime nmeasave_timestamp; const char* nmeasave_nmea; int nmeasave_length;

static void nmea_callback(void *unused) {
    LOGV("Invoking nmea callback");
    originalCallbacks->nmea_cb(nmeasave_timestamp, nmeasave_nmea, nmeasave_length);
}

static void nmea_callback_wrapper(GpsUtcTime timestamp, const char* nmea, int length) {
    nmeasave_timestamp = timestamp; nmeasave_nmea = nmea; nmeasave_length=length;
    originalCallbacks->create_thread_cb("gpsshim-nmea",(void *)nmea_callback,NULL);
}

static OldAGpsCallbacks oldAGpsCallbacks;
static const AGpsCallbacks* newAGpsCallbacks = NULL;

static void agps_status_cb(OldAGpsStatus* status)
{
    AGpsStatus newAGpsStatus;
    newAGpsStatus.size = sizeof(AGpsStatus);
    newAGpsStatus.type = status->type;
    newAGpsStatus.status = status->status;
    newAGpsCallbacks->create_thread_cb("gpsshim-agpsstatus",(void *)newAGpsCallbacks->status_cb,(void*)&newAGpsStatus);
}

static void agps_init_wrapper(AGpsCallbacks * callbacks)
{
    newAGpsCallbacks = callbacks;
    oldAGpsCallbacks.status_cb = agps_status_cb;

    oldAGPS->init(&oldAGpsCallbacks);
}
static OldAGpsRilCallbacks oldAGpsRilCallbacks;
static const AGpsRilCallbacks* newAGpsRilCallbacks = NULL;

static void agpsril_setid_cb(uint32_t flags)
{
    LOGV("AGPSRIL setid callback");
    newAGpsRilCallbacks->create_thread_cb("gpsshim-agpsril-setid",(void *)newAGpsRilCallbacks->request_setid,&flags);
}

static void agpsril_refloc_cb(uint32_t flags)
{
    LOGV("AGPSRIL refloc callback");
    newAGpsRilCallbacks->create_thread_cb("gpsshim-agpsril-refloc",(void *)newAGpsRilCallbacks->request_refloc,&flags);
}

static void agpsril_init_wrapper(AGpsRilCallbacks * callbacks)
{
    newAGpsRilCallbacks = callbacks;
    oldAGpsRilCallbacks.request_setid = agpsril_setid_cb;
    oldAGpsRilCallbacks.request_refloc = agpsril_refloc_cb;
    LOGV("AGPSRIL init");

    oldAGPSRIL->init(&oldAGpsRilCallbacks);
}

static OldGpsXtraCallbacks oldXtraCallbacks;
static const GpsXtraCallbacks* newXtraCallbacks = NULL;

static void xtra_download_cb()
{
    newXtraCallbacks->create_thread_cb("gpsshim-xtradownload",(void *)newXtraCallbacks->download_request_cb,NULL);
}

static int xtra_init_wrapper(GpsXtraCallbacks * callbacks)
{
    newXtraCallbacks = callbacks;
    oldXtraCallbacks.download_request_cb = xtra_download_cb;

#ifdef NEEDS_INITIAL_XTRA
    xtra_download_cb();
#endif

    return oldXTRA->init(&oldXtraCallbacks);
}

static int load(const char *id,
        const char *path,
        const struct hw_module_t **pHmi)
{
    int status;
    void *handle;
    struct hw_module_t *hmi;

    /*
     * load the symbols resolving undefined symbols before
     * dlopen returns. Since RTLD_GLOBAL is not or'd in with
     * RTLD_NOW the external symbols will not be global
     */
    handle = dlopen(path, RTLD_NOW);
    if (handle == NULL) {
        char const *err_str = dlerror();
        LOGE("load: module=%s\n%s", path, err_str?err_str:"unknown");
        status = -EINVAL;
        goto done;
    }

    /* Get the address of the struct hal_module_info. */
    const char *sym = HAL_MODULE_INFO_SYM_AS_STR;
    hmi = (struct hw_module_t *)dlsym(handle, sym);
    if (hmi == NULL) {
        LOGE("load: couldn't find symbol %s", sym);
        status = -EINVAL;
        goto done;
    }

    /* Check that the id matches */
    if (strcmp(id, hmi->id) != 0) {
        LOGE("load: id=%s != hmi->id=%s", id, hmi->id);
        status = -EINVAL;
        goto done;
    }

    hmi->dso = handle;

    /* success */
    status = 0;

    done:
    if (status != 0) {
        hmi = NULL;
        if (handle != NULL) {
            dlclose(handle);
            handle = NULL;
        }
    } else {
        LOGV("loaded HAL id=%s path=%s hmi=%p handle=%p",
                id, path, *pHmi, handle);
    }

    *pHmi = hmi;

    return status;
}

static const void* wrapper_get_extension(const char* name)
{
    if (!strcmp(name, GPS_XTRA_INTERFACE) && (oldXTRA = originalGpsInterface->get_extension(name)))
    {
        newXTRA.size = sizeof(GpsXtraInterface);
        newXTRA.init = xtra_init_wrapper;
        newXTRA.inject_xtra_data = oldXTRA->inject_xtra_data;
        return &newXTRA;
    }
    else if (!strcmp(name, AGPS_INTERFACE) && (oldAGPS = originalGpsInterface->get_extension(name)))
    {
        newAGPS.size = sizeof(AGpsInterface);
        newAGPS.init = agps_init_wrapper;
        newAGPS.data_conn_open = oldAGPS->data_conn_open;
        newAGPS.data_conn_closed = oldAGPS->data_conn_closed;
        newAGPS.data_conn_failed = oldAGPS->data_conn_failed;
        newAGPS.set_server = oldAGPS->set_server;
        return &newAGPS;
    }
    else if (!strcmp(name, AGPS_RIL_INTERFACE) && (oldAGPSRIL = originalGpsInterface->get_extension(name)))
    {
        /* use a wrapper to avoid calling samsungs faulty implemetation */        
        newAGPSRIL.size = sizeof(AGpsRilInterface);
        newAGPSRIL.init = agpsril_init_wrapper;
        newAGPSRIL.set_ref_location = oldAGPSRIL->set_ref_location;
        newAGPSRIL.set_set_id = oldAGPSRIL->set_set_id;
        newAGPSRIL.ni_message = oldAGPSRIL->ni_message;
        return &newAGPSRIL;
    }
    return NULL;
}


static int init_wrapper(GpsCallbacks* callbacks)
{
	int ret;
    LOGV("%s was called", __func__);
    gpsinitialized = 1;
    static OldGpsCallbacks oldCallbacks;
    originalCallbacks = callbacks;
    oldCallbacks.location_cb = location_callback_wrapper;
    oldCallbacks.status_cb = status_callback_wrapper;
    oldCallbacks.sv_status_cb = svstatus_callback_wrapper;
    oldCallbacks.nmea_cb = nmea_callback_wrapper;
#ifdef NO_AGPS
    originalCallbacks->set_capabilities_cb(0);
#else
    originalCallbacks->set_capabilities_cb(GPS_CAPABILITY_MSB|GPS_CAPABILITY_MSA);
#endif
	ret = originalGpsInterface->init(&oldCallbacks);
    LOGV("%s return with %d", __func__, ret);
    return ret;
}

static int set_position_mode_wrapper(GpsPositionMode mode, GpsPositionRecurrence recurrence,  uint32_t min_interval, uint32_t preferred_accuracy, uint32_t preferred_time) {
    return originalGpsInterface->set_position_mode(mode, recurrence ? 0 : (min_interval/1000));
}

static int stop_wrapper() {
    int ret = originalGpsInterface->stop();
    originalCallbacks->release_wakelock_cb();
    return ret;
}
static int start_wrapper() {
    originalCallbacks->acquire_wakelock_cb();
    return originalGpsInterface->start();
}

/* HAL Methods */
const GpsInterface* gps_get_gps_interface(struct gps_device_t* dev)
{
    hw_module_t* module;
    int err;
    void *handle;
    
    LOGV("%s was called", __func__);    

    /*
     * load the symbols resolving undefined symbols before
     * dlopen returns. Since RTLD_GLOBAL is not or'd in with
     * RTLD_NOW the external symbols will not be global
     */
    handle = dlopen(ORIGINAL_HAL_PATH, RTLD_NOW);
    if (handle == NULL) {
    	LOGV("dlopen isn't OK with error=%s\n", dlerror());
	legacy_gps_get_interface = stub_gps_get_interface;
	return NULL;
    }
    LOGV("dlopen is OK");    
    
    //err = load(GPS_HARDWARE_MODULE_ID, , (hw_module_t const**)&module);
    *(void **)&legacy_gps_get_interface = dlsym(handle, "gps_get_interface");
    LOGV("dlsym is OK");    
        
    originalGpsInterface = legacy_gps_get_interface();

    if(originalGpsInterface)
    {
        LOGV("%s exposing callbacks", __func__); 
        newGpsInterface.size = sizeof(GpsInterface);
        newGpsInterface.init = init_wrapper;
        newGpsInterface.start = start_wrapper;
        newGpsInterface.stop = stop_wrapper;
        newGpsInterface.cleanup = originalGpsInterface->cleanup;
        newGpsInterface.inject_time = originalGpsInterface->inject_time;
        newGpsInterface.inject_location = originalGpsInterface->inject_location;
        newGpsInterface.delete_aiding_data = originalGpsInterface->delete_aiding_data;
        newGpsInterface.set_position_mode = set_position_mode_wrapper;
        newGpsInterface.get_extension = wrapper_get_extension;

    }
    LOGV("%s done", __func__);
    return &newGpsInterface;
}

static int open_gps(const struct hw_module_t* module, char const* name,
        struct hw_device_t** device)
{
    struct gps_device_t *dev = malloc(sizeof(struct gps_device_t));
    memset(dev, 0, sizeof(*dev));

    LOGV("%s was called", __func__);

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t*)module;
    dev->get_gps_interface = gps_get_gps_interface;

    *device = (struct hw_device_t*)dev;
    return 0;
}

static struct hw_module_methods_t gps_module_methods = {
    .open = open_gps
};

const struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = GPS_HARDWARE_MODULE_ID,
    .name = "GPS HAL Wrapper Module",
    .author = "Mark Mao",
    .methods = &gps_module_methods,
};