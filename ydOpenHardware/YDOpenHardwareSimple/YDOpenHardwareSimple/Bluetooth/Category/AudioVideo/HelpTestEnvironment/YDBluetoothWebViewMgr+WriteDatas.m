//
//  YDBluetoothWebViewMgr+WriteDatas.m
//  test_yuedong_band
//
//  Created by Aka on 2017/8/17.
//  Copyright © 2017年 forest. All rights reserved.
//

#import "YDBluetoothWebViewMgr+WriteDatas.h"

@implementation YDBluetoothWebViewMgr (WriteDatas)

/**
 43. 传送马达振动信号
 */
- (void)transferMotorSignalWithTimeLength:(NSInteger)timeLength{
    Byte crc = (0x36 + (Byte)timeLength) & 0xFF;
    Byte data[] = { 0x36, (Byte)timeLength, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,crc};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

- (void)connectAlert{
        [self transferMotorSignalWithTimeLength:1];
}

- (void)setSystemTime
{
    //得到时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        //        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yy:MM:dd:HH:mm:ss"];
        NSDate *today = [NSDate date];
        NSString *str=[dateFormatter stringFromDate:today];
        NSArray *arr=[str componentsSeparatedByString:@":"];
        if (arr.count == 6) {
            int year0 = ((NSString *)arr[0]).intValue;
            int month0 = ((NSString *)arr[1]).intValue;
            int day0 = ((NSString *)arr[2]).intValue;
            int hour0 = ((NSString *)arr[3]).intValue;
            int min0 = ((NSString *)arr[4]).intValue;
            int sec0 = ((NSString *)arr[5]).intValue;
            
            Byte year1 = (Byte)(year0/10) << 4;
            Byte year2 = (Byte)(year0%10);
            Byte year = year1 + year2;
            
            Byte month1 = (Byte)(month0/10) << 4;
            Byte month2 = (Byte)(month0%10);
            Byte month = month1 + month2;
            
            Byte day1 = (Byte)(day0/10) << 4;
            Byte day2 = (Byte)(day0%10);
            Byte day = day1 + day2;
            
            Byte hour1 = (Byte)(hour0/10) << 4;
            Byte hour2 = (Byte)(hour0%10);
            Byte hour = hour1 + hour2;
            
            Byte min1 = (Byte)(min0/10) << 4;
            Byte min2 = (Byte)(min0%10);
            Byte min = min1 + min2;
            
            Byte sec1 = (Byte)(sec0/10) << 4;
            Byte sec2 = (Byte)(sec0%10);
            Byte sec = sec1 + sec2;
            
            [self setTimeWithYear:year andMonth:month andDay:day andHour:hour andMin:min andSec:sec];
    }
}

- (void)setTimeWithYear:(Byte)year
               andMonth:(Byte)month
                 andDay:(Byte)day
                andHour:(Byte)hour
                 andMin:(Byte)min
                 andSec:(Byte)sec
{
    Byte crc0 = 0x01 + year + month + day + hour + min + sec;
    Byte crc1 = crc0 & 0xFF;
    
    Byte data[] = { 0x01, year, month, day, hour, min, sec,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,crc1};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

/**
 *11. 启动实时计步模式
 */
-(void)startRealtimeStep
{
    Byte data[] = { 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x09};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

/**
 25. 读取MAC地址
 */
- (void)readMacAddress{
    Byte data[] = {0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x22};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

- (void)writeStepTarget{
   NSNumber *_stepTarget = [NSNumber numberWithInteger:10000];
//        [[NSUserDefaults standardUserDefaults] setObject:_stepTarget forKey:STEP_TARGET_DAY];
        NSNumber *_rewardAimStep = @(200);
    //    NSNumber *_rewardAimStep = [[NSUserDefaults standardUserDefaults] objectForKey:@"day_aim_step"];
    if (_rewardAimStep == nil) {
        _rewardAimStep = [NSNumber numberWithInteger:10000];
    }
    [self setStepTargetWithStep:_stepTarget.integerValue andRewardStep:_rewardAimStep.integerValue];
}

- (void)setStepTargetWithStep:(NSInteger)step andRewardStep:(NSInteger)rewardStep{
    Byte AA = (step & 0xFF0000) >> 16;
    Byte BB = (step & 0x00FF00) >> 8;
    Byte CC = (step & 0x0000FF);
    
    Byte DD = (rewardStep & 0xFF0000) >> 16;
    Byte EE = (rewardStep & 0x00FF00) >> 8;
    Byte FF = (rewardStep & 0x0000FF);
    
    Byte crc = (0x0B + AA + BB + CC + DD + EE + FF) & 0xFF;
    Byte data[] = { 0x0B, AA, BB, CC, DD, EE, FF,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,crc};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

/**
 13. 设置目标
 */
- (void)setStepTargetWithStep:(NSInteger)step{
    Byte AA = (step & 0xFF0000) >> 16;
    Byte BB = (step & 0x00FF00) >> 8;
    Byte CC = (step & 0x0000FF);
    Byte crc = (0x0B + AA + BB + CC) & 0xFF;
    Byte data[] = { 0x0B, AA, BB, CC, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,crc};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

-(void)bandSync//获取历史数据
{
//    _isBandSync = YES;
//    if (!_isGetDeviceSeq) {
        [self readMacAddress];
//    }else{
//        _todayNum = [TimeConversion numberFromDate:[NSDate date]];
//        _isBandSync = NO;
        [self checkDataSaveDistribution];
//    }
}

/**
 8.查询数据存储分布
 */
- (void)checkDataSaveDistribution{
    Byte data[] = { 0x46, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x46};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

/**
 22. 读取设备电量
 */
- (void)readDeviceEnergy{
    Byte data[] = {0x13, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x13};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

/**
 55. 设置ANCS的开关
 */
- (void)setTelEnable:(BOOL)telEnable andMessageEnable:(BOOL)messageEnable{
    Byte AA = 0x00;
    Byte tel = 0x00;
    if (telEnable) {
        tel = 0x01;
    }
    Byte message = 0x00;
    if (message) {
        message = 0x02;
    }
    AA = tel + message;
    Byte crc = (0x60 + AA) & 0xFF;
    Byte data[] = {0x60, AA, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,crc};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

- (void)telRemind{
    Byte data[] = {0x4D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x4D};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

- (void)messageRemind{
    Byte data[] = {0x4D, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x4E};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

/**
 21. 恢复出厂设置
 */
- (void)RestoreFactorySettings{
    Byte data[] = {0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
    [self writeDataWithByte:data0];
}

@end
