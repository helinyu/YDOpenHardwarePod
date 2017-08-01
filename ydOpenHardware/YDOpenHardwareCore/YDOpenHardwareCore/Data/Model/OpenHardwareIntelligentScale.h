/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_intelligent_scale
 */
@interface OpenHardwareIntelligentScale : NSObject

@property (nonatomic, strong) NSNumber *ohiId;//对应数据库字段：ohi_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSDate *timeSec;//对应数据库字段：time_sec
@property (nonatomic, strong) NSNumber *weightG;//对应数据库字段：weight_g
@property (nonatomic, strong) NSNumber *heightCm;//对应数据库字段：height_cm
@property (nonatomic, strong) NSNumber *bodyFatPer;//对应数据库字段：body_fat_per
@property (nonatomic, strong) NSNumber *bodyMusclePer;//对应数据库字段：body_muscle_per
@property (nonatomic, strong) NSNumber *bodyMassIndex;//对应数据库字段：body_mass_index
@property (nonatomic, strong) NSNumber *basalMetabolismRate;//对应数据库字段：basal_metabolism_rate
@property (nonatomic, strong) NSNumber *bodyWaterPercentage;//对应数据库字段：body_water_percentage
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status


/**
 *  建立OpenHardwareIntelligentScale
 *
 *  @param ohi_id	对应属性：ohiId
 *  @param device_id	对应属性：deviceId
 *  @param time_sec	对应属性：timeSec
 *  @param weight_g	对应属性：weightG
 *  @param height_cm	对应属性：heightCm
 *  @param body_fat_per	对应属性：bodyFatPer
 *  @param body_muscle_per	对应属性：bodyMusclePer
 *  @param body_mass_index	对应属性：bodyMassIndex
 *  @param basal_metabolism_rate	对应属性：basalMetabolismRate
 *  @param body_water_percentage	对应属性：bodyWaterPercentage
 *  @param user_id	对应属性：userId
 *  @param extra_	对应属性：extra
 *  @param server_id	对应属性：serverId
 *  @param status_	对应属性：status
 */
- (void)constructByOhiId: (NSNumber *)ohi_id DeviceId: (NSString *)device_id TimeSec: (NSDate *)time_sec WeightG: (NSNumber *)weight_g HeightCm: (NSNumber *)height_cm BodyFatPer: (NSNumber *)body_fat_per BodyMusclePer: (NSNumber *)body_muscle_per BodyMassIndex: (NSNumber *)body_mass_index BasalMetabolismRate: (NSNumber *)basal_metabolism_rate BodyWaterPercentage: (NSNumber *)body_water_percentage UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_;

- (void)constructByModel: (id)model;

@end