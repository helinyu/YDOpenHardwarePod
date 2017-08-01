/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "OpenHardwareDevice.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_device
 */
@interface OpenHardwareDeviceDBDAO : NSObject

/**
 *  创建表格
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable: (FMDatabase *)db;

/**
 *  插入一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwareDevice: (OpenHardwareDevice *)open_hardware_device intoDb: (FMDatabase *)db;

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareDeviceByPk: (OpenHardwareDevice *)open_hardware_device fromDb: (FMDatabase *)db;

/**
 *  根据数据获取一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareDeviceByDevice: (OpenHardwareDevice *)open_hardware_device fromDb: (FMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareDevice: (OpenHardwareDevice *)open_hardware_device fromDb: (FMDatabase *)db;

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwareDeviceByPk: (OpenHardwareDevice *)open_hardware_device ofDb: (FMDatabase *)db;

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwareDeviceByPk: (OpenHardwareDevice *)open_hardware_device ofDb: (FMDatabase *)db;

/**
 *  获取所有数据
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectAllOpenHardwareDeviceFromDb: (FMDatabase *)db;

/**
 *  获取所有数据行数
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 行数
 */
+ (NSUInteger)countOpenHardwareDeviceFromDb: (FMDatabase *)db;

/**
 *  分页获取所有数据
 *
 *  @param page_no	页码
 *  @param page_size	页面大小
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectOpenHardwareDevicePageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db;

/**
 *  根据deviceId获取数据
 *
 *  @param device_id	deviceId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareDeviceByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db;

/**
 *  根据plugName获取数据
 *
 *  @param plug_name	plugName
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareDeviceByPlugName: (NSString *)plug_name fromDb: (FMDatabase *)db;

/**
 *  根据userId获取数据
 *
 *  @param user_id	userId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareDeviceByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db;

/**
 *  根据extra获取数据
 *
 *  @param extra_	extra
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareDeviceByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db;

/**
 *  根据serverId获取数据
 *
 *  @param server_id	serverId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareDeviceByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db;

/**
 *  根据status获取数据
 *
 *  @param status_	status
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareDeviceByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db;


@end