//
//  YDBluetoothWebViewMgr+Extension.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/15.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr.h"

@interface YDBluetoothWebViewMgr (Extension)

- (void)onAlarmClicked;

- (void)registerExtension;

-(void)writeByteWithHeader:(Byte)header andData:(NSData *)datas;

- (void)setTelEnable:(BOOL)telEnable andMessageEnable:(BOOL)messageEnable;

- (void)writeBaseDatas;

/**
 *23. 设备绑定
 命令格式： 0x20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 功能：蓝牙在连接的时候，向设置发起绑定命令。
 描述：
 命令回复：
 校验正确且执行OK返回：0x20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 校验错误或执行Fail返回：0xA0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 */
- (void)deviceBinding;

/**
 *24. 绑定应答
 命令格式： 0x21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 功能：设备收到绑定命令后，如果10秒内用户敲击计步器，则会返回这条指令。
 描述：
 命令回复：
 校验正确且执行OK返回：0x21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 校验错误或执行Fail返回：0xA1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 CRC
 */
- (void)bindingResponse;

@end
