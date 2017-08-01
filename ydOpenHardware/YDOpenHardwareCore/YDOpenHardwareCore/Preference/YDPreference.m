//
//  YDPreference.m
//  SportsBar
//
//  Created by 张旻可 on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YDPreference.h"
#import "YDAppInstance.h"

static YDPreference *singletonUser = nil;
static YDPreference *singletonApp = nil;

@interface YDPreference ()

@end

@implementation YDPreference

+ (instancetype)sharedUserPreference {
    NSNumber *curUserID = [YDAppInstance userId];
    if (curUserID.integerValue != singletonUser.userId.integerValue) {
        [singletonUser synchronize];
        singletonUser = nil;
    }
    if (singletonUser == nil) {
        singletonUser = [[self alloc] initWithSuiteName: @"default" user: [YDAppInstance userId]];
    }
    return singletonUser;
}
+ (instancetype)sharedAppPreference {
    if (singletonApp == nil) {
        singletonApp = [[self alloc] initWithSuiteName: @"app.default" user: nil];
    }
    return singletonApp;
}

- (instancetype)initWithSuiteName:(NSString *)suitename user: (NSNumber *)uid {
    if (uid == nil) {
        self = [super initWithSuiteName: [NSString stringWithFormat:@"yd.preference.%@", suitename]];
    } else {
        self = [super initWithSuiteName: [NSString stringWithFormat:@"yd.preference.%@.%@", suitename, uid]];
    }
    
    if (self) {
        _userId = uid;
    }
    return self;
}

+ (instancetype)preferenceWithSuitName: (NSString *)sn user: (NSNumber *)uid {
    YDPreference *p = [[self alloc] initWithSuiteName: sn user: uid];
    return p;
}

@end
