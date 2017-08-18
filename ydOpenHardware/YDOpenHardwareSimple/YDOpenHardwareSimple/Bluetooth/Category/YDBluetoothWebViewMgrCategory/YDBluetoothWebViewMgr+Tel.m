//
//  YDBluetoothWebViewMgr+Tel.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+Tel.h"
#import "WebViewJavascriptBridge.h"
#import "YDBlueToothMgr.h"
#import "YDBluetoothWebViewMgr+WriteDatas.h"

@implementation YDBluetoothWebViewMgr (Tel)

#pragma mark -- tel phone
- (void)initTelCallHandle {
    __weak typeof (self) wSelf = self;
    self.btMgr.callHandle = ^(BOOL handerFlag) {
        if (handerFlag) {
            [wSelf handlerTelWithState:YES];
        }else{
            NSLog(@"不是来电状态");
            [wSelf handlerTelWithState:NO];
        }
    };
}

- (void)handlerTelWithState:(BOOL)incommingflag{
    NSDictionary *params = @{@"flag":@(incommingflag)};
    [self.webViewBridge callHandler:@"onTelComming" data:params responseCallback:^(id responseData) {
        
    }];
}

- (void)registerTelHandle {
    __weak typeof (self) wSelf = self;
    
//    this is for testing register handle
    [self.webViewBridge registerHandler:@"onTelRemind" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf telRemind];
    }];
}

@end

