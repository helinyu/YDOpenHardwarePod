/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "YDOpenHardwareDB.h"

#import "OpenHardwareDeviceDBDAO.h"
#import "OpenHardwareHeartRateDBDAO.h"
#import "OpenHardwarePedometerDBDAO.h"
#import "OpenHardwareSleepDBDAO.h"
#import "OpenHardwareIntelligentScaleDBDAO.h"

#import "YDConstant.h"

static YDOpenHardwareDB *sOpenHardwareDB;

@implementation YDOpenHardwareDB

/**
 *  初始化数据库
 *
 *  @param db	数据库对象
 */
-(void)initDb: (FMDatabase *)db {
	[super initDb: db];
	[OpenHardwareDeviceDBDAO createTable: db];
	[OpenHardwareHeartRateDBDAO createTable: db];
	[OpenHardwarePedometerDBDAO createTable: db];
	[OpenHardwareSleepDBDAO createTable: db];
    [OpenHardwareIntelligentScaleDBDAO createTable: db];
}

+ (YDOpenHardwareDB *)sharedDb {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sOpenHardwareDB == nil) {
            NSArray * arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * path = [arr objectAtIndex: 0];
            path = [path stringByAppendingPathComponent: YDOPENHARDWARE_DB_NAME];
//            MSLogI(@"path is %@",path);
            sOpenHardwareDB = [[YDOpenHardwareDB alloc] initWithPath: path identifier: YDOPENHARDWARE_DB_IDENTIFIER];
            [sOpenHardwareDB open];
        }
    });
    return sOpenHardwareDB;
}

- (void)upgradeDb:(FMDatabase *)db fromVersion:(NSUInteger)oldVersion toNewVersion:(NSUInteger)newVersion {
}

- (NSUInteger)versionCode {
    return 1;
}

@end