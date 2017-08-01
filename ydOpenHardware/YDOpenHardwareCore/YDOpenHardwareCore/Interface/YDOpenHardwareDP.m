//
//  YDOpenHardwareDP.m
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/2/22.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDOpenHardwareDP.h"

#import "YDOpenHardwareMgr.h"

#import "YDOpenHardwareDB.h"
#import "OpenHardwareIntelligentScaleDBDAO.h"
#import "OpenHardwareHeartRateDBDAO.h"
#import "OpenHardwarePedometerDBDAO.h"
#import "OpenHardwareSleepDBDAO.h"


static YDOpenHardwareDP *sOpenHardwareDP = nil;

@implementation YDOpenHardwareDP

+ (instancetype)sharedDP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sOpenHardwareDP == nil) {
            sOpenHardwareDP = [[YDOpenHardwareDP alloc] init];
        }
    });
    return sOpenHardwareDP;
}

#pragma mark 体重秤
/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertIntelligentScale: (id)is completion: (void(^)(BOOL success))block {
    OpenHardwareIntelligentScale *is_t = [[OpenHardwareIntelligentScale alloc] init];
    [is_t constructByModel: is];
    
    [[YDOpenHardwareMgr sharedMgr] isYDRegistered: is_t.deviceId plug: nil user: is_t.userId block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity) {
        if (operateState == YDOpenHardwareOperateStateHasRegistered) {
            __block BOOL flag = NO;
            [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
                flag = [OpenHardwareIntelligentScaleDBDAO insertOpenHardwareIntelligentScale: is_t intoDb: db];
            } completHandler: ^{
                if (is && [is respondsToSelector: @selector(constructByModel:)]) {
                    [is constructByModel: is_t];
                }
                block(flag);
            }];
        } else {
#ifdef DEBUG
            NSLog(@"\nneed register!");
#endif
            block(NO);
        }
    }];
    
    
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewIntelligentScaleByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwareIntelligentScale *is))block {
    __block BOOL flag = NO;
    __block OpenHardwareIntelligentScale *is_t = [[OpenHardwareIntelligentScale alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        flag = [OpenHardwareIntelligentScaleDBDAO selectNewOpenHardwareIntelligentScale: is_t byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        block(flag, is_t);
    }];
}


/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end, start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwareIntelligentScale *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwareIntelligentScaleDBDAO selectIntelligentScaleByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwareIntelligentScale *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwareIntelligentScaleDBDAO selectIntelligentScaleByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}

/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertHeartRate: (id)obj completion: (void(^)(BOOL success))block {
    OpenHardwareHeartRate *obj_t = [[OpenHardwareHeartRate alloc] init];
    [obj_t constructByModel: obj];
    
    [[YDOpenHardwareMgr sharedMgr] isYDRegistered: obj_t.deviceId plug: nil user: obj_t.userId block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity) {
        if (operateState == YDOpenHardwareOperateStateHasRegistered) {
            __block BOOL flag = NO;
            [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
                flag = [OpenHardwareHeartRateDBDAO insertOpenHardwareHeartRate: obj_t intoDb: db];
            } completHandler: ^{
                if (obj && [obj respondsToSelector: @selector(constructByModel:)]) {
                    [obj constructByModel: obj_t];
                }
                block(flag);
            }];
        } else {
#ifdef DEBUG
            NSLog(@"\nneed register!");
#endif
            block(NO);
        }
    }];
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewHeartRateByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwareHeartRate *obj))block {
    __block BOOL flag = NO;
    __block OpenHardwareHeartRate *obj_t = [[OpenHardwareHeartRate alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        flag = [OpenHardwareHeartRateDBDAO selectNewOpenHardwareHeartRate: obj_t byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        block(flag, obj_t);
    }];
}

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwareHeartRate *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwareHeartRateDBDAO selectHeartRateByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwareHeartRate *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwareHeartRateDBDAO selectHeartRateByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}

#pragma mark 计步

/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertPedometer: (id)obj completion: (void(^)(BOOL success))block {
    OpenHardwarePedometer *obj_t = [[OpenHardwarePedometer alloc] init];
    [obj_t constructByModel: obj];
    
    [[YDOpenHardwareMgr sharedMgr] isYDRegistered: obj_t.deviceId plug: nil user: obj_t.userId block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity) {
        if (operateState == YDOpenHardwareOperateStateHasRegistered) {
            __block BOOL flag = NO;
            [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
                flag = [OpenHardwarePedometerDBDAO insertOpenHardwarePedometer: obj_t intoDb: db];
            } completHandler: ^{
                if (obj && [obj respondsToSelector: @selector(constructByModel:)]) {
                    [obj constructByModel: obj_t];
                }
                block(flag);
            }];
        } else {
#ifdef DEBUG
            NSLog(@"\nneed register!");
#endif
            block(NO);
        }
    }];
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewPedometerByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwarePedometer *obj))block {
    __block BOOL flag = NO;
    __block OpenHardwarePedometer *obj_t = [[OpenHardwarePedometer alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        flag = [OpenHardwarePedometerDBDAO selectNewOpenHardwarePedometer: obj_t byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        block(flag, obj_t);
    }];
}

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwarePedometer *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwarePedometerDBDAO selectPedometerByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwarePedometer *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwarePedometerDBDAO selectPedometerByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}


#pragma mark 睡眠

/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertSleep: (id)obj completion: (void(^)(BOOL success))block {
    OpenHardwareSleep *obj_t = [[OpenHardwareSleep alloc] init];
    [obj_t constructByModel: obj];
    
    [[YDOpenHardwareMgr sharedMgr] isYDRegistered: obj_t.deviceId plug: nil user: obj_t.userId block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity) {
        if (operateState == YDOpenHardwareOperateStateHasRegistered) {
            __block BOOL flag = NO;
            [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
                flag = [OpenHardwareSleepDBDAO insertOpenHardwareSleep: obj_t intoDb: db];
            } completHandler: ^{
                if (obj && [obj respondsToSelector: @selector(constructByModel:)]) {
                    [obj constructByModel: obj_t];
                }
                block(flag);
            }];
        } else {
#ifdef DEBUG
            NSLog(@"\nneed register!");
#endif
            block(NO);
        }
    }];
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewSleepByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwareSleep *obj))block {
    __block BOOL flag = NO;
    __block OpenHardwareSleep *obj_t = [[OpenHardwareSleep alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        flag = [OpenHardwareSleepDBDAO selectNewOpenHardwareSleep: obj_t byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        block(flag, obj_t);
    }];
}

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwareSleep *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwareSleepDBDAO selectSleepByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwareSleep *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(FMDatabase *db) {
        arr = [OpenHardwareSleepDBDAO selectSleepByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        block(flag, arr);
    }];
}

@end
