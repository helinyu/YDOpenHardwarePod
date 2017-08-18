//
//  YDBluetoothWebViewMgr+WriteDatas.h
//  test_yuedong_band
//
//  Created by Aka on 2017/8/17.
//  Copyright © 2017年 forest. All rights reserved.
//

#import "YDBluetoothWebViewMgr.h"

@interface YDBluetoothWebViewMgr (WriteDatas)

- (void)connectAlert;
- (void)setSystemTime;
-(void)startRealtimeStep;
- (void)readMacAddress;
- (void)writeStepTarget;
-(void)bandSync;//获取历史数据


/**
 *22. 读取设备电量
 命令格式：         0x12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 功能：            恢复到出厂最小电流
 描述：
 命令回复：
 校验正确且执行OK返回：    0x12 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 校验错误或执行Fail返回：    0x92 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 */
- (void)readDeviceEnergy;


- (void)telRemind;

@end
