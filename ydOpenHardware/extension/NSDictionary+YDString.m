//
//  NSDictionary+YDString.m
//  SportsBar
//
//  Created by Aka on 2017/7/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSDictionary+YDString.h"

@implementation NSDictionary (YDString)

- (NSString *)convertToString {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
