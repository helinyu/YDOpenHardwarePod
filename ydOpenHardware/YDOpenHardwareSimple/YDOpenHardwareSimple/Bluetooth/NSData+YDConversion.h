//
//  NSData+YDConversion.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/7.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YDConversion)

+ (NSData *)dataWithHexString:(NSString *)message;

@end
