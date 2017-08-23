//
//  YDBundle.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDBundle : NSBundle

+ (NSString *)bundlePath:(NSString *)wholeFileName;
+ (NSString *)bundlePath:(NSString *)fileName type:(NSString *)type;


@end
