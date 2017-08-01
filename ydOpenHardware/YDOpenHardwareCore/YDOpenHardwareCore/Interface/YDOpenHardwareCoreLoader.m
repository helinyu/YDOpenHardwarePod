//
//  YDOpenHardwareCoreLoader.m
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/2/14.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDOpenHardwareCoreLoader.h"
#import "YDOpenHardwareCore.h"

@implementation YDOpenHardwareCoreLoader


+ (void)load {
    [YDOpenHardwareMgr class];
    [YDOpenHardwareDP class];
}

@end
