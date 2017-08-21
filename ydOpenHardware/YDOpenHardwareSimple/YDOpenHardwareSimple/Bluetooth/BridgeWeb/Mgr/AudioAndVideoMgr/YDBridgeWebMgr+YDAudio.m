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
#import <AVFoundation/AVFoundation.h>

@implementation YDBridgeWebMgr (YDAudio)

//额外的开头 registerWebBridgeNomalExtension…… 固定模式

- (void)registerWebBridgeNomalExtensionAudioAndViedoHandlers {
    __weak typeof (self) wSelf = self;
    //    单首
    [self.bridge registerHandler:@"onAudioAndVideoInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf onAudioAndVideoInfo:data];
    }];
    
    //    多首
    [self.bridge registerHandler:@"onAudioAndVideoInfos" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf onAudioAndVideoInfos:data];
    }];
    
}

//info
- (void)onAudioAndVideoInfo:(id)info {
    if (![info isKindOfClass:[NSDictionary class]]) {
        NSLog(@"输入的数据格式不正确");
        return ;
    }
    [self _playOnBackgroundModeWithInfo:info];
}

- (void)_playOnBackgroundModeWithInfo:(NSDictionary *)info {
    YDAudioVideo *audio = [YDAudioVideo yy_modelWithDictionary:info];
    [[YDAudioVideoMgr shared] playEnableBgModelWithAudio:audio];
}

- (void)onAudioAndVideoInfos:(id)infos {
    if (![infos isKindOfClass:[NSArray class]]) {
        NSLog(@"输入的格式不正确");
        return;
    }
}

@end
