//
//  MSMTSDB.h
//  SportsInternational
//
//  Created by 张旻可 on 15/11/4.
//  Copyright © 2015年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MSDatabaseQueue.h"

@interface MSMTSDB : NSObject

@property (nonatomic, readonly, strong) MSDatabaseQueue* dbqMain; //fmdb数据库辅助操作对象主要线程队列
@property (nonatomic, readonly, strong) MSDatabaseQueue* dbqRead; //fmdb数据库辅助操作对象读线程队列
//@property (nonatomic, readonly, strong) FMDatabaseQueue* dbqWrite; //fmdb数据库辅助操作对象写线程队列
@property (nonatomic, readonly, strong) NSString* dbPath; //数据库路径
@property (nonatomic, readonly, strong) NSString* dbIdentifier; //数据库identifier，建议使用uid+db文件名

@property BOOL inited;
@property BOOL updated;


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
 *  如果数据库版本变化会调用该方法
 *
 *  @param dbq	数据库对象q
 *  @param oldVersion	数据库老版本号
 *  @param newVersion	数据库新版本号
 */
-(void)upgradeDbQ:(MSDatabaseQueue *)dbq fromVersion:(NSUInteger)oldVersion toNewVersion:(NSUInteger)newVersion;

/**
 *  数据库当前版本号
 */
-(NSUInteger)versionCode;

- (void)inSyncMainDatabase: (void (^)(FMDatabase *db))block;
- (void)inSyncMainTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)inSyncMainDeferredTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)inSyncReadDatabase: (void (^)(FMDatabase *db))block;
- (void)inSyncReadTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)inSyncReadDeferredTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;

- (void)inAsyncMainDatabase: (void (^)(FMDatabase *db))block;
- (void)inAsyncMainTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)inAsyncMainDeferredTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)inAsyncReadDatabase: (void (^)(FMDatabase *db))block;
- (void)inAsyncReadTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)inAsyncReadDeferredTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
- (void)inAsyncMainDatabase: (void (^)(FMDatabase *db))block completHandler: (void (^)())complet_handler;
- (void)inAsyncMainTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;
- (void)inAsyncMainDeferredTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;
- (void)inAsyncReadDatabase: (void (^)(FMDatabase *db))block completHandler: (void (^)())complet_handler;
- (void)inAsyncReadTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;
- (void)inAsyncReadDeferredTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;
//- (void)inWriteDatabase: (void (^)(FMDatabase *db))block;
//- (void)inWriteTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;
//- (void)inWriteDeferredTransaction: (void (^)(FMDatabase *db, BOOL *rollback))block;

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
