//
//  YDOpenHardwareDP.h
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/2/22.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OpenHardwareIntelligentScale;
@class OpenHardwareHeartRate;
@class OpenHardwarePedometer;
@class OpenHardwareSleep;

@interface YDOpenHardwareDP : NSObject

+ (instancetype)sharedDP;

#pragma mark 体重秤
/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertIntelligentScale: (id)is completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewIntelligentScaleByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwareIntelligentScale *is))block;

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
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwareIntelligentScale *> *))block;

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
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwareIntelligentScale *> *))block;

#pragma mark 心率

/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertHeartRate: (id)obj completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewHeartRateByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwareHeartRate *obj))block;

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
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwareHeartRate *> *))block;

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
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwareHeartRate *> *))block;


#pragma mark 计步

/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertPedometer: (id)obj completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewPedometerByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwarePedometer *obj))block;

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
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwarePedometer *> *))block;

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
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwarePedometer *> *))block;


#pragma mark 睡眠

/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertSleep: (id)obj completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewSleepByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, OpenHardwareSleep *obj))block;

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
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<OpenHardwareSleep *> *))block;

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
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<OpenHardwareSleep *> *))block;

@end
