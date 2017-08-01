/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "YDOpenHardwareDevice.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_device
 */
@implementation YDOpenHardwareDevice

/**
 *  建立OpenHardwareDevice
 *
 *  @param ohd_id	对应属性：ohdId
 *  @param device_id	对应属性：deviceId
 *  @param plug_name	对应属性：plugName
 *  @param user_id	对应属性：userId
 *  @param extra_	对应属性：extra
 *  @param server_id	对应属性：serverId
 *  @param status_	对应属性：status
 */
- (void)constructByOhdId: (NSNumber *)ohd_id DeviceId: (NSString *)device_id PlugName: (NSString *)plug_name UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_ {
    if (self) {
        self.ohdId = ohd_id;
        self.deviceId = device_id;
        self.plugName = plug_name;
        self.userId = user_id;
        self.extra = extra_;
        self.serverId = server_id;
        self.status = status_;
    }
}

- (void)constructByModel: (id)model {
    if (self) {
        self.ohdId = [model valueForKey: @"ohdId"];
        self.deviceId = [model valueForKey: @"deviceId"];
        self.plugName = [model valueForKey: @"plugName"];
        self.userId = [model valueForKey: @"userId"];
        self.extra = [model valueForKey: @"extra"];
        self.serverId = [model valueForKey:@"serverId"];
        self.status = [model valueForKey:@"status"];
    }
}



@end