//
//  YDOpenHardwareManager.m
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/3.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDOpenHardwareManager.h"

#import "YDOpenHardwareDataProvider.h"

#import "YDOpenHardwareUser.h"

static YDOpenHardwareManager *sOpenHardwareManager;
static NSString *const innerOpenHardwareMgrClassName = @"YDOpenHardwareMgr";
static NSString *const innerOpenHardwareMgrInstanceSelector = @"sharedMgr";

@interface YDOpenHardwareManager ()

@property (weak, nonatomic) id delegate;

@end

@implementation YDOpenHardwareManager

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sOpenHardwareManager == nil) {
            sOpenHardwareManager = [[YDOpenHardwareManager alloc] initPrivate];
            [sOpenHardwareManager msInit];
        }
    });
    return sOpenHardwareManager;
}

- (void)msInit {
    Class innerClass = NSClassFromString(innerOpenHardwareMgrClassName);
    SEL innerSel = NSSelectorFromString(innerOpenHardwareMgrInstanceSelector);
    
    if (innerClass && innerSel && [innerClass respondsToSelector: innerSel]) {
        id delegate_;
        SuppressPerformSelectorLeakWarning(
            delegate_ = [innerClass performSelector: innerSel];
        );
        self.delegate = delegate_;
        
    }
}


- (void)registerDevice: (NSString *)device_id plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareRegisterBlock)block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(registerDevice:plug:user:block:)]) {
        [self.delegate registerDevice: device_id plug: plug_name user: user_id block: block];
    } else {
        block(YDOpenHardwareOperateStateFailInnerError, nil, nil);
    }
    return;
}

- (void)unRegisterDevice: (NSString *)device_identity plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareOperateBlock)block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(unRegisterDevice:plug:user:block:)]) {
        return [self.delegate unRegisterDevice: device_identity plug: plug_name user: user_id block: block];
    } else {
        block(YDOpenHardwareOperateStateFailInnerError);
    }
    return;
}

/**
 *  是否注册
 *
 *  @param device_id 第三方设备id
 *  @param plug_name 第三方标识名称
 *  @param user_id   用户id
 *  @param block     回调，返回
 */
- (void)isRegistered: (NSString *)device_id plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareRegisterStateBlock)block {
    if (self.delegate && [self.delegate respondsToSelector:@selector(isRegistered:plug:user:block:)]) {
        return [self.delegate isRegistered: device_id plug: plug_name user: user_id block: block];
    } else {
        block(YDOpenHardwareOperateStateFailInnerError, nil);
    }
    return;
}

/**
 *  获取当前的用户
 *
 *  @return 当前的用户信息
 */
- (YDOpenHardwareUser *)getCurrentUser {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentUser)]) {
        return [self.delegate getCurrentUser];
    }
    return nil;
}

/**
 *  数据提供接口
 *
 *  @return 数据提供接口
 */
+ (YDOpenHardwareDataProvider *)dataProvider {
    return [YDOpenHardwareDataProvider dataProvider];
}




@end
