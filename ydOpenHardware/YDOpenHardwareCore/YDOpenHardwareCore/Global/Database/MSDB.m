/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "MSDB.h"

@implementation MSDB

/**
 *  根据数据库路径和identifier初始化MSDB
 *
 *  @param path	数据库路径
 *  @param identifier	数据库identifier
 *
 *  @return MSDB对象
 */
-(instancetype)initWithPath:(NSString *)path identifier:(NSString *)identifier {
	self = [super init];
	if (self) {
		_dbPath = [path copy];
		_dbIdentifier = identifier;
	}
	return self;
}

/**
 *  初始化数据库
 *
 *  @param db	数据库对象
 */
-(void)initDb:(FMDatabase *)db {}

/**
 *  打开数据库连接，如果需要并做一些数据库更新操作
 */
-(BOOL)open {
	if(_db) {
		return YES;
	}
	
	_db = [[FMDatabase alloc] initWithPath:_dbPath];
	if(![_db open]) {
		_db = nil;
		return NO;
	}
	
	NSUInteger oldVersion = [[NSUserDefaults standardUserDefaults] integerForKey: [self dbIdentifier]];
	if (oldVersion < [self versionCode]) {
		[self upgradeDb: _db fromVersion: oldVersion toNewVersion: [self versionCode]];
		[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithUnsignedInteger: [self versionCode]] forKey: self.dbIdentifier];
	}
	
	[self initDb:_db];
	
	return YES;
}

/**
 *  清空对象引用
 */
- (void)dealloc {
    if (_db) {
        [_db close];
        _db = nil;
    }
    _dbPath = nil;
    _dbIdentifier = nil;
}

/**
 *  如果数据库版本变化会调用该方法
 *
 *  @param db	数据库对象
 *  @param oldVersion	数据库老版本号
 *  @param newVersion	数据库新版本号
 */
-(void)upgradeDb:(FMDatabase *)db fromVersion:(NSUInteger)oldVersion toNewVersion:(NSUInteger)newVersion {}

/**
 *  数据库当前版本号
 */
-(NSUInteger)versionCode {
	return 0;
}

/**
 *  日期转timestamp
 *
 *  @param date 日期
 *
 *  @return timestamp （NSNumber）
 */
+ (NSNumber *)dateToTimestamp: (NSDate *)date {
	return [NSNumber numberWithDouble: ([date timeIntervalSince1970] * 1000)];
}

/**
 *  timestamp转日期
 *
 *  @param timestamp NSNumber
 *
 *  @return 日期
 */
+ (NSDate *)timestampToDate: (NSNumber *)timestamp {
	return [NSDate dateWithTimeIntervalSince1970: ([timestamp doubleValue] / 1000)];
}

/**
 *  bool转number
 *
 *  @param flag bool
 *
 *  @return number
 */
+ (NSNumber *)boolToNumber: (BOOL)flag {
	return flag ? [NSNumber numberWithInt: 1] : [NSNumber numberWithInt: 0];
}
/**
 *  number转bool
 *
 *  @param number NSNumber
 *
 *  @return bool
 */
+ (BOOL)numberToBool: (NSNumber *)number {
	return number.intValue > 0 ? YES : NO;
}



@end