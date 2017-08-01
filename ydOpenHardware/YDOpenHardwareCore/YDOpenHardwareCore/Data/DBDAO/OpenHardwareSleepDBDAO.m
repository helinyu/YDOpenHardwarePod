/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "OpenHardwareSleepDBDAO.h"
#import "MSDB.h"



static NSString *const MS_COL_OHS_ID = @"ohs_id"; //列名
static NSString *const MS_COL_DEVICE_ID = @"device_id"; //列名
static NSString *const MS_COL_SLEEP_SEC = @"sleep_sec"; //列名
static NSString *const MS_COL_SLEEP_SECTION = @"sleep_section"; //列名
static NSString *const MS_COL_START_TIME = @"start_time"; //列名
static NSString *const MS_COL_END_TIME = @"end_time"; //列名
static NSString *const MS_COL_USER_ID = @"user_id"; //列名
static NSString *const MS_COL_EXTRA = @"extra"; //列名
static NSString *const MS_COL_SERVER_ID = @"server_id"; //列名
static NSString *const MS_COL_STATUS = @"status"; //列名

static NSString *const MS_OPEN_HARDWARE_SLEEP_CREATE = @"CREATE TABLE IF NOT EXISTS open_hardware_sleep (    ohs_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,    device_id text NOT NULL,    sleep_sec real DEFAULT(0),    sleep_section integer DEFAULT(0),    start_time real NOT NULL,    end_time real NOT NULL,    user_id integer NOT NULL,    extra text NOT NULL,    server_id integer DEFAULT(-1),    status integer DEFAULT(0)  )"; //创建语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_INSERT = @"insert into \"open_hardware_sleep\"(device_id,sleep_sec,sleep_section,start_time,end_time,user_id,extra,server_id,status) values(?,?,?,?,?,?,?,?,?)"; //插入语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_PK = @"select * from \"open_hardware_sleep\" where ohs_id = ?"; //根据主键查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_NEW = @"select * from \"open_hardware_sleep\" order by ohs_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_NEW_BY_CONDITION = @"select * from \"open_hardware_sleep\" where device_id = ? and user_id = ? order by ohs_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_CONDITION = @"select * from \"open_hardware_sleep\" "; //根据条件获取数据
static NSString *const MS_OPEN_HARDWARE_SLEEP_UPDATE_BY_PK = @"update \"open_hardware_sleep\" set device_id = ?, sleep_sec = ?, sleep_section = ?, start_time = ?, end_time = ?, user_id = ?, extra = ?, server_id = ?, status = ? where ohs_id = ?"; //根据主键更新语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_DELETE_BY_PK = @"delete from \"open_hardware_sleep\" where ohs_id = ?"; //根据主键删除语句

static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_ALL = @"select * from \"open_hardware_sleep\""; //查询所有语句

static NSString *const MS_OPEN_HARDWARE_SLEEP_COUNT = @"select count(*) from \"open_hardware_sleep\""; //计数所有语句

static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_PAGE = @"select * from \"open_hardware_sleep\" limit ?,?"; //查询所有分页语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_DEVICEID = @"select * from \"open_hardware_sleep\" where device_id = ?"; //根据device_id查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_SLEEPSEC = @"select * from \"open_hardware_sleep\" where sleep_sec = ?"; //根据sleep_sec查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_SLEEPSECTION = @"select * from \"open_hardware_sleep\" where sleep_section = ?"; //根据sleep_section查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_STARTTIME = @"select * from \"open_hardware_sleep\" where start_time = ?"; //根据start_time查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_ENDTIME = @"select * from \"open_hardware_sleep\" where end_time = ?"; //根据end_time查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_USERID = @"select * from \"open_hardware_sleep\" where user_id = ?"; //根据user_id查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_EXTRA = @"select * from \"open_hardware_sleep\" where extra = ?"; //根据extra查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_SERVERID = @"select * from \"open_hardware_sleep\" where server_id = ?"; //根据server_id查询语句
static NSString *const MS_OPEN_HARDWARE_SLEEP_SELECT_BY_STATUS = @"select * from \"open_hardware_sleep\" where status = ?"; //根据status查询语句

/**
 *  对应数据表：yd_open_hardware_db.open_hardware_sleep
 */
@implementation OpenHardwareSleepDBDAO

/**
 *  创建表格
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable: (FMDatabase *)db {
	if (db) {
		return [db executeUpdate: MS_OPEN_HARDWARE_SLEEP_CREATE];
	}
	return NO;
}

/**
 *  插入一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwareSleep: (OpenHardwareSleep *)open_hardware_sleep intoDb: (FMDatabase *)db {
	if (open_hardware_sleep && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_SLEEP_INSERT, open_hardware_sleep.deviceId, open_hardware_sleep.sleepSec, open_hardware_sleep.sleepSection, [MSDB dateToTimestamp: open_hardware_sleep.startTime], [MSDB dateToTimestamp: open_hardware_sleep.endTime], open_hardware_sleep.userId, open_hardware_sleep.extra, open_hardware_sleep.serverId, open_hardware_sleep.status];
		open_hardware_sleep.ohsId = [NSNumber numberWithLongLong: db.lastInsertRowId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareSleepByPk: (OpenHardwareSleep *)open_hardware_sleep fromDb: (FMDatabase *)db {
	if (open_hardware_sleep && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_PK, open_hardware_sleep.ohsId];
		if ([rs next]) {
			open_hardware_sleep.ohsId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHS_ID]];
			open_hardware_sleep.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_sleep.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			open_hardware_sleep.sleepSection = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SECTION]];
			open_hardware_sleep.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			open_hardware_sleep.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
			open_hardware_sleep.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_sleep.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_sleep.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_sleep.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareSleep: (OpenHardwareSleep *)open_hardware_sleep fromDb: (FMDatabase *)db {
	if (open_hardware_sleep && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_NEW];
		if ([rs next]) {
			open_hardware_sleep.ohsId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHS_ID]];
			open_hardware_sleep.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_sleep.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			open_hardware_sleep.sleepSection = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SECTION]];
			open_hardware_sleep.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
			open_hardware_sleep.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
			open_hardware_sleep.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_sleep.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_sleep.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_sleep.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareSleep: (OpenHardwareSleep *)open_hardware_sleep byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
    if (open_hardware_sleep && db) {
        FMResultSet *rs = nil;
        if (device_identity && user_id) {
            rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_NEW_BY_CONDITION, device_identity, user_id];
        } else {
            rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_NEW];
        }
        
        if ([rs next]) {
            open_hardware_sleep.ohsId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHS_ID]];
            open_hardware_sleep.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            open_hardware_sleep.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
            open_hardware_sleep.startTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_START_TIME]]];
            open_hardware_sleep.endTime = [MSDB timestampToDate:[NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_END_TIME]]];
            open_hardware_sleep.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
            open_hardware_sleep.extra = [rs stringForColumn: MS_COL_EXTRA];
            open_hardware_sleep.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
            open_hardware_sleep.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
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
+ (NSMutableArray<OpenHardwareSleep *> *)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (FMDatabase *)db {
    return [self selectSleepByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: nil pageSize: nil fromDb: db];
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
+ (NSMutableArray<OpenHardwareSleep *> *)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
    NSInteger count = 0;
    BOOL flag = NO;
    NSMutableString *sql = [NSMutableString stringWithString: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_CONDITION];
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
            OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
            obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
            obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
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
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwareSleepByPk: (OpenHardwareSleep *)open_hardware_sleep ofDb: (FMDatabase *)db {
	if (open_hardware_sleep && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_SLEEP_UPDATE_BY_PK, open_hardware_sleep.deviceId, open_hardware_sleep.sleepSec, open_hardware_sleep.sleepSection, [MSDB dateToTimestamp: open_hardware_sleep.startTime], [MSDB dateToTimestamp: open_hardware_sleep.endTime], open_hardware_sleep.userId, open_hardware_sleep.extra, open_hardware_sleep.serverId, open_hardware_sleep.status, open_hardware_sleep.ohsId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_sleep	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwareSleepByPk: (OpenHardwareSleep *)open_hardware_sleep ofDb: (FMDatabase *)db {
	if (open_hardware_sleep && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_SLEEP_DELETE_BY_PK, open_hardware_sleep.ohsId];
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
+ (NSMutableArray *)selectAllOpenHardwareSleepFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_ALL];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSUInteger)countOpenHardwareSleepFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_COUNT];
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
+ (NSMutableArray *)selectOpenHardwareSleepPageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_PAGE, [NSNumber numberWithInteger: (page_no.integerValue - 1) * page_size.integerValue], page_size];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSMutableArray *)selectOpenHardwareSleepByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_DEVICEID, device_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
 *  根据sleepSec获取数据
 *
 *  @param sleep_sec	sleepSec
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepBySleepSec: (NSNumber *)sleep_sec fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_SLEEPSEC, sleep_sec];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
 *  根据sleepSection获取数据
 *
 *  @param sleep_section	sleepSection
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareSleepBySleepSection: (NSNumber *)sleep_section fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_SLEEPSECTION, sleep_section];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSMutableArray *)selectOpenHardwareSleepByStartTime: (NSDate *)start_time fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_STARTTIME, [MSDB dateToTimestamp: start_time]];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSMutableArray *)selectOpenHardwareSleepByEndTime: (NSDate *)end_time fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_ENDTIME, [MSDB dateToTimestamp: end_time]];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSMutableArray *)selectOpenHardwareSleepByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_USERID, user_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSMutableArray *)selectOpenHardwareSleepByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_EXTRA, extra_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSMutableArray *)selectOpenHardwareSleepByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_SERVERID, server_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
+ (NSMutableArray *)selectOpenHardwareSleepByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_SLEEP_SELECT_BY_STATUS, status_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareSleep *obj = [[OpenHardwareSleep alloc] init];
			obj.ohsId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHS_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.sleepSec = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SLEEP_SEC]];
			obj.sleepSection = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_SLEEP_SECTION]];
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
