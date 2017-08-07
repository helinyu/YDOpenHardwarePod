//
//  NSData+YDConversion.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/7.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "NSData+YDConversion.h"

@implementation NSData (YDConversion)

+ (NSData *)convertFromHexString:(NSString *)message length:(NSInteger)length {
    NSString *hexString = message; //16进制字符串
    int j=0;
    Byte bytes[length];
    for(int i=0;i<[hexString length]/2;i++)
    {
        int int_ch;// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i*2];
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;//// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        unichar hex_char2 = [hexString characterAtIndex:i*2 + 1];
        
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        NSLog(@"i----%d---%d",i,hex_char2);
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;
        ///将转化后的数放入Byte数组里
        j++;
    }
    return [[NSData alloc] initWithBytes:bytes length:length];
}

@end
