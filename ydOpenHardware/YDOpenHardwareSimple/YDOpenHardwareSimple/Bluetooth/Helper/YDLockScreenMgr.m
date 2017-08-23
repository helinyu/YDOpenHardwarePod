//
//  YDLockScreenMgr.m
//  TestAudio
//
//  Created by Aka on 2017/8/23.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "YDLockScreenMgr.h"
#import <notify.h>

@implementation YDLockScreenMgr

+ (void)addObserverLockAndLightScreenBlock:(void(^)(BOOL lockAndLightScreen))lockAndScreenBlock {
    uint64_t locked;
    __block int token = 0;
    notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
        NSLog(@"noitify lock state");
    });
    notify_get_state(token, &locked);
    
    //监听屏幕点亮状态 screenLight = 1则为变暗关闭状态
    uint64_t screenLight;
    __block int lightToken = 0;
    notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&lightToken,dispatch_get_main_queue(),^(int t){
        NSLog(@"lock the state");
    });
    notify_get_state(lightToken, &screenLight);
    
    BOOL isLockAndLightScreen = NO;
    if (screenLight == 0 && locked == 1) {
        //点亮且锁屏时
        isLockAndLightScreen = YES;
    }
    !lockAndScreenBlock?:lockAndScreenBlock(isLockAndLightScreen);
}

@end
