/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "OpenHardwareIntelligentScale.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_intelligent_scale
 */
@interface OpenHardwareIntelligentScaleDBDAO : NSObject

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
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwareIntelligentScale: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale intoDb: (FMDatabase *)db;

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareIntelligentScaleByPk: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale fromDb: (FMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareIntelligentScale: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale fromDb: (FMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareIntelligentScale: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (FMDatabase *)db;

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
+ (NSMutableArray<OpenHardwareIntelligentScale *> *)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (FMDatabase *)db;

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
+ (NSMutableArray<OpenHardwareIntelligentScale *> *)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db;

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwareIntelligentScaleByPk: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale ofDb: (FMDatabase *)db;

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwareIntelligentScaleByPk: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale ofDb: (FMDatabase *)db;

/**
 *  获取所有数据
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectAllOpenHardwareIntelligentScaleFromDb: (FMDatabase *)db;

/**
 *  获取所有数据行数
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 行数
 */
+ (NSUInteger)countOpenHardwareIntelligentScaleFromDb: (FMDatabase *)db;

/**
 *  分页获取所有数据
 *
 *  @param page_no	页码
 *  @param page_size	页面大小
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScalePageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db;

/**
 *  根据deviceId获取数据
 *
 *  @param device_id	deviceId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db;

/**
 *  根据timeSec获取数据
 *
 *  @param time_sec	timeSec
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByTimeSec: (NSDate *)time_sec fromDb: (FMDatabase *)db;

/**
 *  根据weightG获取数据
 *
 *  @param weight_g	weightG
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByWeightG: (NSNumber *)weight_g fromDb: (FMDatabase *)db;

/**
 *  根据heightCm获取数据
 *
 *  @param height_cm	heightCm
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByHeightCm: (NSNumber *)height_cm fromDb: (FMDatabase *)db;

/**
 *  根据bodyFatPer获取数据
 *
 *  @param body_fat_per	bodyFatPer
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyFatPer: (NSNumber *)body_fat_per fromDb: (FMDatabase *)db;

/**
 *  根据bodyMusclePer获取数据
 *
 *  @param body_muscle_per	bodyMusclePer
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyMusclePer: (NSNumber *)body_muscle_per fromDb: (FMDatabase *)db;

/**
 *  根据bodyMassIndex获取数据
 *
 *  @param body_mass_index	bodyMassIndex
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyMassIndex: (NSNumber *)body_mass_index fromDb: (FMDatabase *)db;

/**
 *  根据basalMetabolismRate获取数据
 *
 *  @param basal_metabolism_rate	basalMetabolismRate
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBasalMetabolismRate: (NSNumber *)basal_metabolism_rate fromDb: (FMDatabase *)db;

/**
 *  根据bodyWaterPercentage获取数据
 *
 *  @param body_water_percentage	bodyWaterPercentage
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyWaterPercentage: (NSNumber *)body_water_percentage fromDb: (FMDatabase *)db;

/**
 *  根据userId获取数据
 *
 *  @param user_id	userId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db;

/**
 *  根据extra获取数据
 *
 *  @param extra_	extra
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db;

/**
 *  根据serverId获取数据
 *
 *  @param server_id	serverId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db;

/**
 *  根据status获取数据
 *
 *  @param status_	status
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db;


@end