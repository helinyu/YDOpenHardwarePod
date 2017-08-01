//
//  YDThirdPardModel.m
//  YDOpenHardwareSimple
//
//  Created by 张旻可 on 16/6/29.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDThirdPardModel.h"

@implementation YDThirdPardModel

+ (NSDictionary *)jsonKeyPathsByPropertyKey {
    return @{};
}

+ (NSDictionary *)jsonValueConverter {
    return @{
             @"ctime": (NSDate *)^(NSDate *time) {
                 return time;
             },
             @"uptime": (NSDate *)^(NSDate *time) {
                 return time;
             }
             };
}

@end
