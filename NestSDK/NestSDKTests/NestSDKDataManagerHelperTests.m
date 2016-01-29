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

#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>
#import "SpectaDSL.h"
#import "SPTSpec.h"
#import "NestSDKMetadataDataModel.h"
#import "NestSDKThermostatDataModel.h"
#import "NestSDKDataManagerHelper.h"
#import "NestSDKStructureDataModel.h"
#import "NestSDKCameraDataModel.h"
#import "NestSDKSmokeCOAlarmDataModel.h"
#import "NestSDKProductDataModel.h"


SpecBegin(NestSDKDataManagerHelper)
    {
        describe(@"NestSDKDataManagerHelper", ^{

            __block NSString *_metadataURL;
            __block NSString *_structuresURL;
            __block NSString *_structureURL;
            __block NSString *_thermostatURL;
            __block NSString *_smokeCOAlarmURL;
            __block NSString *_cameraURL;
            __block NSString *_productURL;

            beforeAll(^{
                _metadataURL = [NestSDKDataManagerHelper metadataURL];
                _structuresURL = [NestSDKDataManagerHelper structuresURL];
                _structureURL = [NestSDKDataManagerHelper structureURLWithStructureId:@"qwerty42"];
                _thermostatURL = [NestSDKDataManagerHelper thermostatURLWithThermostatId:@"t42"];
                _smokeCOAlarmURL = [NestSDKDataManagerHelper smokeCOAlarmURLWithSmokeCOAlarmId:@"s42"];
                _cameraURL = [NestSDKDataManagerHelper cameraURLWithCameraId:@"c42"];
                _productURL = [NestSDKDataManagerHelper productURLWithProductId:@"myproduct" caompanyId:@"mycompany"];
            });

            it(@"should return proper URLs", ^{
                expect(_metadataURL).to.equal(@"/");
                expect(_structuresURL).to.equal(@"structures/");
                expect(_structureURL).to.equal(@"structures/qwerty42/");
                expect(_thermostatURL).to.equal(@"devices/thermostats/t42/");
                expect(_smokeCOAlarmURL).to.equal(@"devices/smoke_co_alarms/s42/");
                expect(_cameraURL).to.equal(@"devices/cameras/c42/");
                expect(_productURL).to.equal(@"mycompany/myproduct/");
            });

            it(@"should return proper data model class", ^{
                expect([NestSDKDataManagerHelper dataModelClassWithURL:_metadataURL]).to.equal([NestSDKMetadataDataModel class]);
                expect([NestSDKDataManagerHelper dataModelClassWithURL:_structuresURL]).to.equal([NestSDKStructureDataModel class]);
                expect([NestSDKDataManagerHelper dataModelClassWithURL:_structureURL]).to.equal([NestSDKStructureDataModel class]);
                expect([NestSDKDataManagerHelper dataModelClassWithURL:_thermostatURL]).to.equal([NestSDKThermostatDataModel class]);
                expect([NestSDKDataManagerHelper dataModelClassWithURL:_smokeCOAlarmURL]).to.equal([NestSDKSmokeCOAlarmDataModel class]);
                expect([NestSDKDataManagerHelper dataModelClassWithURL:_cameraURL]).to.equal([NestSDKCameraDataModel class]);
                expect([NestSDKDataManagerHelper dataModelClassWithURL:_productURL]).to.equal([NestSDKProductDataModel class]);
            });
        });
    }
SpecEnd