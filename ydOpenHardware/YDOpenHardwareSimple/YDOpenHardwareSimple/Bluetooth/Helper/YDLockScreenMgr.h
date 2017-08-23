//
//  YDLockScreenMgr.h
//  TestAudio
//
//  Created by Aka on 2017/8/23.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDLockScreenMgr : NSObject

+ (void)addObserverLockAndLightScreenBlock:(void(^)(BOOL lockAndLightScreen))lockAndScreenBlock;

@end
