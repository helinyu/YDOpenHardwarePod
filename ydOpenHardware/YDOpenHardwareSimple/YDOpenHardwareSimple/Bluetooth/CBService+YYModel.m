//
//  CBService+YYModel.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/11.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "CBService+YYModel.h"

@implementation CBService (YYModel)

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!self.UUID) return NO;
    dic[@"uuid"] = self.UUID.UUIDString;
    return YES;
}

@end
