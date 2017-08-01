/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "YDOpenHardwareIntelligentScale.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_intelligent_scale
 */
@implementation YDOpenHardwareIntelligentScale

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
- (void)constructByOhiId: (NSNumber *)ohi_id DeviceId: (NSString *)device_id TimeSec: (NSDate *)time_sec WeightG: (NSNumber *)weight_g HeightCm: (NSNumber *)height_cm BodyFatPer: (NSNumber *)body_fat_per BodyMusclePer: (NSNumber *)body_muscle_per BodyMassIndex: (NSNumber *)body_mass_index BasalMetabolismRate: (NSNumber *)basal_metabolism_rate BodyWaterPercentage: (NSNumber *)body_water_percentage UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_ {
    if (self) {
        self.ohiId = ohi_id;
        self.deviceId = device_id;
        self.timeSec = time_sec;
        self.weightG = weight_g;
        self.heightCm = height_cm;
        self.bodyFatPer = body_fat_per;
        self.bodyMusclePer = body_muscle_per;
        self.bodyMassIndex = body_mass_index;
        self.basalMetabolismRate = basal_metabolism_rate;
        self.bodyWaterPercentage = body_water_percentage;
        self.userId = user_id;
        self.extra = extra_;
        self.serverId = server_id;
        self.status = status_;
    }
}

- (void)constructByModel: (id)model {
    if (self) {
        self.ohiId = [model valueForKey: @"ohiId"];
        self.deviceId = [model valueForKey: @"deviceId"];
        self.timeSec = [model valueForKey: @"timeSec"];
        self.weightG = [model valueForKey: @"weightG"];
        self.heightCm = [model valueForKey: @"heightCm"];
        self.bodyFatPer = [model valueForKey: @"bodyFatPer"];
        self.bodyMusclePer = [model valueForKey: @"bodyMusclePer"];
        self.bodyMassIndex = [model valueForKey: @"bodyMassIndex"];
        self.basalMetabolismRate = [model valueForKey: @"basalMetabolismRate"];
        self.bodyWaterPercentage = [model valueForKey: @"bodyWaterPercentage"];
        self.userId = [model valueForKey: @"userId"];
        self.extra = [model valueForKey: @"extra"];
        self.serverId = [model valueForKey:@"serverId"];
        self.status = [model valueForKey:@"status"];
    }
}

@end