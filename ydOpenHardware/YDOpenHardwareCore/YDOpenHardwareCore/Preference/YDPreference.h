//
//  YDPreference.h
//  SportsBar
//
//  Created by 张旻可 on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPreference : NSUserDefaults

@property (nonatomic, strong, readonly) NSNumber *userId;

+ (instancetype)sharedUserPreference;
+ (instancetype)sharedAppPreference;
+ (instancetype)preferenceWithSuitName: (NSString *)sn user: (NSNumber *)uid;

- (instancetype)initWithSuiteName:(NSString *)suitename user: (NSNumber *)uid;

@end
