//
//  NestSDKTests.m
//  NestSDKTests
//
//  Created by Petro Akzhygitov on 7/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JSONModel/JSONModel.h>
#import "NestSDKThermostatDataModel.h"

@interface NestSDKTests : XCTestCase

@end

@implementation NestSDKTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *resourcePath = [NSBundle bundleForClass:[self class]].resourcePath;
    NSString *dataPath = [resourcePath stringByAppendingPathComponent:@"thermostat.json"];

    NSData *data = [NSData dataWithContentsOfFile:dataPath];

    NSError *error;
    NestSDKThermostatDataModel *thermostat = [[NestSDKThermostatDataModel alloc] initWithData:data error:&error];
    NSLog(@"Properties: %@", [thermostat toWritableDataModelDictionary]);
//    NestSDKThermostat2 *thermostat2 = (id) thermostat;
//    NSLog(@"%@", [thermostat2 toDictionary]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
