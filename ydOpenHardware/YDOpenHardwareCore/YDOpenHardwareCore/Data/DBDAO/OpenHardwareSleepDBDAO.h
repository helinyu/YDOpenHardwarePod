/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "OpenHardwareSleep.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_sleep
 */
@interface OpenHardwareSleepDBDAO : NSObject

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
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwareSleep: (OpenHardwareSleep *)open_hardware_sleep intoDb: (FMDatabase *)db;

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareSleepByPk: (OpenHardwareSleep *)open_hardware_sleep fromDb: (FMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareSleep: (OpenHardwareSleep *)open_hardware_sleep fromDb: (FMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareSleep: (OpenHardwareSleep *)open_hardware_sleep byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (FMDatabase *)db;

/**
 *  根据条件获取数据
 *
 *  @param device_identity
 *  @param time_sec
 *  @param user_id
 *  @param start
 *  @param end
 *  @param db
 *
 *  @return 数据
 */
+ (NSMutableArray<OpenHardwareSleep *> *)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (FMDatabase *)db;

/**
 *  根据条件获取数据
 *
 *  @param device_identity
 *  @param time_sec
 *  @param user_id
 *  @param start
 *  @param end
 *  @param db
 *  @param page_no
 *  @param page_size
 *
 *  @return 数据
 */
+ (NSMutableArray<OpenHardwareSleep *> *)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db;

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwareSleepByPk: (OpenHardwareSleep *)open_hardware_sleep ofDb: (FMDatabase *)db;

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwareSleepByPk: (OpenHardwareSleep *)open_hardware_sleep ofDb: (FMDatabase *)db;

/**
 *  获取所有数据
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectAllOpenHardwareSleepFromDb: (FMDatabase *)db;

/**
 *  获取所有数据行数
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 行数
 */
+ (NSUInteger)countOpenHardwareSleepFromDb: (FMDatabase *)db;

/**
 *  分页获取所有数据
 *
 *  @param page_no	页码
 *  @param page_size	页面大小
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepPageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db;

/**
 *  根据deviceId获取数据
 *
 *  @param device_id	deviceId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db;

/**
 *  根据sleepSec获取数据
 *
 *  @param sleep_sec	sleepSec
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepBySleepSec: (NSNumber *)sleep_sec fromDb: (FMDatabase *)db;

/**
 *  根据sleepSection获取数据
 *
 *  @param sleep_section	sleepSection
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepBySleepSection: (NSNumber *)sleep_section fromDb: (FMDatabase *)db;

/**
 *  根据startTime获取数据
 *
 *  @param start_time	startTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepByStartTime: (NSDate *)start_time fromDb: (FMDatabase *)db;

/**
 *  根据endTime获取数据
 *
 *  @param end_time	endTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepByEndTime: (NSDate *)end_time fromDb: (FMDatabase *)db;

/**
 *  根据userId获取数据
 *
 *  @param user_id	userId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db;

/**
 *  根据extra获取数据
 *
 *  @param extra_	extra
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db;

/**
 *  根据serverId获取数据
 *
 *  @param server_id	serverId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db;

/**
 *  根据status获取数据
 *
 *  @param status_	status
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db;


@end