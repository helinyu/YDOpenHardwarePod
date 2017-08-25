//
//  YDBridgeWebMgr+YDAudio.m
//  _YDBridgeWebViewController
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBridgeWebMgr+YDAudio.h"
#import "WebViewJavascriptBridge.h"
#import "YYModel.h"
#import "YDAudioVideo.h"
#import "YDAudioVideoMgr.h"
#import "YDBackgroundMediaMgr.h"
#import <AVFoundation/AVFoundation.h>
#import "YDBgMediaMgr.h"

@implementation YDBridgeWebMgr (YDAudio)

//额外的开头 registerWebBridgeNomalExtension…… 固定模式

- (void)registerWebBridgeNomalExtensionAudioAndViedoHandlers {
    __weak typeof (self) wSelf = self;
    //    多首
    [self.bridge registerHandler:@"onAudioAndVideoInfos" handler:^(id data, WVJBResponseCallback responseCallback) {
            [wSelf onAudioAndVideoInfos:data];
    }];

    //    单首
    [self.bridge registerHandler:@"onAudioOrVideoBackgroundWithInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf _onAudioOrVideoBackGroundWithInfo:data];
    }];

}

- (void)_onAudioOrVideoBackGroundWithInfo:(id)info {
    if (![info isKindOfClass:[NSDictionary class]]) {
        NSLog(@"输入的数据格式不正确");
        return ;
    }
    [self _playOnBackgroundModeWithInfo:info];
}

- (void)_playOnBackgroundModeWithInfo:(NSDictionary *)info {
    YDAudioVideo *audio = [YDAudioVideo yy_modelWithDictionary:info];
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"多幸运" ofType:@"txt"];
//    audio.lyric =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    YDBackgroundMediaMgr *mgr = [YDBackgroundMediaMgr shared];
//    [mgr setLockPlayerInfo];
//    [mgr loadBaseWithAudioVideo:audio];
//    [mgr setLockPlayerInfo];
//    [mgr.player play];
//    [mgr playControl];
//    [mgr createRemoteCommandCenter];
//    [[YDBackgroundMediaMgr shared] setLockPlayerWithInfo:audio];
//    [[YDBackgroundMediaMgr shared] createRemoteCommandCenter];
    [[YDBgMediaMgr shared] setLockPlayerWithInfo:audio];
    [[YDBgMediaMgr shared] createRemoteCommandCenter];
    
}

- (void)onAudioAndVideoInfos:(id)infos {
    if (![infos isKindOfClass:[NSArray class]]) {
        NSLog(@"输入的格式不正确");
        return;
    }
}

@end
