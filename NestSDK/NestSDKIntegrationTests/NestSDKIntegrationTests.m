//
//  NestSDKIntegrationTests.m
//  NestSDKIntegrationTests
//
//  Created by Petro Akzhygitov on 10/02/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NestSDKIntegrationTests : XCTestCase

@end

@implementation NestSDKIntegrationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSLog(@"Token: %@", [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"NestSDKAccessToken"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
