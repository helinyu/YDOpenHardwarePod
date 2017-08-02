//
//  YDBluetoothWebViewMgr.h
//  SportsBar
//
//  Created by Aka on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebViewJavascriptBridge;

@interface YDS3WebViewMgr :NSObject

@property (nonatomic, strong) WebViewJavascriptBridge *webViewBridge;

+ (instancetype)shared;

- (void)scanPeripheralWithMatchWord:(NSString *)matchWord;

- (void)startScanThenSourcesCallback:(void(^)(NSArray *peirpherals))callback;

- (void)registerHandlers;


- (void)onActionByViewDidDisappear;

@end
