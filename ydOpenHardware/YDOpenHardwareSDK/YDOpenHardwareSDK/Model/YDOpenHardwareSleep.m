/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "YDOpenHardwareSleep.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_sleep
 */
@implementation YDOpenHardwareSleep

/**
 *  建立OpenHardwareSleep
 *
 *  @param ohs_id	对应属性：ohsId
 *  @param device_id	对应属性：deviceId
 *  @param sleep_sec	对应属性：sleepSec
 *  @param sleep_section	对应属性：sleepSection
 *  @param start_time	对应属性：startTime
 *  @param end_time	对应属性：endTime
 *  @param user_id	对应属性：userId
 *  @param extra_	对应属性：extra
 *  @param server_id	对应属性：serverId
 *  @param status_	对应属性：status
 */
- (void)constructByOhsId: (NSNumber *)ohs_id DeviceId: (NSString *)device_id SleepSec: (NSNumber *)sleep_sec SleepSection: (NSNumber *)sleep_section StartTime: (NSDate *)start_time EndTime: (NSDate *)end_time UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_ {
    if (self) {
        self.ohsId = ohs_id;
        self.deviceId = device_id;
        self.sleepSec = sleep_sec;
        self.sleepSection = sleep_section;
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
        self.ohsId = [model valueForKey: @"ohsId"];
        self.deviceId = [model valueForKey: @"deviceId"];
        self.sleepSec = [model valueForKey: @"sleepSec"];
        self.sleepSection = [model valueForKey: @"sleepSection"];
        self.startTime = [model valueForKey: @"startTime"];
        self.endTime = [model valueForKey: @"endTime"];
        self.userId = [model valueForKey: @"userId"];
        self.extra = [model valueForKey: @"extra"];
        self.serverId = [model valueForKey:@"serverId"];
        self.status = [model valueForKey:@"status"];
    }
}

@end