/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "OpenHardwareHeartRateDBDAO.h"
#import "MSDB.h"



static NSString *const MS_COL_OHH_ID = @"ohh_id"; //列名
static NSString *const MS_COL_DEVICE_ID = @"device_id"; //列名
static NSString *const MS_COL_HEART_RATE = @"heart_rate"; //列名
static NSString *const MS_COL_START_TIME = @"start_time"; //列名
static NSString *const MS_COL_END_TIME = @"end_time"; //列名
static NSString *const MS_COL_USER_ID = @"user_id"; //列名
static NSString *const MS_COL_EXTRA = @"extra"; //列名
static NSString *const MS_COL_SERVER_ID = @"server_id"; //列名
static NSString *const MS_COL_STATUS = @"status"; //列名

static NSString *const MS_OPEN_HARDWARE_HEART_RATE_CREATE = @"CREATE TABLE IF NOT EXISTS open_hardware_heart_rate (    ohh_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,    device_id text NOT NULL,    heart_rate real DEFAULT(0),    start_time real NOT NULL,    end_time real NOT NULL,    user_id integer NOT NULL,    extra text NOT NULL,    server_id integer DEFAULT(-1),    status integer DEFAULT(0)  )"; //创建语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_INSERT = @"insert into \"open_hardware_heart_rate\"(device_id,heart_rate,start_time,end_time,user_id,extra,server_id,status) values(?,?,?,?,?,?,?,?)"; //插入语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_PK = @"select * from \"open_hardware_heart_rate\" where ohh_id = ?"; //根据主键查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_NEW = @"select * from \"open_hardware_heart_rate\" order by ohh_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_NEW_BY_CONDITION = @"select * from \"open_hardware_heart_rate\" where device_id = ? and user_id = ? order by ohh_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_CONDITION = @"select * from \"open_hardware_heart_rate\" "; //根据条件获取数据
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_UPDATE_BY_PK = @"update \"open_hardware_heart_rate\" set device_id = ?, heart_rate = ?, start_time = ?, end_time = ?, user_id = ?, extra = ?, server_id = ?, status = ? where ohh_id = ?"; //根据主键更新语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_DELETE_BY_PK = @"delete from \"open_hardware_heart_rate\" where ohh_id = ?"; //根据主键删除语句

static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_ALL = @"select * from \"open_hardware_heart_rate\""; //查询所有语句

static NSString *const MS_OPEN_HARDWARE_HEART_RATE_COUNT = @"select count(*) from \"open_hardware_heart_rate\""; //计数所有语句

static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_PAGE = @"select * from \"open_hardware_heart_rate\" limit ?,?"; //查询所有分页语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_DEVICEID = @"select * from \"open_hardware_heart_rate\" where device_id = ?"; //根据device_id查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_HEARTRATE = @"select * from \"open_hardware_heart_rate\" where heart_rate = ?"; //根据heart_rate查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_STARTTIME = @"select * from \"open_hardware_heart_rate\" where start_time = ?"; //根据start_time查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_ENDTIME = @"select * from \"open_hardware_heart_rate\" where end_time = ?"; //根据end_time查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_USERID = @"select * from \"open_hardware_heart_rate\" where user_id = ?"; //根据user_id查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_EXTRA = @"select * from \"open_hardware_heart_rate\" where extra = ?"; //根据extra查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_SERVERID = @"select * from \"open_hardware_heart_rate\" where server_id = ?"; //根据server_id查询语句
static NSString *const MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_STATUS = @"select * from \"open_hardware_heart_rate\" where status = ?"; //根据status查询语句

/**
 *  对应数据表：yd_open_hardware_db.open_hardware_heart_rate
 */
@implementation OpenHardwareHeartRateDBDAO

/**
 *  创建表格
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable: (FMDatabase *)db {
	if (db) {
		return [db executeUpdate: MS_OPEN_HARDWARE_HEART_RATE_CREATE];
	}
	return NO;
}

/**
 *  插入一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwareHeartRate: (OpenHardwareHeartRate *)open_hardware_heart_rate intoDb: (FMDatabase *)db {
	if (open_hardware_heart_rate && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_HEART_RATE_INSERT, open_hardware_heart_rate.deviceId, open_hardware_heart_rate.heartRate, [MSDB dateToTimestamp: open_hardware_heart_rate.startTime], [MSDB dateToTimestamp: open_hardware_heart_rate.endTime], open_hardware_heart_rate.userId, open_hardware_heart_rate.extra, open_hardware_heart_rate.serverId, open_hardware_heart_rate.status];
		open_hardware_heart_rate.ohhId = [NSNumber numberWithLongLong: db.lastInsertRowId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareHeartRateByPk: (OpenHardwareHeartRate *)open_hardware_heart_rate fromDb: (FMDatabase *)db {
	if (open_hardware_heart_rate && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_PK, open_hardware_heart_rate.ohhId];
		if ([rs next]) {
			open_hardware_heart_rate.ohhId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHH_ID]];
			open_hardware_heart_rate.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_heart_rate.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			open_hardware_heart_rate.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			open_hardware_heart_rate.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
			open_hardware_heart_rate.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_heart_rate.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_heart_rate.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_heart_rate.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareHeartRate: (OpenHardwareHeartRate *)open_hardware_heart_rate fromDb: (FMDatabase *)db {
	if (open_hardware_heart_rate && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_NEW];
		if ([rs next]) {
			open_hardware_heart_rate.ohhId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHH_ID]];
			open_hardware_heart_rate.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_heart_rate.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			open_hardware_heart_rate.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			open_hardware_heart_rate.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
			open_hardware_heart_rate.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_heart_rate.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_heart_rate.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_heart_rate.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareHeartRate: (OpenHardwareHeartRate *)open_hardware_heart_rate byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
    if (open_hardware_heart_rate && db) {
        FMResultSet *rs = nil;
        if (device_identity && user_id) {
            rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_NEW_BY_CONDITION, device_identity, user_id];
        } else {
            rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_NEW];
        }
        if ([rs next]) {
            open_hardware_heart_rate.ohhId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHH_ID]];
            open_hardware_heart_rate.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            open_hardware_heart_rate.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
            open_hardware_heart_rate.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
            open_hardware_heart_rate.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
            open_hardware_heart_rate.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
            open_hardware_heart_rate.extra = [rs stringForColumn: MS_COL_EXTRA];
            open_hardware_heart_rate.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
            open_hardware_heart_rate.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
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
+ (NSMutableArray<OpenHardwareHeartRate *> *)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (FMDatabase *)db {
    return [self selectHeartRateByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: nil pageSize: nil fromDb: db];
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
+ (NSMutableArray<OpenHardwareHeartRate *> *)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
    NSInteger count = 0;
    BOOL flag = NO;
    NSMutableString *sql = [NSMutableString stringWithString: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_CONDITION];
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
            [sql appendFormat: @" where %@ = ?", MS_COL_START_TIME];
        } else {
            [sql appendFormat: @" and %@ = ?", MS_COL_START_TIME];
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
            [sql appendFormat: @" where %@ >= ? and %@ < ?", MS_COL_START_TIME, MS_COL_START_TIME];
        } else {
            [sql appendFormat: @" and %@ >= ? and %@ < ?", MS_COL_START_TIME, MS_COL_START_TIME];
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
            OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
            obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
            obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
            obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
            obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwareHeartRateByPk: (OpenHardwareHeartRate *)open_hardware_heart_rate ofDb: (FMDatabase *)db {
	if (open_hardware_heart_rate && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_HEART_RATE_UPDATE_BY_PK, open_hardware_heart_rate.deviceId, open_hardware_heart_rate.heartRate, [MSDB dateToTimestamp: open_hardware_heart_rate.startTime], [MSDB dateToTimestamp: open_hardware_heart_rate.endTime], open_hardware_heart_rate.userId, open_hardware_heart_rate.extra, open_hardware_heart_rate.serverId, open_hardware_heart_rate.status, open_hardware_heart_rate.ohhId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwareHeartRateByPk: (OpenHardwareHeartRate *)open_hardware_heart_rate ofDb: (FMDatabase *)db {
	if (open_hardware_heart_rate && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_HEART_RATE_DELETE_BY_PK, open_hardware_heart_rate.ohhId];
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
+ (NSMutableArray *)selectAllOpenHardwareHeartRateFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_ALL];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
+ (NSUInteger)countOpenHardwareHeartRateFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_COUNT];
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
+ (NSMutableArray *)selectOpenHardwareHeartRatePageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_PAGE, [NSNumber numberWithInteger: (page_no.integerValue - 1) * page_size.integerValue], page_size];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
+ (NSMutableArray *)selectOpenHardwareHeartRateByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_DEVICEID, device_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
 *  根据heartRate获取数据
 *
 *  @param heart_rate	heartRate
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareHeartRateByHeartRate: (NSNumber *)heart_rate fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_HEARTRATE, heart_rate];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
 *  根据startTime获取数据
 *
 *  @param start_time	startTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareHeartRateByStartTime: (NSDate *)start_time fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_STARTTIME, [MSDB dateToTimestamp: start_time]];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
 *  根据endTime获取数据
 *
 *  @param end_time	endTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareHeartRateByEndTime: (NSDate *)end_time fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_ENDTIME, [MSDB dateToTimestamp: end_time]];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
+ (NSMutableArray *)selectOpenHardwareHeartRateByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_USERID, user_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
+ (NSMutableArray *)selectOpenHardwareHeartRateByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_EXTRA, extra_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
+ (NSMutableArray *)selectOpenHardwareHeartRateByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_SERVERID, server_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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
+ (NSMutableArray *)selectOpenHardwareHeartRateByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_HEART_RATE_SELECT_BY_STATUS, status_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareHeartRate *obj = [[OpenHardwareHeartRate alloc] init];
			obj.ohhId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHH_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.heartRate = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_HEART_RATE]];
			obj.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			obj.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
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