//
//  YDOpenHardwareMgr.h
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/2/5.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YDOpenHardwareMgrProtocol.h"
#import "YDOpenHardwareCoreDefine.h"

@class YDOpenHardwareDP;

@interface YDOpenHardwareMgr : NSObject<YDOpenHardwareMgrProtocol>

+ (instancetype)sharedMgr;

- (instancetype)init YD_UNAVAILABLE("用 + (instancetype)sharedMgr 获取实例.");

+ (YDOpenHardwareDP *)dataProvider;


@end
