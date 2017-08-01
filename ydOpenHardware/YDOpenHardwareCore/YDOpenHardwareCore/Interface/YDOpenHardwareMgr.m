//
//  YDOpenHardwareMgr.m
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/2/5.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDOpenHardwareMgr.h"

#import "YDOpenHardwareDB.h"
#import "OpenHardwareDeviceDBDAO.h"

#import "YDOpenHardwareDP.h"

static YDOpenHardwareMgr *sOpenHardwareMgr;
static Class sThirdPartViewClass;
static NSString *const ydDeviceIdentityHead = @"yd_device_identity_";

@interface YDOpenHardwareMgr () {
}

@end

@implementation YDOpenHardwareMgr


+ (instancetype)sharedMgr {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sOpenHardwareMgr == nil) {
            sOpenHardwareMgr = [YDOpenHardwareMgr new];
            [sOpenHardwareMgr msInit];
        }
    });
    return sOpenHardwareMgr;
}

+ (YDOpenHardwareDP *)dataProvider {
    return [YDOpenHardwareDP sharedDP];
}

- (void)msInit {

}

/**
 *  绑定硬件设备后需要向悦动圈注册设备
 *
 *  @param device_id 第三方设备id
 *  @param plug_name 第三方标识名称
 *  @param user_id         悦动圈用户id
 *  @param block     回调，返回是否成功悦动圈提供的设备id和绑定的userId
 */
- (void)registerDevice: (NSString *)device_id plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareRegisterBlock)block; {
    if (device_id == nil || plug_name == nil) {
#ifdef DEBUG
        NSLog(@"\nregisterDevice: %@, plug: %@, success: %i", device_id, plug_name, NO);
#endif
        block(YDOpenHardwareOperateStateFailParamsError, nil, nil);

        return;
    }
    
    NSString *device_identity = [self getDeviceIdentity:plug_name deviceId:device_id userId:user_id];
    
    __block OpenHardwareDevice *ohd = [[OpenHardwareDevice alloc] init];
    [ohd constructByOhdId: nil DeviceId: device_identity PlugName: plug_name UserId: user_id Extra: @"" ServerId:@(-1) Status:@(0)];
    
    __block BOOL flag = NO;
    __block YDOpenHardwareOperateState state = YDOpenHardwareOperateStateSuccess;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        if ([OpenHardwareDeviceDBDAO selectOpenHardwareDeviceByDevice: ohd fromDb: db]) {
            flag = NO;
            state = YDOpenHardwareOperateStateFailIsExist;
            return;
        }
        flag = [OpenHardwareDeviceDBDAO insertOpenHardwareDevice: ohd intoDb: db];
        if (flag) {
            state = YDOpenHardwareOperateStateSuccess;
        } else {
            state = YDOpenHardwareOperateStateFailDBError;
        }
    } completHandler: ^{
#ifdef DEBUG
        NSLog(@"\nregisterDevice: %@, plug: %@, success: %i", device_id, plug_name, flag);
#endif
        block(state, device_identity, user_id);
    }];
    

    
    return;
}

/**
 *  解除绑定设备后要注销
 *
 *  @param device_identity 悦动提供的设备id
 *  @param plug_name       第三方标识名称
 *  @param user_id         悦动圈用户id
 *  @param block           回调，返回是否成功
 */
- (void)unRegisterDevice: (NSString *)device_identity plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareOperateBlock)block {
    if (device_identity == nil || plug_name == nil || user_id == nil) {
#ifdef DEBUG
        NSLog(@"\nunRegisterDevice: %@, plug:%@, user:%@, success: %i", device_identity, plug_name, user_id, NO);
#endif
        block(YDOpenHardwareOperateStateFailParamsError);

        return;
    }
    
    __block OpenHardwareDevice *ohd = [[OpenHardwareDevice alloc] init];
    [ohd constructByOhdId: nil DeviceId: device_identity PlugName: plug_name UserId: user_id Extra: @"" ServerId:@(-1) Status:@(0)];
    
    __block BOOL flag = NO;
    __block YDOpenHardwareOperateState state = YDOpenHardwareOperateStateSuccess;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        if (![OpenHardwareDeviceDBDAO selectOpenHardwareDeviceByDevice: ohd fromDb: db]) {
            flag = NO;
            state = YDOpenHardwareOperateStateFailNotExist;
            return;
        }
        flag = [OpenHardwareDeviceDBDAO deleteOpenHardwareDeviceByPk: ohd ofDb: db];
        if (flag) {
            state = YDOpenHardwareOperateStateSuccess;
        } else {
            state = YDOpenHardwareOperateStateFailDBError;
        }
    } completHandler: ^{
#ifdef DEBUG
        NSLog(@"\nunRegisterDevice: %@, plug:%@, user:%@, success: %i", device_identity, plug_name, user_id, flag);
#endif
        block(state);
    }];

    
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
    if (device_id == nil || user_id == nil) {
#ifdef DEBUG
        NSLog(@"\nisRegistered: %@, plug:%@, user:%@, success: %i", device_id, plug_name, user_id, NO);
#endif
        block(YDOpenHardwareOperateStateFailParamsError, nil);
        return;
    }
    NSString *device_identity = [self getDeviceIdentity:plug_name deviceId:device_id userId:user_id];
    
    __block OpenHardwareDevice *ohd = [[OpenHardwareDevice alloc] init];
    [ohd constructByOhdId: nil DeviceId: device_identity PlugName: plug_name UserId: user_id Extra: @"" ServerId:@(-1) Status:@(0)];
    
    __block BOOL flag = NO;
    __block BOOL isRegistered = NO;
    __block YDOpenHardwareOperateState state = YDOpenHardwareOperateStateNotRegistered;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        if ([OpenHardwareDeviceDBDAO selectOpenHardwareDeviceByDevice: ohd fromDb: db]) {
            isRegistered = YES;
            state = YDOpenHardwareOperateStateHasRegistered;
        } else {
            state = YDOpenHardwareOperateStateNotRegistered;
        }
        flag = YES;
    } completHandler: ^{
#ifdef DEBUG
        NSLog(@"\n%@ isRegistered: %i, plug:%@, user:%@, success: %i", device_identity, isRegistered, plug_name, user_id, flag);
#endif
        block(state, device_identity);
    }];
}

/**
 *  是否注册
 *
 *  @param device_identity 悦动提供的设备id
 *  @param plug_name 第三方标识名称
 *  @param user_id   用户id
 *  @param block     回调，返回
 */
- (void)isYDRegistered: (NSString *)device_identity plug: (NSString *)plug_name user: (NSNumber *)user_id block: (YDOpenHardwareRegisterStateBlock)block {
    if (device_identity == nil || user_id == nil) {
#ifdef DEBUG
        NSLog(@"\nisRegistered: %@, plug:%@, user:%@, success: %i", device_identity, plug_name, user_id, NO);
#endif
        block(YDOpenHardwareOperateStateFailParamsError, nil);
        return;
    }
    
    __block OpenHardwareDevice *ohd = [[OpenHardwareDevice alloc] init];
    [ohd constructByOhdId: nil DeviceId: device_identity PlugName: plug_name UserId: user_id Extra: @"" ServerId:@(-1) Status:@(0)];
    
    __block BOOL flag = NO;
    __block BOOL isRegistered = NO;
    __block YDOpenHardwareOperateState state = YDOpenHardwareOperateStateNotRegistered;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        if ([OpenHardwareDeviceDBDAO selectOpenHardwareDeviceByDevice: ohd fromDb: db]) {
            isRegistered = YES;
            state = YDOpenHardwareOperateStateHasRegistered;
        } else {
            state = YDOpenHardwareOperateStateNotRegistered;
        }
        flag = YES;
    } completHandler: ^{
#ifdef DEBUG
        NSLog(@"\n%@ isRegistered: %i, plug:%@, user:%@, success: %i", device_identity, isRegistered, plug_name, user_id, flag);
#endif
        block(state, device_identity);
    }];
}

/**
 *  获取当前的用户
 *
 *  @return 当前的用户信息
 */
- (YDOpenHardwareUser *)getCurrentUser {
    Class userClass = NSClassFromString(@"YDOpenHardwareUser");
    id user = [[userClass alloc] init];
    [user setValue:@"广东省" forKey:@"province"];
    [user setValue:@"深圳市" forKey:@"city"];
    [user setValue:@133 forKey:@"userID"];
    [user setValue:@1 forKey:@"rank"];
    [user setValue:@0 forKey:@"sex"];
    [user setValue:@"test" forKey:@"nick"];
    [user setValue:@"乒乓球" forKey:@"loveSports"];
    [user setValue:@"13311112222" forKey:@"phone"];
    [user setValue:@"这是签名" forKey:@"signature"];
    [user setValue:@170 forKey:@"height"];
    [user setValue:@60000 forKey:@"weight"];
    [user setValue:[NSDate dateWithTimeIntervalSince1970: 694195200] forKey:@"birth"];
    return (YDOpenHardwareUser *)user;
}

- (NSString *)getDeviceIdentity:(NSString *)plug deviceId:(NSString *)deviceId userId:(NSNumber *)userId {
//    if (!userId) {
//        userId = [YDAppInstance userId];
//    }
    deviceId = [deviceId stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    return [NSString stringWithFormat:@"%@-%@-%@", userId, plug, deviceId];
}

@end
