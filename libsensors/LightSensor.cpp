/*
 * Copyright (C) 2008 The Android Open Source Project
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
 */

#include <fcntl.h>
#include <errno.h>
#include <math.h>
#include <poll.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/select.h>
#include <cutils/log.h>

#include "LightSensor.h"

/*****************************************************************************/


LightSensor::LightSensor()
    : SensorBase(NULL, "light"),
      mEnabled(0),
      mInputReader(4),
      mHasPendingEvent(false)
{
    mPendingEvent.version = sizeof(sensors_event_t);
    mPendingEvent.sensor = ID_L;
    mPendingEvent.type = SENSOR_TYPE_LIGHT;
    memset(mPendingEvent.data, 0, sizeof(mPendingEvent.data));

    if (data_fd) {
        strcpy(input_sysfs_path, "/sys/devices/virtual/input/input8/");
        //strcat(input_sysfs_path, input_name);
        //strcat(input_sysfs_path, "/device/");
        input_sysfs_path_len = strlen(input_sysfs_path);
        enable(0, 1);
    }
}

LightSensor::~LightSensor() {
    if (mEnabled) {
        enable(0, 0);
    }
}

int LightSensor::setDelay(int32_t handle, int64_t ns)
{
    int fd;
    strcpy(&input_sysfs_path[input_sysfs_path_len], "poll_delay");
    fd = open(input_sysfs_path, O_RDWR);
    if (fd >= 0) {
        char buf[80];
        sprintf(buf, "%lld", ns);
        write(fd, buf, strlen(buf)+1);
        close(fd);
        return 0;
    }
    return -1;
}

int LightSensor::enable(int32_t handle, int en)
{
    int flags = en ? 1 : 0;
    mPreviousLight = -1;
    if (flags != mEnabled) {
        int fd;
        strcpy(&input_sysfs_path[input_sysfs_path_len], "enable");
        fd = open(input_sysfs_path, O_RDWR);
        if (fd >= 0) {
            char buf[2];
            int err;
            buf[1] = 0;
            if (flags) {
                buf[0] = '1';
            } else {
                buf[0] = '0';
            }
            err = write(fd, buf, sizeof(buf));
            close(fd);
            mEnabled = flags;
            return 0;
        }
        return -1;
    }
    return 0;
}

bool LightSensor::hasPendingEvents() const {
    return mHasPendingEvent;
}

int LightSensor::readEvents(sensors_event_t* data, int count)
{
    if (count < 1)
        return -EINVAL;

    if (mHasPendingEvent) {
        mHasPendingEvent = false;
        mPendingEvent.timestamp = getTimestamp();
        *data = mPendingEvent;
        return mEnabled ? 1 : 0;
    }

    ssize_t n = mInputReader.fill(data_fd);
    if (n < 0)
        return n;

    int numEventReceived = 0;
    input_event const* event;

    while (count && mInputReader.readEvent(&event)) {
        int type = event->type;
        if (type == EV_ABS) {
            if (event->code == EVENT_TYPE_LIGHT) {
            //LOGE("LightSensor: LIGHT event (value=%d)",(event->value)/15000);
                mPendingEvent.light = indexToValue(event->value/15000);
            }else {
            LOGE("LightSensor: unknown event (type=%d, code=%d)",
                    type, event->code);}
        } else if (type == EV_SYN) {
            mPendingEvent.timestamp = timevalToNano(event->time);
            if (mEnabled ) {
                *data++ = mPendingEvent;
                count--;
                numEventReceived++;
            }
        } else {
            LOGE("LightSensor: unknown event (type=%d, code=%d)",
                    type, event->code);
        }
        mInputReader.next();
    }

    return numEventReceived;
}

float LightSensor::indexToValue(size_t index) const
{
    /* Driver gives a rolling average adc value.  We convert it lux levels. */
    static const struct adcToLux {
        size_t adc_value;
        float  lux_value;
    } adcToLux[] = {
        {  10,   10.0 },  /* from    0 -  150 adc, we map to    10.0 lux */
        {  160,  160.0 },  /* from  151 -  800 adc, we map to   160.0 lux */
        {  220,  225.0 },  /* from  801 -  900 adc, we map to   225.0 lux */
        { 320,  320.0 },  /* from  901 - 1000 adc, we map to   320.0 lux */
        { 640,  640.0 },  /* from 1001 - 1200 adc, we map to   640.0 lux */
        { 1280, 1280.0 },  /* from 1201 - 1400 adc, we map to  1280.0 lux */
        { 2600, 2600.0 },  /* from 1401 - 1600 adc, we map to  2600.0 lux */
        { 4095, 10240.0 }, /* from 1601 - 4095 adc, we map to 10240.0 lux */
    };
    size_t i;
    for (i = 0; i < ARRAY_SIZE(adcToLux); i++) {
        if (index < adcToLux[i].adc_value) {
            return adcToLux[i].lux_value;
        }
    }
    return adcToLux[ARRAY_SIZE(adcToLux)-1].lux_value;
}
