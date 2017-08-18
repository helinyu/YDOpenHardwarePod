//
//  NSString+YDContainsString.m
//  SportsBar
//
//  Created by 张旻可 on 2016/12/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation NSString (YDContainsString)

- (BOOL)containsString:(NSString *)str {
    return [self rangeOfString:str].length > 0;
}

@end
