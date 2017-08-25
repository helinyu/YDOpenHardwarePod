//
//  YDBgMediaMgr.h
//  SportsBar
//
//  Created by Aka on 2017/8/24.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YDMedia;

@interface YDBgMediaMgr : NSObject

+ (instancetype)shared;

- (void)createRemoteCommandCenter;
- (void)setLockPlayerWithInfo:(YDMedia *)media;

@end
