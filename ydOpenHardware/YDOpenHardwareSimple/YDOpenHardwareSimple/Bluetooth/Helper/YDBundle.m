//
//  YDBundle.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBundle.h"

@implementation YDBundle

+ (NSString *)bundlePath:(NSString *)wholeFileName {
    return [[NSBundle mainBundle] pathForResource:wholeFileName ofType:nil];
}

+ (NSString *)bundlePath:(NSString *)fileName type:(NSString *)type {
    return [[NSBundle mainBundle] pathForResource:fileName ofType:type];
}

@end
