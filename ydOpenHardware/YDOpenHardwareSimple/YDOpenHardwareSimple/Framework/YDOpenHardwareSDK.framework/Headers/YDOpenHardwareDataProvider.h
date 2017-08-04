//
//  YDOpenHardwareDataProvider.h
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/19.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YDOpenHardwareSDKDefine.h"

@class YDOpenHardwareIntelligentScale;
@class YDOpenHardwareHeartRate;
@class YDOpenHardwarePedometer;
@class YDOpenHardwareSleep;



@interface YDOpenHardwareDataProvider : NSObject

- (instancetype)init YD_UNAVAILABLE("用 YDOpenHardwareManager 类的 + (YDOpenHardwareDataProvider *)dataProvider 获取实例.");


/**
 *  数据提供接口
 *
 *  @return 数据提供接口
 */
+ (YDOpenHardwareDataProvider *)dataProvider;

#pragma mark 体重秤

/**
 *  插入新记录,插入成功后会自动更新传入数据的主键
 *
 *  @param ohModel    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertIntelligentScale: (YDOpenHardwareIntelligentScale *)ohModel completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录,前两个参数可以同时为空或者同时不为空
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewIntelligentScaleByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareIntelligentScale *ohModel))block;

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *))block;

/**
 *  根据条件分页获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空),从1开始
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *))block;

#pragma mark 心率

/**
 *  插入新记录,插入成功后会自动更新传入数据的主键
 *
 *  @param ohModel    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertHeartRate: (YDOpenHardwareHeartRate *)ohModel completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录,前两个参数可以同时为空或者同时不为空
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewHeartRateByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareHeartRate *ohModel))block;

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareHeartRate *> *))block;

/**
 *  根据条件分页获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空),从1开始
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareHeartRate *> *))block;


#pragma mark 计步

/**
 *  插入新记录,插入成功后会自动更新传入数据的主键
 *
 *  @param ohModel    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertPedometer: (YDOpenHardwarePedometer *)ohModel completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录,前两个参数可以同时为空或者同时不为空
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewPedometerByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwarePedometer *ohModel))block;

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwarePedometer *> *))block;

/**
 *  根据条件分页获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空),从1开始
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwarePedometer *> *))block;


#pragma mark 睡眠

/**
 *  插入新记录,插入成功后会自动更新传入数据的主键
 *
 *  @param ohModel    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertSleep: (YDOpenHardwareSleep *)ohModel completion: (void(^)(BOOL success))block;

/**
 *  获取最新一条记录,前两个参数可以同时为空或者同时不为空
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewSleepByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareSleep *ohModel))block;

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareSleep *> *))block;

/**
 *  根据条件分页获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end,start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空),从1开始
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareSleep *> *))block;

@end
