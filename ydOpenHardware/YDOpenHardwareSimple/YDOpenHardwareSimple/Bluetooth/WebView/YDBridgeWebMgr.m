//
//  YDBridgeWebMgr.m
//  SportsBar
//
//  Created by 张旻可 on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YDBridgeWebMgr.h"
#import <WebKit/WebKit.h>
#import "YDBridgeWebViewController.h"
#import <WebViewJavascriptBridge.h>
#import <WKWebViewJavascriptBridge.h>
#import "YDBridgeWebView.h"
#import <NJKWebViewProgress.h>

#import "YDBluetoothWebViewMgr.h"


@interface YDBridgeWebMgr () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak, readwrite) UIViewController *currentController;
@property (nonatomic, weak) YDBridgeWebViewController *currentWebController;

@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic,copy) NSString *shareIconUrl;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,strong) NSDictionary *shareDic;

@end

@implementation YDBridgeWebMgr

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)shared {
    static YDBridgeWebMgr *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8) {
            singleton.processPool = [[WKProcessPool alloc] init];
        }
        
    });
    return singleton;
}

+ (instancetype)webMgrWithController:(UIViewController *)controller {
    YDBridgeWebMgr* mgr = [[self alloc] init];
    mgr.currentController = controller;
    if ([controller isKindOfClass:[YDBridgeWebViewController class]]) {
        mgr.currentWebController = (YDBridgeWebViewController *)controller;
    }
    return mgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setCurrentViewController:(UIViewController *)viewController {
    self.currentController = viewController;
    if ([viewController isKindOfClass:[YDBridgeWebViewController class]]) {
        self.currentWebController = (YDBridgeWebViewController *)viewController;
    }
}

- (void)solveBridgeWithWebView:(YDBridgeWebView *)webView {
    self.bridge = [WebViewJavascriptBridge bridge:webView.webView];
    [self.bridge setWebViewDelegate:webView];

    [self deliverBridge];
    [self registerBridgeHandler];
}

- (void)solveBridgeDelegate:(YDBridgeWebView *)webView {
    if (webView.oldWebView) {
        webView.progressProxy.webViewProxyDelegate = self.bridge;
    }
}

- (void)deliverBridge {
    [YDBluetoothWebViewMgr shared].webViewBridge = self.bridge;
}

- (void)registerBridgeHandler {
    [self.bridge registerHandler:@"yd.log" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@", data);
    }];
    
    switch (self.viewType) {
        case YDWebViewTypeInner:
            
            break;
        case YDWebViewTypeOuter:
            
            break;
        case YDWebViewTypeS3:
        {
            [[YDBluetoothWebViewMgr shared] registerHandlers];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- action by VC

- (void)onActionByViewDidDisappear {
    
    switch (self.viewType) {
        case YDWebViewTypeS3:
        {
            [[YDBluetoothWebViewMgr shared] onActionByViewDidDisappear];
        }
            break;
            
        default:
            break;
    }
    

    
    
}

@end
