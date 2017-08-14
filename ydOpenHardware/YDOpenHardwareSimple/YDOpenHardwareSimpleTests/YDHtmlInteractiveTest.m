//
//  YDHtmlInteractiveTest.m
//  YDOpenHardwareSimpleTests
//
//  Created by Aka on 2017/8/14.
//  Copyright © 2017年 YD. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "YDBlueToothMgr.h"

@interface YDHtmlInteractiveTest : XCTestCase

@property (nonatomic, strong) YDBlueToothMgr *mgr;

@end

@implementation YDHtmlInteractiveTest

/*!
 * @method +setUp
 * Setup method called before the invocation of any test method in the class.
 */
- (void)setUp {
    _mgr = [YDBlueToothMgr shared];
}

/*!
 * @method +testDown
 * Teardown method called after the invocation of every test method in the class.
 */
- (void)tearDown {
    
}

- (void)testHtml{

}

@end
