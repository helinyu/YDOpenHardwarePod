//
//  YDBluetoothWebViewMgr+Extension.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/15.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+Extension.h"
#import "WebViewJavascriptBridge.h"
#import "NSData+YDConversion.h"
#import "YDBluetoothWebViewMgr+WriteDatas.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@implementation YDBluetoothWebViewMgr (Extension)

- (void)registerExtension {
    NSLog(@"注册额外的内容");
    
    //    for test yuedong own band
    __weak typeof (self) wSelf = self;
    
    [self.webViewBridge registerHandler:@"onSetPhoneCallOnClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf setTelEnable:YES andMessageEnable:YES];
    }];
    
    [self.webViewBridge registerHandler:@"onWriteDatasWithHeader" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"log : %@",[data objectForKey:@"log"]);
        NSString *value = [data objectForKey:@"value"];
        Byte headerV = (Byte)[[data objectForKey:@"header"] integerValue];
        if (value.length <= 0) {
            NSLog(@"解析之后传入value是空");
            return;
        }
        NSData *contentDatas = [NSData dataWithHexString:value];
        [self writeByteWithHeader:headerV andData:contentDatas];
    }];
    
    [self.webViewBridge registerHandler:@"testAlarmPhone" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"test alarm phoen %@",data);
        [wSelf testAlarmPhone];
    }];
    
    [self.webViewBridge registerHandler:@"connectAlert" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self connectAlert];
    }];
    
    [self.webViewBridge registerHandler:@"setSystemTime" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self setSystemTime];
    }];
    
    [self.webViewBridge registerHandler:@"startRealtimeStep" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self startRealtimeStep];
    }];
    
    [self.webViewBridge registerHandler:@"readMacAddress" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self readMacAddress];
    }];
    
    [self.webViewBridge registerHandler:@"writeStepTarget" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self writeStepTarget];
    }];
    
    [self.webViewBridge registerHandler:@"bandSync" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self bandSync];
    }];
    
    [self.webViewBridge registerHandler:@"onPower" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self readDeviceEnergy];
    }];
    
    [self.webViewBridge registerHandler:@"onWriteBase" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self writeDataForReadBase];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStepDatasNotify:) name:@"stepAndDsitance" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnergeNotify:) name:@"energyData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDistibutionNotify:) name:@"ydDataistribution" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMacAddressNotify:) name:@"ydMacAddress" object:nil];

}

- (void)writeBaseDatas {
    [self connectAlert];
    [self setSystemTime];
    [self startRealtimeStep];
    [self readMacAddress];
    [self writeStepTarget];
    [self bandSync];
}

- (void)writeDataForReadBase {
    [self setSystemTime];
    [self startRealtimeStep];
    [self readMacAddress];
    [self writeStepTarget];
    [self bandSync];
}

- (void)onMacAddressNotify:(NSNotification*)noti {
    NSString *deviceSting = [noti.object objectForKey:@"deviceSeq"];
    [self.webViewBridge callHandler:@"onMacAddress" data:@{@"deviceSeq":deviceSting} responseCallback:^(id responseData) {
    }];
}

- (void)onStepDatasNotify:(NSNotification *)noti {
    NSLog(@"notif : %@",noti.object);
    [self.webViewBridge callHandler:@"onStepDatas" data:noti.object responseCallback:^(id responseData) {
        
    }];
}

- (void)onDistibutionNotify:(NSNotification *)noti {
    [self.webViewBridge callHandler:@"onDistibute" data:noti.object responseCallback:^(id responseData) {
        
    }];
}

- (void)onEnergeNotify:(NSNotification *)noti {
    NSLog(@"energe : %@",noti.object);
    NSInteger num = [[noti.object objectForKey:@"energy"] integerValue];
    CGFloat percent = 12.5 * num;
    NSString *percentString = [NSString stringWithFormat:@"%%%.1f",percent];
    
    [self.webViewBridge callHandler:@"onEnergeDatas" data:@{@"energy":percentString} responseCallback:^(id responseData) {
        
    }];
}

- (void)testAlarmPhone {
    Byte header = (Byte) 0x85;
    Byte data[] = {0x01, 0X01, 0X01};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:3];
    [self writeByteWithHeader:header andData:data0];
    
    Byte data1[] = {0x02, 0X02};
    NSData *data10 = [[NSData alloc] initWithBytes:data1 length:2];
    [self writeByteWithHeader:header andData:data10];
}

- (void)onAlarmClicked {
    [self transferMotorSignalWithTimeLength:10];
}

//查找丢失的手环
- (void)transferMotorSignalWithTimeLength:(NSInteger)timeLength{
//    Byte crc = (0x36 + (Byte)timeLength) & 0xFF;
    Byte data[] = { 0x36, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40};
    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
//    [self writeDataWithByte:data0];
    [self writeDatas:data0];
}

-(void)writeByteWithHeader:(Byte)header andData:(NSData *)data
{
    NSData *encodeData0=[self writeProtocolDataBytesWithData:data];
    
    Byte *encodeData = (Byte *)[encodeData0 bytes];
    NSInteger encodeDataLength = encodeData0.length;
    Byte byte_send[3 + encodeDataLength];
    byte_send[0] = header;
    byte_send[1] = (Byte) (encodeDataLength + 1);
    for (int i = 2; i < encodeDataLength + 2; i++) {
        byte_send[i] = encodeData[i - 2];
    }
    fillCheckSumByte(byte_send,encodeDataLength+3);
    
    Boolean isValid = isCheckSumValid(byte_send,encodeDataLength+3);
    if (!isValid) {
        NSLog(@"校验失败");
    }
    
    NSData *sendData = [[NSData alloc] initWithBytes:byte_send length:encodeData0.length + 3];
//    [self writeDataWithByte:sendData];
    [self writeDatas:sendData];
}

void fillCheckSumByte(Byte buf[] ,NSInteger bufLength) {
    Byte checksum = 0;
    int i;
    for (i = 0; i < bufLength - 1; i++)
        checksum = (Byte) (checksum + buf[i]);
    checksum = (Byte) (((~checksum) + 1) & 0x7F);
    buf[bufLength - 1] = checksum;
}

Boolean isCheckSumValid(Byte *rcvBuff, NSInteger rcvBuffLength) {
    Byte checksum = rcvBuff[0];
    int i = 0;
    
    for (i = 1; i < rcvBuffLength; i++) {
        if (rcvBuff[i] >= 0x80)
            return false;
        checksum = (Byte) (checksum + rcvBuff[i]);
    }
    checksum &= 0x7F;
    if (0 == checksum)
        return true;
    return false;
}

-(NSData *)writeProtocolDataBytesWithData:(NSData *)sData
{
    int n = 0;
    int i, j, leastBit = 0;
    int bit7 = 0;
    
    Byte *sDataB = (Byte *)[sData bytes];
    
    NSInteger sDataBLength = sData.length;
    NSInteger count = (sDataBLength * 8 + 7 - 1) / 7;
    Byte d[count];
    for(int i = 0;i<count;i++)
    {
        d[i] = 0;
    }
    
    for (i = 0; i < sData.length; i++) {
        for (j = 0; j < 8; j++) {
            leastBit = (sDataB[i] >> j) & 0x01;
            //            MSLogI(@"leastBit=%x",leastBit);
            d[n] |= leastBit << (bit7++);
            //            MSLogI(@"d[%d]==%d",n,d[n]);
            if (7 == bit7) {
                bit7 = 0;
                n++;
            }
        }
    }
    NSData *dData = [[NSData alloc]initWithBytes:d length:count];
    return dData;
}

//for test my band tools

- (void)setSystemTime
{
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
    [self writeDatas:data0];
}


//test for target write step
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
    [self writeDatas:data0];
}

- (void)writeStepTarget{
//    _stepTarget = [NSNumber numberWithInteger:10000];
//        [[NSUserDefaults standardUserDefaults] setObject:_stepTarget forKey:STEP_TARGET_DAY];
//    }
//    NSNumber *_rewardAimStep = [[NSUserDefaults standardUserDefaults] objectForKey:@"day_aim_step"];
//    if (_rewardAimStep == nil) {
//        _rewardAimStep = [NSNumber numberWithInteger:10000];
//    }
//默认是10000步数 时间：86400s 一天
    [self setStepTargetWithStep:5000 andRewardStep:86400];
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
    [self writeDatas:data0];
}


@end
