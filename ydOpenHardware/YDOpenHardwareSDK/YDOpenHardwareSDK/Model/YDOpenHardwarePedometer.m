/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "YDOpenHardwarePedometer.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_pedometer
 */
@implementation YDOpenHardwarePedometer



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
- (void)constructByOhpId: (NSNumber *)ohp_id DeviceId: (NSString *)device_id NumberOfStep: (NSNumber *)number_of_step Distance: (NSNumber *)distance_ Calorie: (NSNumber *)calorie_ StartTime: (NSDate *)start_time EndTime: (NSDate *)end_time UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_ {
    if (self) {
        self.ohpId = ohp_id;
        self.deviceId = device_id;
        self.numberOfStep = number_of_step;
        self.distance = distance_;
        self.calorie = calorie_;
        self.startTime = start_time;
        self.endTime = end_time;
        self.userId = user_id;
        self.extra = extra_;
        self.serverId = server_id;
        self.status = status_;
    }
}

- (void)constructByModel: (id)model {
    if (self) {
        self.ohpId = [model valueForKey: @"ohpId"];
        self.deviceId = [model valueForKey: @"deviceId"];
        self.numberOfStep = [model valueForKey: @"numberOfStep"];
        self.distance = [model valueForKey: @"distance"];
        self.calorie = [model valueForKey: @"calorie"];
        self.startTime = [model valueForKey: @"startTime"];
        self.endTime = [model valueForKey: @"endTime"];
        self.userId = [model valueForKey: @"userId"];
        self.extra = [model valueForKey: @"extra"];
        self.serverId = [model valueForKey:@"serverId"];
        self.status = [model valueForKey:@"status"];
    }
}

@end