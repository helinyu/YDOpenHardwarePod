//
//  YDOpenHardwareManager.h
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/3.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YDOpenHardwareSDKDefine.h"
@class YDOpenHardwareDataProvider;
@class YDOpenHardwareUser;

@interface YDOpenHardwareManager : NSObject


+ (instancetype)sharedManager;

- (instancetype)init YD_UNAVAILABLE("用 + (instancetype)sharedManager 获取实例.");

/**
 *  绑定硬件设备后需要向悦动圈注册设备
 *
 *  @param device_id 第三方设备id
 *  @param plug_name 第三方标识名称
 *  @param user_id         悦动圈用户id
 *  @param block     回调，返回是否成功悦动圈提供的设备id和绑定的userId
 */
- (void)registerDevice: (NSString *)device_id plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareRegisterBlock)block;

/**
 *  解除绑定设备后要注销
 *
 *  @param device_identity 悦动提供的设备id
 *  @param plug_name       第三方标识名称
 *  @param user_id         悦动圈用户id
 *  @param block           回调，返回是否成功
 */
- (void)unRegisterDevice: (NSString *)device_identity plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareOperateBlock)block;

/**
 *  是否注册
 *
 *  @param device_id 第三方设备id
 *  @param plug_name 第三方标识名称
 *  @param user_id   用户id
 *  @param block     回调，返回
 */
- (void)isRegistered: (NSString *)device_id plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareRegisterStateBlock)block;

/**
 *  获取当前的用户
 *
 *  @return 当前的用户信息
 */
- (YDOpenHardwareUser *)getCurrentUser;

/**
 *  数据提供接口
 *
 *  @return 数据提供接口
 */
+ (YDOpenHardwareDataProvider *)dataProvider;



@end
