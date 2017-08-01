#import <Foundation/Foundation.h>

////Debug
//#define MSLogD(desStr) [MSLog logD:[NSString stringWithFormat:@"Function:%s Line:%d Des:%@",__func__,__LINE__,desStr],@""];
////Info
//#define MSLogI(desStr) [MSLog logI:[NSString stringWithFormat:@"Function:%s Line:%d Des:%@",__func__,__LINE__,desStr],@""];
////Warning
//#define MSLogW(desStr) [MSLog logW:[NSString stringWithFormat:@"Function:%s Line:%d Des:%@",__func__,__LINE__,desStr],@""];
////Error
//#define MSLogE(desStr) [MSLog logE:[NSString stringWithFormat:@"Function:%s Line:%d Des:%@",__func__,__LINE__,desStr],@""];

//Debug
#define MSLogD(desStr, ...) [MSLog logD: desStr, ##__VA_ARGS__];
//Info 
#define MSLogI(desStr, ...) [MSLog logI: desStr, ##__VA_ARGS__];
//Warning
#define MSLogW(desStr, ...) [MSLog logW: desStr, ##__VA_ARGS__];
//Error
#define MSLogE(desStr, ...) [MSLog logE: desStr, ##__VA_ARGS__];

//Debug
#define MSPrettyLogD(desStr, ...) [MSLog logD: @"\nFunction:%s \nLine:%d Des: \n" desStr, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
//Info
#define MSPrettyLogI(desStr, ...) [MSLog logI: @"\nFunction:%s \nLine:%d Des: \n" desStr, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
//Warning
#define MSPrettyLogW(desStr, ...) [MSLog logW: @"\nFunction:%s \nLine:%d Des: \n" desStr, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];
//Error
#define MSPrettyLogE(desStr, ...) [MSLog logE: @"\nFunction:%s \nLine:%d Des: \n" desStr, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];



//日志等级
typedef NS_ENUM(NSInteger, MSLogLevel) {
    LOGLEVELV = 0, //wend
    LOGLEVELD,     //Debug
    LOGLEVELI,     //Info
    LOGLEVELW,     //Warning
    LOGLEVELE      //Error
};

@interface MSLog : NSObject

/**
 *  log初始化函数，在系统启动时调用
 */
+ (void)logIntial;

/**
 *  设置要记录的log级别
 *
 *  @param level level 要设置的log级别
 */
+ (void)setLogLevel:(MSLogLevel)level;

/**
 *  记录系统crash的Log函数
 *
 *  @param exception 系统异常
 */
+ (void)logCrash:(NSException*)exception;

/**
 *  log记录函数
 *
 *  @param level  log所属的等级
 *  @param format 具体记录log的格式以及内容
 */
+ (void)logLevel:(MSLogLevel)level LogInfo:(NSString*)format,... NS_FORMAT_FUNCTION(2,3);

/**
 *  LOGLEVELV级Log记录函数
 *
 *  @param format format 具体记录log的格式以及内容
 */
+ (void)logV:(NSString*)format,... NS_FORMAT_FUNCTION(1,2);

/**
 *  LOGLEVELD级Log记录函数
 *
 *  @param format 具体记录log的格式以及内容
 */
+ (void)logD:(NSString*)format,... NS_FORMAT_FUNCTION(1,2);

/**
 *  LOGLEVELI级Log记录函数
 *
 *  @param format 具体记录log的格式以及内容
 */
+ (void)logI:(NSString*)format,... NS_FORMAT_FUNCTION(1,2);

/**
 *  LOGLEVELW级Log记录函数
 *
 *  @param format 具体记录log的格式以及内容
 */
+ (void)logW:(NSString*)format,... NS_FORMAT_FUNCTION(1,2);

/**
 *  LOGLEVELE级Log记录函数
 *
 *  @param format 具体记录log的格式以及内容
 */
+ (void)logE:(NSString*)format,... NS_FORMAT_FUNCTION(1,2);

@end
