/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "OpenHardwareIntelligentScaleDBDAO.h"
#import "MSDB.h"



static NSString *const MS_COL_OHI_ID = @"ohi_id"; //列名
static NSString *const MS_COL_DEVICE_ID = @"device_id"; //列名
static NSString *const MS_COL_TIME_SEC = @"time_sec"; //列名
static NSString *const MS_COL_WEIGHT_G = @"weight_g"; //列名
static NSString *const MS_COL_HEIGHT_CM = @"height_cm"; //列名
static NSString *const MS_COL_BODY_FAT_PER = @"body_fat_per"; //列名
static NSString *const MS_COL_BODY_MUSCLE_PER = @"body_muscle_per"; //列名
static NSString *const MS_COL_BODY_MASS_INDEX = @"body_mass_index"; //列名
static NSString *const MS_COL_BASAL_METABOLISM_RATE = @"basal_metabolism_rate"; //列名
static NSString *const MS_COL_BODY_WATER_PERCENTAGE = @"body_water_percentage"; //列名
static NSString *const MS_COL_USER_ID = @"user_id"; //列名
static NSString *const MS_COL_EXTRA = @"extra"; //列名
static NSString *const MS_COL_SERVER_ID = @"server_id"; //列名
static NSString *const MS_COL_STATUS = @"status"; //列名

static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_CREATE = @"CREATE TABLE IF NOT EXISTS open_hardware_intelligent_scale (    ohi_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,    device_id text NOT NULL,    time_sec real NOT NULL,    weight_g real DEFAULT(60000),    height_cm real DEFAULT(170),    body_fat_per float DEFAULT(0),    body_muscle_per float DEFAULT(0),    body_mass_index float DEFAULT(0),    basal_metabolism_rate float DEFAULT(0),    body_water_percentage float DEFAULT(0),    user_id integer NOT NULL,    extra text NOT NULL,    server_id integer DEFAULT(-1),    status integer DEFAULT(0)  )"; //创建语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_INSERT = @"insert into \"open_hardware_intelligent_scale\"(device_id,time_sec,weight_g,height_cm,body_fat_per,body_muscle_per,body_mass_index,basal_metabolism_rate,body_water_percentage,user_id,extra,server_id,status) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"; //插入语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_PK = @"select * from \"open_hardware_intelligent_scale\" where ohi_id = ?"; //根据主键查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_NEW = @"select * from \"open_hardware_intelligent_scale\" order by ohi_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_NEW_BY_CONDITION = @"select * from \"open_hardware_intelligent_scale\" where device_id = ? and user_id = ? order by ohi_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_CONDITION = @"select * from \"open_hardware_intelligent_scale\" "; //根据条件获取数据语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_UPDATE_BY_PK = @"update \"open_hardware_intelligent_scale\" set device_id = ?, time_sec = ?, weight_g = ?, height_cm = ?, body_fat_per = ?, body_muscle_per = ?, body_mass_index = ?, basal_metabolism_rate = ?, body_water_percentage = ?, user_id = ?, extra = ?, server_id = ?, status = ? where ohi_id = ?"; //根据主键更新语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_DELETE_BY_PK = @"delete from \"open_hardware_intelligent_scale\" where ohi_id = ?"; //根据主键删除语句

static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_ALL = @"select * from \"open_hardware_intelligent_scale\""; //查询所有语句

static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_COUNT = @"select count(*) from \"open_hardware_intelligent_scale\""; //计数所有语句

static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_PAGE = @"select * from \"open_hardware_intelligent_scale\" limit ?,?"; //查询所有分页语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_DEVICEID = @"select * from \"open_hardware_intelligent_scale\" where device_id = ?"; //根据device_id查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_TIMESEC = @"select * from \"open_hardware_intelligent_scale\" where time_sec = ?"; //根据time_sec查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_WEIGHTG = @"select * from \"open_hardware_intelligent_scale\" where weight_g = ?"; //根据weight_g查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_HEIGHTCM = @"select * from \"open_hardware_intelligent_scale\" where height_cm = ?"; //根据height_cm查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYFATPER = @"select * from \"open_hardware_intelligent_scale\" where body_fat_per = ?"; //根据body_fat_per查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYMUSCLEPER = @"select * from \"open_hardware_intelligent_scale\" where body_muscle_per = ?"; //根据body_muscle_per查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYMASSINDEX = @"select * from \"open_hardware_intelligent_scale\" where body_mass_index = ?"; //根据body_mass_index查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BASALMETABOLISMRATE = @"select * from \"open_hardware_intelligent_scale\" where basal_metabolism_rate = ?"; //根据basal_metabolism_rate查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYWATERPERCENTAGE = @"select * from \"open_hardware_intelligent_scale\" where body_water_percentage = ?"; //根据body_water_percentage查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_USERID = @"select * from \"open_hardware_intelligent_scale\" where user_id = ?"; //根据user_id查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_EXTRA = @"select * from \"open_hardware_intelligent_scale\" where extra = ?"; //根据extra查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_SERVERID = @"select * from \"open_hardware_intelligent_scale\" where server_id = ?"; //根据server_id查询语句
static NSString *const MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_STATUS = @"select * from \"open_hardware_intelligent_scale\" where status = ?"; //根据status查询语句

/**
 *  对应数据表：yd_open_hardware_db.open_hardware_intelligent_scale
 */
@implementation OpenHardwareIntelligentScaleDBDAO

/**
 *  创建表格
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable: (FMDatabase *)db {
	if (db) {
		return [db executeUpdate: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_CREATE];
	}
	return NO;
}

/**
 *  插入一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwareIntelligentScale: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale intoDb: (FMDatabase *)db {
	if (open_hardware_intelligent_scale && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_INSERT, open_hardware_intelligent_scale.deviceId, [MSDB dateToTimestamp: open_hardware_intelligent_scale.timeSec], open_hardware_intelligent_scale.weightG, open_hardware_intelligent_scale.heightCm, open_hardware_intelligent_scale.bodyFatPer, open_hardware_intelligent_scale.bodyMusclePer, open_hardware_intelligent_scale.bodyMassIndex, open_hardware_intelligent_scale.basalMetabolismRate, open_hardware_intelligent_scale.bodyWaterPercentage, open_hardware_intelligent_scale.userId, open_hardware_intelligent_scale.extra, open_hardware_intelligent_scale.serverId, open_hardware_intelligent_scale.status];
		open_hardware_intelligent_scale.ohiId = [NSNumber numberWithLongLong: db.lastInsertRowId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareIntelligentScaleByPk: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale fromDb: (FMDatabase *)db {
	if (open_hardware_intelligent_scale && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_PK, open_hardware_intelligent_scale.ohiId];
		if ([rs next]) {
			open_hardware_intelligent_scale.ohiId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHI_ID]];
			open_hardware_intelligent_scale.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_intelligent_scale.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			open_hardware_intelligent_scale.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			open_hardware_intelligent_scale.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			open_hardware_intelligent_scale.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			open_hardware_intelligent_scale.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			open_hardware_intelligent_scale.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			open_hardware_intelligent_scale.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			open_hardware_intelligent_scale.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			open_hardware_intelligent_scale.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_intelligent_scale.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_intelligent_scale.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_intelligent_scale.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareIntelligentScale: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale fromDb: (FMDatabase *)db {
	if (open_hardware_intelligent_scale && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_NEW];
		if ([rs next]) {
			open_hardware_intelligent_scale.ohiId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHI_ID]];
			open_hardware_intelligent_scale.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_intelligent_scale.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			open_hardware_intelligent_scale.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			open_hardware_intelligent_scale.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			open_hardware_intelligent_scale.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			open_hardware_intelligent_scale.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			open_hardware_intelligent_scale.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			open_hardware_intelligent_scale.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			open_hardware_intelligent_scale.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			open_hardware_intelligent_scale.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_intelligent_scale.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_intelligent_scale.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_intelligent_scale.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareIntelligentScale: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
    if (open_hardware_intelligent_scale && db) {
        FMResultSet *rs = nil;
        if (device_identity && user_id) {
            rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_NEW_BY_CONDITION, device_identity, user_id];
        } else {
            rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_NEW];
        }
        if ([rs next]) {
            open_hardware_intelligent_scale.ohiId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHI_ID]];
            open_hardware_intelligent_scale.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            open_hardware_intelligent_scale.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
            open_hardware_intelligent_scale.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
            open_hardware_intelligent_scale.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
            open_hardware_intelligent_scale.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
            open_hardware_intelligent_scale.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
            open_hardware_intelligent_scale.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
            open_hardware_intelligent_scale.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
            open_hardware_intelligent_scale.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
            open_hardware_intelligent_scale.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
            open_hardware_intelligent_scale.extra = [rs stringForColumn: MS_COL_EXTRA];
            open_hardware_intelligent_scale.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
            open_hardware_intelligent_scale.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
            [rs close];
            return YES;
        }
    }
    return NO;
}

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
+ (NSMutableArray<OpenHardwareIntelligentScale *> *)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (FMDatabase *)db {
    return [self selectIntelligentScaleByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: nil pageSize: nil fromDb: db];
}

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
+ (NSMutableArray<OpenHardwareIntelligentScale *> *)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
    
    NSInteger count = 0;
    BOOL flag = NO;
    
    NSMutableString *sql = [NSMutableString stringWithString: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_CONDITION];
    NSMutableArray *param = [NSMutableArray array];
    if (device_identity) {
        if (count == 0) {
            [sql appendFormat: @" where %@ = ?", MS_COL_DEVICE_ID];
        } else {
            [sql appendFormat: @" and %@ = ?", MS_COL_DEVICE_ID];
        }
        [param addObject: device_identity];
        count ++;
    }
    if (time_sec) {
        if (count == 0) {
            [sql appendFormat: @" where %@ = ?", MS_COL_TIME_SEC];
        } else {
            [sql appendFormat: @" and %@ = ?", MS_COL_TIME_SEC];
        }
        [param addObject: [MSDB dateToTimestamp: time_sec]];
        count ++;
        flag = YES;
    }
    if (user_id) {
        if (count == 0) {
            [sql appendFormat: @" where %@ = ?", MS_COL_USER_ID];
        } else {
            [sql appendFormat: @" and %@ = ?", MS_COL_USER_ID];
        }
        [param addObject: user_id];
        count ++;
    }
    if (!flag && start && end) {
        if (count == 0) {
            [sql appendFormat: @" where %@ >= ? and %@ < ?", MS_COL_TIME_SEC, MS_COL_TIME_SEC];
        } else {
            [sql appendFormat: @" and %@ >= ? and %@ < ?", MS_COL_TIME_SEC, MS_COL_TIME_SEC];
        }
        [param addObject: [MSDB dateToTimestamp: start]];
        [param addObject: [MSDB dateToTimestamp: end]];
        count ++;
    }
    if (page_no != nil && page_size != nil) {
        [sql appendString: @" limit ?,?"];
        [param addObject: [NSNumber numberWithInteger: (page_no.integerValue - 1) * page_size.integerValue]];
        [param addObject: page_size];
        count ++;
    }
    
    if (db) {
        FMResultSet *rs = [db executeQuery: sql withArgumentsInArray: param];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        while ([rs next]) {
            OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
            obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
            obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
            obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
            obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
            obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
            obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
            obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
            obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
            obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
            obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
            obj.extra = [rs stringForColumn: MS_COL_EXTRA];
            obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
            obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
            
            [arr addObject: obj];
        }
        return arr;
    }
    return nil;
}

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwareIntelligentScaleByPk: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale ofDb: (FMDatabase *)db {
	if (open_hardware_intelligent_scale && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_UPDATE_BY_PK, open_hardware_intelligent_scale.deviceId, [MSDB dateToTimestamp: open_hardware_intelligent_scale.timeSec], open_hardware_intelligent_scale.weightG, open_hardware_intelligent_scale.heightCm, open_hardware_intelligent_scale.bodyFatPer, open_hardware_intelligent_scale.bodyMusclePer, open_hardware_intelligent_scale.bodyMassIndex, open_hardware_intelligent_scale.basalMetabolismRate, open_hardware_intelligent_scale.bodyWaterPercentage, open_hardware_intelligent_scale.userId, open_hardware_intelligent_scale.extra, open_hardware_intelligent_scale.serverId, open_hardware_intelligent_scale.status, open_hardware_intelligent_scale.ohiId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwareIntelligentScaleByPk: (OpenHardwareIntelligentScale *)open_hardware_intelligent_scale ofDb: (FMDatabase *)db {
	if (open_hardware_intelligent_scale && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_DELETE_BY_PK, open_hardware_intelligent_scale.ohiId];
		return flag;
	}
	return NO;
}

/**
 *  获取所有数据
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectAllOpenHardwareIntelligentScaleFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_ALL];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  获取所有数据行数
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 行数
 */
+ (NSUInteger)countOpenHardwareIntelligentScaleFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_COUNT];
		if ([rs next]) {
			NSUInteger count = (NSUInteger)[rs longLongIntForColumnIndex: 0];
			[rs close];
			return count;
		}
	}
	return 0;
}

/**
 *  分页获取所有数据
 *
 *  @param page_no	页码
 *  @param page_size	页面大小
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScalePageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_PAGE, [NSNumber numberWithInteger: (page_no.integerValue - 1) * page_size.integerValue], page_size];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据deviceId获取数据
 *
 *  @param device_id	deviceId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_DEVICEID, device_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据timeSec获取数据
 *
 *  @param time_sec	timeSec
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByTimeSec: (NSDate *)time_sec fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_TIMESEC, [MSDB dateToTimestamp: time_sec]];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据weightG获取数据
 *
 *  @param weight_g	weightG
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByWeightG: (NSNumber *)weight_g fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_WEIGHTG, weight_g];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据heightCm获取数据
 *
 *  @param height_cm	heightCm
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByHeightCm: (NSNumber *)height_cm fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_HEIGHTCM, height_cm];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据bodyFatPer获取数据
 *
 *  @param body_fat_per	bodyFatPer
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyFatPer: (NSNumber *)body_fat_per fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYFATPER, body_fat_per];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据bodyMusclePer获取数据
 *
 *  @param body_muscle_per	bodyMusclePer
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyMusclePer: (NSNumber *)body_muscle_per fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYMUSCLEPER, body_muscle_per];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据bodyMassIndex获取数据
 *
 *  @param body_mass_index	bodyMassIndex
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyMassIndex: (NSNumber *)body_mass_index fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYMASSINDEX, body_mass_index];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据basalMetabolismRate获取数据
 *
 *  @param basal_metabolism_rate	basalMetabolismRate
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBasalMetabolismRate: (NSNumber *)basal_metabolism_rate fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BASALMETABOLISMRATE, basal_metabolism_rate];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据bodyWaterPercentage获取数据
 *
 *  @param body_water_percentage	bodyWaterPercentage
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByBodyWaterPercentage: (NSNumber *)body_water_percentage fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_BODYWATERPERCENTAGE, body_water_percentage];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据userId获取数据
 *
 *  @param user_id	userId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_USERID, user_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据extra获取数据
 *
 *  @param extra_	extra
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_EXTRA, extra_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据serverId获取数据
 *
 *  @param server_id	serverId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_SERVERID, server_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}

/**
 *  根据status获取数据
 *
 *  @param status_	status
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareIntelligentScaleByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_INTELLIGENT_SCALE_SELECT_BY_STATUS, status_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareIntelligentScale *obj = [[OpenHardwareIntelligentScale alloc] init];
			obj.ohiId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHI_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.timeSec = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_TIME_SEC]]];
			obj.weightG = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_WEIGHT_G]];
			obj.heightCm = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEIGHT_CM]];
			obj.bodyFatPer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_FAT_PER]];
			obj.bodyMusclePer = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MUSCLE_PER]];
			obj.bodyMassIndex = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_MASS_INDEX]];
			obj.basalMetabolismRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BASAL_METABOLISM_RATE]];
			obj.bodyWaterPercentage = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_BODY_WATER_PERCENTAGE]];
			obj.userId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_USER_ID]];
			obj.extra = [rs stringForColumn: MS_COL_EXTRA];
			obj.serverId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SERVER_ID]];
			obj.status = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_STATUS]];
			[arr addObject: obj];
		}
		return arr;
	}
	return nil;
}


@end