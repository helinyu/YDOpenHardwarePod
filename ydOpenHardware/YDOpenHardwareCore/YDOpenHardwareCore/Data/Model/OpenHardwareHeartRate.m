/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "OpenHardwareHeartRate.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_heart_rate
 */
@implementation OpenHardwareHeartRate

@synthesize ohhId, deviceId, heartRate, startTime, endTime, userId, extra, serverId, status;


/**
 *  建立OpenHardwareHeartRate
 *
 *  @param ohh_id	对应属性：ohhId
 *  @param device_id	对应属性：deviceId
 *  @param heart_rate	对应属性：heartRate
 *  @param start_time	对应属性：startTime
 *  @param end_time	对应属性：endTime
 *  @param user_id	对应属性：userId
 *  @param extra_	对应属性：extra
 *  @param server_id	对应属性：serverId
 *  @param status_	对应属性：status
 */
- (void)constructByOhhId: (NSNumber *)ohh_id DeviceId: (NSString *)device_id HeartRate: (NSNumber *)heart_rate StartTime: (NSDate *)start_time EndTime: (NSDate *)end_time UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_ {
	if (self) {
		self.ohhId = ohh_id;
		self.deviceId = device_id;
		self.heartRate = heart_rate;
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
        self.ohhId = [model valueForKey: @"ohhId"];
        self.deviceId = [model valueForKey: @"deviceId"];
        self.heartRate = [model valueForKey: @"heartRate"];
        self.startTime = [model valueForKey: @"startTime"];
        self.endTime = [model valueForKey: @"endTime"];
        self.userId = [model valueForKey: @"userId"];
        self.extra = [model valueForKey: @"extra"];
        self.serverId = [model valueForKey:@"serverId"];
        self.status = [model valueForKey:@"status"];
    }
}

@end