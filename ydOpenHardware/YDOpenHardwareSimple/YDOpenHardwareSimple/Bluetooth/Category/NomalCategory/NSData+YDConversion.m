//
//  NSData+YDConversion.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/7.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "NSData+YDConversion.h"

@implementation NSData (YDConversion)

+ (NSData *)dataWithHexString:(NSString *)hexStr {
        hexStr = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        hexStr = [hexStr lowercaseString];
        NSUInteger len = hexStr.length;
        if (!len) return nil;
        unichar *buf = malloc(sizeof(unichar) * len);
        if (!buf) return nil;
        [hexStr getCharacters:buf range:NSMakeRange(0, len)];
        
        NSMutableData *result = [NSMutableData data];
        unsigned char bytes;
        char str[3] = { '\0', '\0', '\0' };
        int i;
        for (i = 0; i < len / 2; i++) {
            str[0] = buf[i * 2];
            str[1] = buf[i * 2 + 1];
            bytes = strtol(str, NULL, 16);
            [result appendBytes:&bytes length:1];
        }
        free(buf);
        return result;
}

@end
