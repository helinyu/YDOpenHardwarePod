//
//  YDBluetoothWebViewMgr+Extension.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/15.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+Extension.h"

@implementation YDBluetoothWebViewMgr (Extension)

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

@end
