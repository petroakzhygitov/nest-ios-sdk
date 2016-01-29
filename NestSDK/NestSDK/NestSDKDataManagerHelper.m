// Copyright (c) 2016 Petro Akzhygitov <petro.akzhygitov@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NestSDKDataManagerHelper.h"
#import "NestSDKMetadataDataModel.h"
#import "NestSDKThermostatDataModel.h"
#import "NestSDKSmokeCOAlarmDataModel.h"
#import "NestSDKCameraDataModel.h"
#import "NestSDKStructureDataModel.h"
#import "NestSDKProductDataModel.h"

#pragma mark const

static NSString *const kEndpointPathRoot = @"/";
static NSString *const kEndpointPathStructures = @"structures/";
static NSString *const kEndpointPathDevices = @"devices/";
static NSString *const kEndpointPathThermostats = @"thermostats/";
static NSString *const kEndpointPathSmokeCOAlarms = @"smoke_co_alarms/";
static NSString *const kEndpointPathCameras = @"cameras/";


@implementation NestSDKDataManagerHelper
#pragma mark Public

+ (NSString *)metadataURL {
    return kEndpointPathRoot;
}

+ (NSString *)structureURLWithStructureId:(NSString *)structureId {
    return [NSString stringWithFormat:@"%@%@/", [self structuresURL], structureId];
}

+ (NSString *)structuresURL {
    return kEndpointPathStructures;
}

+ (NSString *)thermostatURLWithThermostatId:(NSString *)thermostatId {
    return [NSString stringWithFormat:@"%@%@/", [self thermostatURL], thermostatId];
}

+ (NSString *)thermostatURL {
    return [NSString stringWithFormat:@"%@%@", kEndpointPathDevices, kEndpointPathThermostats];
}

+ (NSString *)smokeCOAlarmURLWithSmokeCOAlarmId:(NSString *)smokeCOAlarmId {
    return [NSString stringWithFormat:@"%@%@/", [self smokeCOAlarmURL], smokeCOAlarmId];
}

+ (NSString *)smokeCOAlarmURL {
    return [NSString stringWithFormat:@"%@%@", kEndpointPathDevices, kEndpointPathSmokeCOAlarms];
}

+ (NSString *)cameraURLWithCameraId:(NSString *)cameraId {
    return [NSString stringWithFormat:@"%@%@/", [self cameraURL], cameraId];
}

+ (NSString *)cameraURL {
    return [NSString stringWithFormat:@"%@%@", kEndpointPathDevices, kEndpointPathCameras];
}

+ (NSString *)productURLWithProductTypeId:(NSString *)productTypeId caompanyId:(NSString *)companyId {
    return [NSString stringWithFormat:@"%@/%@/", companyId, productTypeId];
}

+ (Class)dataModelClassWithURL:(NSString *)url {
    if ([url isEqualToString:[self metadataURL]]) {
        return [NestSDKMetadataDataModel class];

    } else if ([url hasPrefix:[self structuresURL]]) {
        return [NestSDKStructureDataModel class];

    } else if ([url hasPrefix:[self thermostatURL]]) {
        return [NestSDKThermostatDataModel class];

    } else if ([url hasPrefix:[self smokeCOAlarmURL]]) {
        return [NestSDKSmokeCOAlarmDataModel class];

    } else if ([url hasPrefix:[self cameraURL]]) {
        return [NestSDKCameraDataModel class];

    } else //if ([url ]) {
        return [NestSDKProductDataModel class];
    }

    return nil;
}

@end