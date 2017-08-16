//
//  YDBluetoothWebViewMgr+Extension.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/15.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+Extension.h"

@implementation YDBluetoothWebViewMgr (Extension)

//- (void)onAlarmClicked {
//    [self transferMotorSignalWithTimeLength:10];
//}
//
////查找丢失的手环
//- (void)transferMotorSignalWithTimeLength:(NSInteger)timeLength{
////    Byte crc = (0x36 + (Byte)timeLength) & 0xFF;
//    Byte data[] = { 0x36, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x40};
//    NSData *data0 = [[NSData alloc] initWithBytes:data length:16];
////    [self writeDataWithByte:data0];
//    [self writeDatas:data0];
//}

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

@end
