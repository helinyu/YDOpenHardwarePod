//
//  YDBridgeWebMgr.h
//  SportsBar
//
//  Created by 张旻可 on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDBluetoohWebDefine.h"

@class WKProcessPool;
@class WebViewJavascriptBridge;
@class YDBridgeWebView;

@interface YDBridgeWebMgr : NSObject

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) WKProcessPool *processPool;
@property (nonatomic, assign) YDWebViewType viewType;
@property (nonatomic, assign) NSUInteger bluetoothBusinessType;
@property (nonatomic, copy) NSString *currentURLString;
@property (nonatomic, copy) NSString *currentTitle;

@property (nonatomic, weak, readonly) UIViewController *currentController;

@property (nonatomic, assign) BOOL notFirstTrigger;

+ (instancetype)shared;
+ (instancetype)webMgrWithController:(UIViewController *)controller;


- (void)setCurrentViewController:(UIViewController *)viewController;

- (void)solveBridgeWithWebView:(YDBridgeWebView *)webView;
- (void)solveBridgeDelegate:(YDBridgeWebView *)webView;

- (void)onActionByViewDidDisappear;

@end
