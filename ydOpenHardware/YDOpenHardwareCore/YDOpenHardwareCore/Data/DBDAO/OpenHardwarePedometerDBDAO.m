/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "OpenHardwarePedometerDBDAO.h"
#import "MSDB.h"



static NSString *const MS_COL_OHP_ID = @"ohp_id"; //列名
static NSString *const MS_COL_DEVICE_ID = @"device_id"; //列名
static NSString *const MS_COL_NUMBER_OF_STEP = @"number_of_step"; //列名
static NSString *const MS_COL_DISTANCE = @"distance"; //列名
static NSString *const MS_COL_CALORIE = @"calorie"; //列名
static NSString *const MS_COL_START_TIME = @"start_time"; //列名
static NSString *const MS_COL_END_TIME = @"end_time"; //列名
static NSString *const MS_COL_USER_ID = @"user_id"; //列名
static NSString *const MS_COL_EXTRA = @"extra"; //列名
static NSString *const MS_COL_SERVER_ID = @"server_id"; //列名
static NSString *const MS_COL_STATUS = @"status"; //列名

static NSString *const MS_OPEN_HARDWARE_PEDOMETER_CREATE = @"CREATE TABLE IF NOT EXISTS open_hardware_pedometer (    ohp_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,    device_id text NOT NULL,    number_of_step integer DEFAULT(0),    distance integer DEFAULT(0),    calorie integer DEFAULT(0),    start_time real NOT NULL,    end_time real NOT NULL,    user_id integer NOT NULL,    extra text NOT NULL,    server_id integer DEFAULT(-1),    status integer DEFAULT(0)  )"; //创建语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_INSERT = @"insert into \"open_hardware_pedometer\"(device_id,number_of_step,distance,calorie,start_time,end_time,user_id,extra,server_id,status) values(?,?,?,?,?,?,?,?,?,?)"; //插入语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_PK = @"select * from \"open_hardware_pedometer\" where ohp_id = ?"; //根据主键查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_NEW = @"select * from \"open_hardware_pedometer\" order by ohp_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_NEW_BY_CONDITION = @"select * from \"open_hardware_pedometer\" where device_id = ? and user_id = ? order by ohp_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_CONDITION = @"select * from \"open_hardware_pedometer\" "; //根据条件获取数据
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_UPDATE_BY_PK = @"update \"open_hardware_pedometer\" set device_id = ?, number_of_step = ?, distance = ?, calorie = ?, start_time = ?, end_time = ?, user_id = ?, extra = ?, server_id = ?, status = ? where ohp_id = ?"; //根据主键更新语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_DELETE_BY_PK = @"delete from \"open_hardware_pedometer\" where ohp_id = ?"; //根据主键删除语句

static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_ALL = @"select * from \"open_hardware_pedometer\""; //查询所有语句

static NSString *const MS_OPEN_HARDWARE_PEDOMETER_COUNT = @"select count(*) from \"open_hardware_pedometer\""; //计数所有语句

static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_PAGE = @"select * from \"open_hardware_pedometer\" limit ?,?"; //查询所有分页语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_DEVICEID = @"select * from \"open_hardware_pedometer\" where device_id = ?"; //根据device_id查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_NUMBEROFSTEP = @"select * from \"open_hardware_pedometer\" where number_of_step = ?"; //根据number_of_step查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_DISTANCE = @"select * from \"open_hardware_pedometer\" where distance = ?"; //根据distance查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_CALORIE = @"select * from \"open_hardware_pedometer\" where calorie = ?"; //根据calorie查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_STARTTIME = @"select * from \"open_hardware_pedometer\" where start_time = ?"; //根据start_time查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_ENDTIME = @"select * from \"open_hardware_pedometer\" where end_time = ?"; //根据end_time查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_USERID = @"select * from \"open_hardware_pedometer\" where user_id = ?"; //根据user_id查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_EXTRA = @"select * from \"open_hardware_pedometer\" where extra = ?"; //根据extra查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_SERVERID = @"select * from \"open_hardware_pedometer\" where server_id = ?"; //根据server_id查询语句
static NSString *const MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_STATUS = @"select * from \"open_hardware_pedometer\" where status = ?"; //根据status查询语句

/**
 *  对应数据表：yd_open_hardware_db.open_hardware_pedometer
 */
@implementation OpenHardwarePedometerDBDAO

/**
 *  创建表格
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable: (FMDatabase *)db {
	if (db) {
		return [db executeUpdate: MS_OPEN_HARDWARE_PEDOMETER_CREATE];
	}
	return NO;
}

/**
 *  插入一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwarePedometer: (OpenHardwarePedometer *)open_hardware_pedometer intoDb: (FMDatabase *)db {
	if (open_hardware_pedometer && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_PEDOMETER_INSERT, open_hardware_pedometer.deviceId, open_hardware_pedometer.numberOfStep, open_hardware_pedometer.distance, open_hardware_pedometer.calorie, [MSDB dateToTimestamp: open_hardware_pedometer.startTime], [MSDB dateToTimestamp: open_hardware_pedometer.endTime], open_hardware_pedometer.userId, open_hardware_pedometer.extra, open_hardware_pedometer.serverId, open_hardware_pedometer.status];
		open_hardware_pedometer.ohpId = [NSNumber numberWithLongLong: db.lastInsertRowId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwarePedometerByPk: (OpenHardwarePedometer *)open_hardware_pedometer fromDb: (FMDatabase *)db {
	if (open_hardware_pedometer && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_PK, open_hardware_pedometer.ohpId];
		if ([rs next]) {
			open_hardware_pedometer.ohpId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHP_ID]];
			open_hardware_pedometer.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_pedometer.numberOfStep = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_NUMBER_OF_STEP]];
			open_hardware_pedometer.distance = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_DISTANCE]];
			open_hardware_pedometer.calorie = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_CALORIE]];
			open_hardware_pedometer.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			open_hardware_pedometer.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
			open_hardware_pedometer.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_pedometer.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_pedometer.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_pedometer.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwarePedometer: (OpenHardwarePedometer *)open_hardware_pedometer fromDb: (FMDatabase *)db {
	if (open_hardware_pedometer && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_NEW];
		if ([rs next]) {
			open_hardware_pedometer.ohpId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHP_ID]];
			open_hardware_pedometer.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_pedometer.numberOfStep = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_NUMBER_OF_STEP]];
			open_hardware_pedometer.distance = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_DISTANCE]];
			open_hardware_pedometer.calorie = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_CALORIE]];
			open_hardware_pedometer.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			open_hardware_pedometer.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
			open_hardware_pedometer.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_pedometer.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_pedometer.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_pedometer.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwarePedometer: (OpenHardwarePedometer *)open_hardware_pedometer byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
    if (open_hardware_pedometer && db) {
        FMResultSet *rs = nil;
        if (device_identity && user_id) {
            rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_NEW_BY_CONDITION, device_identity, user_id];
        } else {
            rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_NEW];
        }
        if ([rs next]) {
            open_hardware_pedometer.ohpId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHP_ID]];
            open_hardware_pedometer.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            open_hardware_pedometer.numberOfStep = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_NUMBER_OF_STEP]];
            open_hardware_pedometer.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
            open_hardware_pedometer.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
            open_hardware_pedometer.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
            open_hardware_pedometer.extra = [rs stringForColumn: MS_COL_EXTRA];
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
+ (NSMutableArray<OpenHardwarePedometer *> *)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (FMDatabase *)db {
    return [self selectPedometerByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: nil pageSize: nil fromDb: db];
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
+ (NSMutableArray<OpenHardwarePedometer *> *)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
    NSInteger count = 0;
    BOOL flag = NO;
    NSMutableString *sql = [NSMutableString stringWithString: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_CONDITION];
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
    if (page_no && page_size) {
        [sql appendString: @" limit ?,?"];
        [param addObject: [NSNumber numberWithInteger: (page_no.integerValue - 1) * page_size.integerValue]];
        [param addObject: page_size];
        count ++;
    }
    
    if (db) {
        FMResultSet *rs = [db executeQuery: sql withArgumentsInArray: param];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        while ([rs next]) {
            OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
            obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
            obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
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
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwarePedometerByPk: (OpenHardwarePedometer *)open_hardware_pedometer ofDb: (FMDatabase *)db {
	if (open_hardware_pedometer && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_PEDOMETER_UPDATE_BY_PK, open_hardware_pedometer.deviceId, open_hardware_pedometer.numberOfStep, open_hardware_pedometer.distance, open_hardware_pedometer.calorie, [MSDB dateToTimestamp: open_hardware_pedometer.startTime], [MSDB dateToTimestamp: open_hardware_pedometer.endTime], open_hardware_pedometer.userId, open_hardware_pedometer.extra, open_hardware_pedometer.serverId, open_hardware_pedometer.status, open_hardware_pedometer.ohpId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_pedometer	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwarePedometerByPk: (OpenHardwarePedometer *)open_hardware_pedometer ofDb: (FMDatabase *)db {
	if (open_hardware_pedometer && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_PEDOMETER_DELETE_BY_PK, open_hardware_pedometer.ohpId];
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
+ (NSMutableArray *)selectAllOpenHardwarePedometerFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_ALL];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSUInteger)countOpenHardwarePedometerFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_COUNT];
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
+ (NSMutableArray *)selectOpenHardwarePedometerPageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_PAGE, [NSNumber numberWithInteger: (page_no.integerValue - 1) * page_size.integerValue], page_size];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSMutableArray *)selectOpenHardwarePedometerByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_DEVICEID, device_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
 *  根据numberOfStep获取数据
 *
 *  @param number_of_step	numberOfStep
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByNumberOfStep: (NSNumber *)number_of_step fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_NUMBEROFSTEP, number_of_step];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
 *  根据distance获取数据
 *
 *  @param distance_	distance
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByDistance: (NSNumber *)distance_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_DISTANCE, distance_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
 *  根据calorie获取数据
 *
 *  @param calorie_	calorie
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwarePedometerByCalorie: (NSNumber *)calorie_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_CALORIE, calorie_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSMutableArray *)selectOpenHardwarePedometerByStartTime: (NSDate *)start_time fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_STARTTIME, [MSDB dateToTimestamp: start_time]];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSMutableArray *)selectOpenHardwarePedometerByEndTime: (NSDate *)end_time fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_ENDTIME, [MSDB dateToTimestamp: end_time]];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSMutableArray *)selectOpenHardwarePedometerByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_USERID, user_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSMutableArray *)selectOpenHardwarePedometerByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_EXTRA, extra_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSMutableArray *)selectOpenHardwarePedometerByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_SERVERID, server_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
+ (NSMutableArray *)selectOpenHardwarePedometerByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_PEDOMETER_SELECT_BY_STATUS, status_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwarePedometer *obj = [[OpenHardwarePedometer alloc] init];
			obj.ohpId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHP_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.numberOfStep = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_NUMBER_OF_STEP]];
			obj.distance = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_DISTANCE]];
			obj.calorie = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_CALORIE]];
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
