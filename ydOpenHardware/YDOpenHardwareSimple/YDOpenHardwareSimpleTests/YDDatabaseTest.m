//
//  YDDatabaseTest.m
//  YDOpenHardwareSimpleTests
//
//  Created by Aka on 2017/8/14.
//  Copyright © 2017年 YD. All rights reserved.
//



#import <XCTest/XCTest.h>
#import "YDBluetoothWebViewMgr.h"

@interface YDDatabaseTest : XCTest

@property (nonatomic, strong) YDBluetoothWebViewMgr *mgr;

@end

@implementation YDDatabaseTest

- (void)setUp {
    
    _mgr = [YDBluetoothWebViewMgr shared];
    
}

- (void)tearDown {
    [super tearDown];
    
    _mgr = nil;
    
}

- (void)insertPedometer {
//    这里面跑路的接口，如何去写?
}

@end
