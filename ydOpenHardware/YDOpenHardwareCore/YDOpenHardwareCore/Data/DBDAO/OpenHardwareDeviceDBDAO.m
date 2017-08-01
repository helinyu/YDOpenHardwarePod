/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "OpenHardwareDeviceDBDAO.h"
#import "MSDB.h"



static NSString *const MS_COL_OHD_ID = @"ohd_id"; //列名
static NSString *const MS_COL_DEVICE_ID = @"device_id"; //列名
static NSString *const MS_COL_PLUG_NAME = @"plug_name"; //列名
static NSString *const MS_COL_USER_ID = @"user_id"; //列名
static NSString *const MS_COL_EXTRA = @"extra"; //列名
static NSString *const MS_COL_SERVER_ID = @"server_id"; //列名
static NSString *const MS_COL_STATUS = @"status"; //列名

static NSString *const MS_OPEN_HARDWARE_DEVICE_CREATE = @"CREATE TABLE IF NOT EXISTS open_hardware_device (    ohd_id integer PRIMARY KEY AUTOINCREMENT NOT NULL,    device_id text NOT NULL,    plug_name text NOT NULL,    user_id integer NOT NULL,    extra text DEFAULT(''),    server_id integer DEFAULT(-1),    status integer DEFAULT(0)  )"; //创建语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_INSERT = @"insert into \"open_hardware_device\"(device_id,plug_name,user_id,extra,server_id,status) values(?,?,?,?,?,?)"; //插入语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_PK = @"select * from \"open_hardware_device\" where ohd_id = ?"; //根据主键查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_DEVICE = @"select * from \"open_hardware_device\" where device_id = ? and plug_name = ? and user_id = ?"; //根据数据查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_DEVICE_NO_PLUG = @"select * from \"open_hardware_device\" where device_id = ? and user_id = ?"; //根据数据查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_NEW = @"select * from \"open_hardware_device\" order by ohd_id desc limit 0,1"; //获取最新一条记录语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_UPDATE_BY_PK = @"update \"open_hardware_device\" set device_id = ?, plug_name = ?, user_id = ?, extra = ?, server_id = ?, status = ? where ohd_id = ?"; //根据主键更新语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_DELETE_BY_PK = @"delete from \"open_hardware_device\" where ohd_id = ?"; //根据主键删除语句

static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_ALL = @"select * from \"open_hardware_device\""; //查询所有语句

static NSString *const MS_OPEN_HARDWARE_DEVICE_COUNT = @"select count(*) from \"open_hardware_device\""; //计数所有语句

static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_PAGE = @"select * from \"open_hardware_device\" limit ?,?"; //查询所有分页语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_DEVICEID = @"select * from \"open_hardware_device\" where device_id = ?"; //根据device_id查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_PLUGNAME = @"select * from \"open_hardware_device\" where plug_name = ?"; //根据plug_name查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_USERID = @"select * from \"open_hardware_device\" where user_id = ?"; //根据user_id查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_EXTRA = @"select * from \"open_hardware_device\" where extra = ?"; //根据extra查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_SERVERID = @"select * from \"open_hardware_device\" where server_id = ?"; //根据server_id查询语句
static NSString *const MS_OPEN_HARDWARE_DEVICE_SELECT_BY_STATUS = @"select * from \"open_hardware_device\" where status = ?"; //根据status查询语句

/**
 *  对应数据表：yd_open_hardware_db.open_hardware_device
 */
@implementation OpenHardwareDeviceDBDAO

/**
 *  创建表格
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable: (FMDatabase *)db {
	if (db) {
		return [db executeUpdate: MS_OPEN_HARDWARE_DEVICE_CREATE];
	}
	return NO;
}

/**
 *  插入一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertOpenHardwareDevice: (OpenHardwareDevice *)open_hardware_device intoDb: (FMDatabase *)db {
	if (open_hardware_device && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_DEVICE_INSERT, open_hardware_device.deviceId, open_hardware_device.plugName, open_hardware_device.userId, open_hardware_device.extra, open_hardware_device.serverId, open_hardware_device.status];
		open_hardware_device.ohdId = [NSNumber numberWithLongLong: db.lastInsertRowId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareDeviceByPk: (OpenHardwareDevice *)open_hardware_device fromDb: (FMDatabase *)db {
	if (open_hardware_device && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_PK, open_hardware_device.ohdId];
		if ([rs next]) {
			open_hardware_device.ohdId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHD_ID]];
			open_hardware_device.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_device.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
			open_hardware_device.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_device.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_device.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_device.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据数据获取一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectOpenHardwareDeviceByDevice: (OpenHardwareDevice *)open_hardware_device fromDb: (FMDatabase *)db {
    if (open_hardware_device && db) {
        FMResultSet *rs = nil;
        if (open_hardware_device.plugName != nil) {
            rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_DEVICE, open_hardware_device.deviceId, open_hardware_device.plugName, open_hardware_device.userId];
        } else {
            rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_DEVICE_NO_PLUG, open_hardware_device.deviceId, open_hardware_device.userId];
        }
        if ([rs next]) {
            open_hardware_device.ohdId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHD_ID]];
            open_hardware_device.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
            open_hardware_device.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
            open_hardware_device.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
            open_hardware_device.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
            open_hardware_device.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
            [rs close];
            return YES;
        }
    }
    return NO;
}

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewOpenHardwareDevice: (OpenHardwareDevice *)open_hardware_device fromDb: (FMDatabase *)db {
	if (open_hardware_device && db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_NEW];
		if ([rs next]) {
			open_hardware_device.ohdId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_OHD_ID]];
			open_hardware_device.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			open_hardware_device.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
			open_hardware_device.userId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_USER_ID]];
			open_hardware_device.extra = [rs stringForColumn: MS_COL_EXTRA];
			open_hardware_device.serverId = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_SERVER_ID]];
			open_hardware_device.status = [NSNumber numberWithDouble: [rs doubleForColumn: MS_COL_STATUS]];
			[rs close];
			return YES;
		}
	}
	return NO;
}

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateOpenHardwareDeviceByPk: (OpenHardwareDevice *)open_hardware_device ofDb: (FMDatabase *)db {
	if (open_hardware_device && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_DEVICE_UPDATE_BY_PK, open_hardware_device.deviceId, open_hardware_device.plugName, open_hardware_device.userId, open_hardware_device.extra, open_hardware_device.serverId, open_hardware_device.status, open_hardware_device.ohdId];
		return flag;
	}
	return NO;
}

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_device	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteOpenHardwareDeviceByPk: (OpenHardwareDevice *)open_hardware_device ofDb: (FMDatabase *)db {
	if (open_hardware_device && db) {
		BOOL flag = [db executeUpdate: MS_OPEN_HARDWARE_DEVICE_DELETE_BY_PK, open_hardware_device.ohdId];
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
+ (NSMutableArray *)selectAllOpenHardwareDeviceFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_ALL];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
+ (NSUInteger)countOpenHardwareDeviceFromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_COUNT];
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
+ (NSMutableArray *)selectOpenHardwareDevicePageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_PAGE, [NSNumber numberWithInteger: (page_no.integerValue - 1) * page_size.integerValue], page_size];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
+ (NSMutableArray *)selectOpenHardwareDeviceByDeviceId: (NSString *)device_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_DEVICEID, device_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
 *  根据plugName获取数据
 *
 *  @param plug_name	plugName
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectOpenHardwareDeviceByPlugName: (NSString *)plug_name fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_PLUGNAME, plug_name];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
+ (NSMutableArray *)selectOpenHardwareDeviceByUserId: (NSNumber *)user_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_USERID, user_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
+ (NSMutableArray *)selectOpenHardwareDeviceByExtra: (NSString *)extra_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_EXTRA, extra_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
+ (NSMutableArray *)selectOpenHardwareDeviceByServerId: (NSNumber *)server_id fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_SERVERID, server_id];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
+ (NSMutableArray *)selectOpenHardwareDeviceByStatus: (NSNumber *)status_ fromDb: (FMDatabase *)db {
	if (db) {
		FMResultSet *rs = [db executeQuery: MS_OPEN_HARDWARE_DEVICE_SELECT_BY_STATUS, status_];
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		while ([rs next]) {
			OpenHardwareDevice *obj = [[OpenHardwareDevice alloc] init];
			obj.ohdId = [NSNumber numberWithLongLong: [rs longLongIntForColumn: MS_COL_OHD_ID]];
			obj.deviceId = [rs stringForColumn: MS_COL_DEVICE_ID];
			obj.plugName = [rs stringForColumn: MS_COL_PLUG_NAME];
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
