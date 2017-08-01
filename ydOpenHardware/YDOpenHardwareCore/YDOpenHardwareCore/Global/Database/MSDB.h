/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define MS_COL_SUM @"sum"

@interface MSDB : NSObject

@property (atomic, readonly, strong) FMDatabase* db; //fmdb数据库辅助操作对象
@property (nonatomic, readonly, strong) NSString* dbPath; //数据库路径
@property (nonatomic, readonly, strong) NSString* dbIdentifier; //数据库identifier，建议使用uid+db文件名


/**
 *  根据数据库路径和identifier初始化MSDB
 *
 *  @param path	数据库路径
 *  @param identifier	数据库identifier
 *
 *  @return MSDB对象
 */
-(instancetype)initWithPath:(NSString *)path identifier:(NSString *)identifier;

/**
 *  初始化数据库
 *
 *  @param db	数据库对象
 */
-(void)initDb:(FMDatabase *)db;

/**
 *  打开数据库连接，如果需要并做一些数据库更新操作
 */
-(BOOL)open;

/**
 *  如果数据库版本变化会调用该方法
 *
 *  @param db	数据库对象
 *  @param oldVersion	数据库老版本号
 *  @param newVersion	数据库新版本号
 */
-(void)upgradeDb:(FMDatabase *)db fromVersion:(NSUInteger)oldVersion toNewVersion:(NSUInteger)newVersion;

/**
 *  数据库当前版本号
 */
-(NSUInteger)versionCode;

/**
 *  日期转timestamp
 *
 *  @param date 日期
 *
 *  @return timestamp （NSNumber）
 */
+ (NSNumber *)dateToTimestamp: (NSDate *)date;

/**
 *  timestamp转日期
 *
 *  @param timestamp NSNumber
 *
 *  @return 日期
 */
+ (NSDate *)timestampToDate: (NSNumber *)timestamp;

/**
 *  bool转number
 *
 *  @param flag bool
 *
 *  @return number
 */
+ (NSNumber *)boolToNumber: (BOOL)flag;
/**
 *  number转bool
 *
 *  @param number NSNumber
 *
 *  @return bool
 */
+ (BOOL)numberToBool: (NSNumber *)number;



@end