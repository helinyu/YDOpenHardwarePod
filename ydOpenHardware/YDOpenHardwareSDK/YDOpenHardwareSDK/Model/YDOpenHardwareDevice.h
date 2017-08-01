/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_device
 */
@interface YDOpenHardwareDevice : NSObject

@property (nonatomic, strong) NSNumber *ohdId;//对应数据库字段：ohd_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSString *plugName;//对应数据库字段：plug_name
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status


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
- (void)constructByOhdId: (NSNumber *)ohd_id DeviceId: (NSString *)device_id PlugName: (NSString *)plug_name UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_;

- (void)constructByModel: (id)model;


@end