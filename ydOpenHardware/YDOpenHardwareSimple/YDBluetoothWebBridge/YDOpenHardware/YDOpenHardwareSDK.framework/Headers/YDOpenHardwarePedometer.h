/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_pedometer
 */
@interface YDOpenHardwarePedometer : NSObject

@property (nonatomic, strong) NSNumber *ohpId;//对应数据库字段：ohp_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSNumber *numberOfStep;//对应数据库字段：number_of_step
@property (nonatomic, strong) NSNumber *distance;//对应数据库字段：distance
@property (nonatomic, strong) NSNumber *calorie;//对应数据库字段：calorie
@property (nonatomic, strong) NSDate *startTime;//对应数据库字段：start_time
@property (nonatomic, strong) NSDate *endTime;//对应数据库字段：end_time
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status


/**
 *  建立OpenHardwarePedometer
 *
 *  @param ohp_id	对应属性：ohpId
 *  @param device_id	对应属性：deviceId
 *  @param number_of_step	对应属性：numberOfStep
 *  @param distance_	对应属性：distance
 *  @param calorie_	对应属性：calorie
 *  @param start_time	对应属性：startTime
 *  @param end_time	对应属性：endTime
 *  @param user_id	对应属性：userId
 *  @param extra_	对应属性：extra
 *  @param server_id	对应属性：serverId
 *  @param status_	对应属性：status
 */
- (void)constructByOhpId: (NSNumber *)ohp_id DeviceId: (NSString *)device_id NumberOfStep: (NSNumber *)number_of_step Distance: (NSNumber *)distance_ Calorie: (NSNumber *)calorie_ StartTime: (NSDate *)start_time EndTime: (NSDate *)end_time UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_;

- (void)constructByModel: (id)model;

@end