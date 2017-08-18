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

@implementation CBCharacteristic (YYModel)

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (!self.UUID && !self.properties && !self.value) return NO;
    dic[@"uuid"] = self.UUID.UUIDString;
    dic[@"properties"] = [NSString stringWithFormat:@"%lu",(unsigned long)self.properties];
    Byte *bytes = (Byte *)[self.value bytes];
    NSMutableString *mString = @"".mutableCopy;
    for (int i = 0; i < self.value.length; i++) {
        [mString appendString:[NSString stringWithFormat:@"%0x02",bytes[i]]];
    }
    dic[@"value"] = mString;
    return YES;
}

- (NSDictionary *)convertToDictionary {
    NSMutableDictionary * jsonObj = @{}.mutableCopy;
    [jsonObj setObject:self.UUID.UUIDString forKey:@"uuid"];
    [jsonObj setObject:[NSString stringWithFormat:@"%d",self.isNotifying] forKeyedSubscript:@"isNotifying"];
    [jsonObj setObject:[NSString stringWithFormat:@"%0lx",(unsigned long)self.properties] forKey:@"properties"];
    if (self.value) {
        Byte *bytes = (Byte *)[self.value bytes];
        NSMutableString *mString = @"".mutableCopy;
        for (int i = 0; i < self.value.length; i++) {
            [mString appendString:[NSString stringWithFormat:@"%0x02",bytes[i]]];
        }
        [jsonObj setObject:mString forKey:@"value"];
    }
    return jsonObj;
}

@end
