//
//  YDOpenHardwareSimpleTests.m
//  YDOpenHardwareSimpleTests
//
//  Created by 张旻可 on 16/2/2.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YDBlueToothMgr.h"

@interface YDOpenHardwareSimpleTests : XCTestCase

@property (nonatomic, strong) YDBlueToothMgr *btMgr;

@end

@implementation YDOpenHardwareSimpleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _btMgr = [YDBlueToothMgr shared];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    _btMgr.stopScan();
    _btMgr = nil;
}

- (void)testScan {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
