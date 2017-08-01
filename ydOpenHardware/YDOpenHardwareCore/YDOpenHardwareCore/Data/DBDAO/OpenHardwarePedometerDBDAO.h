/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "OpenHardwarePedometer.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_pedometer
 */
@interface OpenHardwarePedometerDBDAO : NSObject

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
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwarePedometer: (OpenHardwarePedometer *)open_hardware_pedometer intoDb: (FMDatabase *)db;

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwarePedometerByPk: (OpenHardwarePedometer *)open_hardware_pedometer fromDb: (FMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwarePedometer: (OpenHardwarePedometer *)open_hardware_pedometer fromDb: (FMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwarePedometer: (OpenHardwarePedometer *)open_hardware_pedometer byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (FMDatabase *)db;

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
+ (NSMutableArray<OpenHardwarePedometer *> *)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (FMDatabase *)db;

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
+ (NSMutableArray<OpenHardwarePedometer *> *)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db;

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwarePedometerByPk: (OpenHardwarePedometer *)open_hardware_pedometer ofDb: (FMDatabase *)db;

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwarePedometerByPk: (OpenHardwarePedometer *)open_hardware_pedometer ofDb: (FMDatabase *)db;

/**
 *  获取所有数据
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectAllOpenHardwarePedometerFromDb: (FMDatabase *)db;

/**
 *  获取所有数据行数
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 行数
 */
+ (NSUInteger)countOpenHardwarePedometerFromDb: (FMDatabase *)db;

/**
 *  分页获取所有数据
 *
 *  @param page_no	页码
 *  @param page_size	页面大小
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerPageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db;

/**
 *  根据deviceId获取数据
 *
 *  @param device_id	deviceId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db;

/**
 *  根据numberOfStep获取数据
 *
 *  @param number_of_step	numberOfStep
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByNumberOfStep: (NSNumber *)number_of_step fromDb: (FMDatabase *)db;

/**
 *  根据distance获取数据
 *
 *  @param distance_	distance
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByDistance: (NSNumber *)distance_ fromDb: (FMDatabase *)db;

/**
 *  根据calorie获取数据
 *
 *  @param calorie_	calorie
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByCalorie: (NSNumber *)calorie_ fromDb: (FMDatabase *)db;

/**
 *  根据startTime获取数据
 *
 *  @param start_time	startTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByStartTime: (NSDate *)start_time fromDb: (FMDatabase *)db;

/**
 *  根据endTime获取数据
 *
 *  @param end_time	endTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByEndTime: (NSDate *)end_time fromDb: (FMDatabase *)db;

/**
 *  根据userId获取数据
 *
 *  @param user_id	userId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db;

/**
 *  根据extra获取数据
 *
 *  @param extra_	extra
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db;

/**
 *  根据serverId获取数据
 *
 *  @param server_id	serverId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db;

/**
 *  根据status获取数据
 *
 *  @param status_	status
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db;


@end