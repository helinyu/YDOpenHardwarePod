
//
//  YDBluetoothWebViewMgr+YDAudioVideo.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+YDAudioVideo.h"
#import "WebViewJavascriptBridge.h"

@implementation YDBluetoothWebViewMgr (YDAudioVideo)

- (void)registerAudioAndViedoHandlers {
    __weak typeof (self) wSelf = self;
    [self.webViewBridge registerHandler:@"onTelRemind" handler:^(id data, WVJBResponseCallback responseCallback) {
        
    }];}

@end
