//
//  YDBridgeWebView.m
//  SportsBar
//
//  Created by 张旻可 on 2017/7/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YDBridgeWebView.h"

#import "YDMBaseViewController.h"
#import "YDBridgeWebViewController.h"

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "MJRefresh.h"
#import "YDWebNoNetworkView.h"
#import "YDBridgeWebMgr.h"
#import "Reachability.h"
#import "WebViewJavascriptBridge.h"
#import "Masonry.h"


static CGFloat kProgressHeaderH = 2.f;

@interface YDBridgeWebView () <UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate, NJKWebViewProgressDelegate, WKScriptMessageHandler>

@property (nonatomic, strong, readwrite) id webView;
@property (nonatomic, weak, readwrite) UIWebView *oldWebView;
@property (nonatomic, weak, readwrite) WKWebView *freshWebView;
@property (nonatomic, strong, readwrite) YDWebNoNetworkView *noNetworkView;
@property (nonatomic, weak, readwrite) YDBridgeWebMgr *webMgr;
@property (nonatomic, strong, readwrite) YDBridgeWebMgr *sWebMgr;

@property (nonatomic,strong) NSURLRequest *originRequest;
@property (nonatomic,strong) NSURLRequest *currentRequest;

@property (nonatomic, readwrite, assign) double estimatedProgress;
@property (nonatomic, readwrite, copy) NSString *title;

@property (nonatomic, readonly, copy) NSString *userAgent;

@property (nonatomic, strong, readwrite) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@property (nonatomic, assign) BOOL useWK;
@property (nonatomic, assign) BOOL isBackForward;
@property (nonatomic, assign) BOOL notFirstLoad;

@end

@implementation YDBridgeWebView

+ (instancetype)instanceWithType:(YDWebViewType)type urlString:(NSString *)urlString webMgr:(YDBridgeWebMgr *)webMgr {
    if (type == YDWebViewTypeInner) {
        return [[self alloc] initWithUrl:urlString andType:type webMgr:webMgr];
    } else {
        return [[self alloc] initWithUrl:urlString andType:type webMgr:webMgr];
    }
}

- (instancetype)initWithUrl:(NSString *)urlString andType:(YDWebViewType)type webMgr:(YDBridgeWebMgr *)webMgr {
    self = [super init];
    if (self) {
        _urlString = urlString;
        _type = type;
        if (webMgr) {
            _webMgr = webMgr;
        } else {
            _sWebMgr = [YDBridgeWebMgr webMgrWithController:self.currentViewController];
            _webMgr = _sWebMgr;
        }
//        __weak typeof(self) wSelf = self;
//        webMgr.URLDeliveryCallback = ^(YDURLDelivery *URLDelivery) {
//            [wSelf solveURLDelivery:URLDelivery then:nil];
//        };
//        webMgr.URLDeliveryCallbackAndBack = ^(YDURLDelivery *URLDelivery, void (^then)(YDURLDelivery *backURLDelivery)) {
//            [wSelf solveURLDelivery:URLDelivery then:then];
//        };
//        if (BEFORE_IOS8 || ![YDAppInstance UMOnlineConfig].useWKWebView.integerValue) {
//            _useWK = NO;
//        } else {
//            _useWK = YES;
//        }
        _useWK = NO;
        [self comInit];
    }
    return self;
}

- (id)webView {
    if (!_webView) {
        if (!self.useWK) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [self uiwebview_config];
            [self uiwebview_delegate];
            
        } else {
            WKWebViewConfiguration *config = [self wkwebview_config];
            _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
            [self wkwebview_delegate];
        }
        [self addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(self.topEdge);
        }];
        self.scrollView.delaysContentTouches = NO;
        self.originalUrlString = self.urlString;
//        self.urlString = [self.webMgr solveYDURLString:self.urlString];
        if ([self.urlString hasPrefix:@"http"]) {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            [self loadRequest:request];
        }else{
            [self loadWithBundleFile:self.urlString];
        }
         [self webview_refresh];
    }
    return _webView;
}

- (UIWebView *)oldWebView {
    if (!self.useWK) {
        if (!_oldWebView) {
            _oldWebView = _webView;
        }
        return _oldWebView;
    }
    return nil;
}
- (WKWebView *)freshWebView {
    if (self.useWK) {
        if (!_freshWebView) {
            _freshWebView = _webView;
        }
        return _freshWebView;
    }
    return nil;
}
- (void)noNetworkViewInit {
    self.noNetworkView = [[YDWebNoNetworkView alloc] initWithFrame:SCREEN_BOUNDS];
    [self addSubview:self.noNetworkView];
    [self.noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.noNetworkView.hidden = YES;
    __weak typeof(self) wSelf = self;
    self.noNetworkView.actionRefresh = ^{
        wSelf.noNetworkView.hidden = YES;
        [wSelf reload];
    };
}
- (void)comInit {
    [self webView];
    [self noNetworkViewInit];
}

- (void)bind {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

#pragma mark -- notification
- (void)networkStatusChange:(NSNotification *)notification {
//    [self evaluateJavaScript:[NSString stringWithFormat:WEB_NETWORK_STATUS_CHANGE_FUNC, @([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus)] completionHandler:^(id result, NSError *error) {
//        
//    }];
//    
}

#pragma mark -- webview config
- (void)uiwebview_config {
    self.scalesPageToFit = NO;
    self.allowsInlineMediaPlayback = YES;
    self.scrollView.delaysContentTouches = NO;
    self.allowsInlineMediaPlayback = YES;
    self.allowsPictureInPictureMediaPlayback = YES;
    self.mediaPlaybackRequiresUserAction = YES;
    self.mediaPlaybackAllowsAirPlay = YES;
    self.suppressesIncrementalRendering = NO;
    self.keyboardDisplayRequiresUserAction = YES;
    self.oldWebView.backgroundColor = YD_WHITE(1);
    self.oldWebView.scrollView.backgroundColor = YD_WHITE(1);
}
- (WKWebViewConfiguration *)wkwebview_config {
    WKWebViewConfiguration  *config = [[WKWebViewConfiguration alloc] init];
    config.processPool = [YDBridgeWebMgr shared].processPool;
    //    config.userContentController = [self wkwebview_userConfig];
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.allowsInlineMediaPlayback = YES;
    if (!(BEFORE_IOS9)) {
        config.allowsPictureInPictureMediaPlayback = YES;
    }
    if (BEFORE_IOS9) {
        config.mediaPlaybackRequiresUserAction = YES;
    } else if (BEFORE_IOS10) {
        config.requiresUserActionForMediaPlayback = YES;
    } else {
        config.mediaTypesRequiringUserActionForPlayback = YES;
    }
    if (BEFORE_IOS9) {
        config.mediaPlaybackAllowsAirPlay = YES;
    } else {
        config.allowsAirPlayForMediaPlayback = YES;
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    }
    config.suppressesIncrementalRendering = NO;
    return config;
}
- (WKUserContentController *)wkwebview_userConfig {
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //    NSMutableString *script = @"".mutableCopy;
    //    // Get the currently set cookie names in javascriptland
    //    [script appendString:@"var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"];
    //
    //    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
    //        // Skip cookies that will break our script yd_javascriptString已处理
    ////        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
    ////            continue;
    ////        }
    //
    //        // Create a line that appends this cookie to the web view's document's cookies
    //        [script appendFormat:@"if (cookieNames.indexOf('%@') == -1) { document.cookie='%@'; };\n", cookie.name, cookie.yd_javascriptString];
    //    }
    //    WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:script
    //                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
    //                                                       forMainFrameOnly:NO];
    //    [userContentController addUserScript:cookieInScript];
    
    //    WKUserScript *cookieOutScript = [[WKUserScript alloc] initWithSource:@"window.webkit.messageHandlers.updateCookies.postMessage(document.cookie);"
    //                                                           injectionTime:WKUserScriptInjectionTimeAtDocumentStart
    //                                                        forMainFrameOnly:NO];
    //    [userContentController addUserScript:cookieOutScript];
    
    //    [userContentController addScriptMessageHandler:self
    //                                              name:@"updateCookies"];
    
    return userContentController;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSArray<NSString *> *cookies = [message.body componentsSeparatedByString:@"; "];
    for (NSString *cookie in cookies) {
        // Get this cookie's name and value
        NSArray<NSString *> *comps = [cookie componentsSeparatedByString:@"="];
        if (comps.count < 2) {
            continue;
        }
        
        // Get the cookie in shared storage with that name
        NSHTTPCookie *localCookie = nil;
        NSArray *sharedCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", message.webView.URL.scheme, message.webView.URL.host]]]; //
        for (NSHTTPCookie *c in sharedCookies) {
            if ([c.name isEqualToString:comps[0]]) {
                localCookie = c;
                break;
            }
        }
        
        // If there is a cookie with a stale value, update it now.
        NSDate *localeDate = [NSDate date];
        if (localCookie) {
            NSMutableDictionary *props = [localCookie.properties mutableCopy];
            props[NSHTTPCookieValue] = comps[1];
            NSHTTPCookie *updatedCookie = [NSHTTPCookie cookieWithProperties:props];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:updatedCookie];
        } else {
            NSHTTPCookie *addCookie = [NSHTTPCookie cookieWithProperties:
                                       [NSDictionary dictionaryWithObjectsAndKeys:
                                        message.webView.URL.host, NSHTTPCookieDomain,//
                                        @"/", NSHTTPCookiePath,
                                        [localeDate dateByAddingTimeInterval:(60*60*24)], NSHTTPCookieExpires,
                                        comps[0],  NSHTTPCookieName,
                                        comps[1], NSHTTPCookieValue,
                                        nil]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:addCookie];
        }
    }
}

- (void)uiwebview_delegate {
    self.webMgr.viewType = self.type;
    [self.webMgr solveBridgeWithWebView:self];
}
- (void)wkwebview_delegate {
    self.freshWebView.UIDelegate = self;
    self.webMgr.viewType = self.type;
    [self.webMgr solveBridgeWithWebView:self];
    
    [self.freshWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.freshWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)webview_refresh {
    __weak typeof(self) wSelf = self;
    MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (wSelf.isLoading) {
            return;
        }
        [wSelf reload];
        [wSelf.scrollView.mj_header endRefreshing];
    }];
    
    [header setTitle:@"" forState:MJRefreshStateIdle];
    [header setTitle:@"" forState:MJRefreshStatePulling];
    [header setTitle:@"" forState:MJRefreshStateRefreshing];
    [header setTitle:@"" forState:MJRefreshStateWillRefresh];
    [header setTitle:@"" forState:MJRefreshStateNoMoreData];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.lastUpdatedTimeText = ^(NSDate *lastUpdatedTime) {
        return @"";
    };
    self.scrollView.mj_header = header;
}


#pragma mark -- 继承webview的方法

- (WKWebViewConfiguration *)configuration {
    if (!self.useWK) {
        return nil;
    } else {
        return self.freshWebView.configuration;
    }
}
- (id <WKNavigationDelegate>)navigationDelegate {
    if (!self.useWK) {
        return nil;
    } else {
        return self.freshWebView.navigationDelegate;
    }
}
- (void)setNavigationDelegate:(id<WKNavigationDelegate>)navigationDelegate {
    if (!self.useWK) {
    } else {
        return [self.freshWebView setNavigationDelegate:navigationDelegate];
    }
}
- (id <WKUIDelegate>)UIDelegate {
    if (!self.useWK) {
        return nil;
    } else {
        return self.freshWebView.UIDelegate;
    }
}
- (void)setUIDelegate:(id<WKUIDelegate>)UIDelegate {
    if (!self.useWK) {
    } else {
        return [self.freshWebView setUIDelegate:UIDelegate];
    }
}
- (WKBackForwardList *)backForwardList {
    if (!self.useWK) {
        return nil;
    } else {
        return self.freshWebView.backForwardList;
    }
}

- (WKNavigation *)loadWithBundleFile:(NSString *)file {
    self.webMgr.notFirstTrigger = NO;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [[NSBundle mainBundle] bundleURL];
    if (!self.useWK) {
        [self.oldWebView loadHTMLString:htmlString baseURL:baseUrl];
        return nil;
    }else{
        return [self.freshWebView loadHTMLString:htmlString baseURL:nil];
    }
}

- (WKNavigation *)loadRequest:(NSURLRequest *)request {
    self.webMgr.notFirstTrigger = NO;
    if (!self.useWK) {
        [self.oldWebView loadRequest:request];
        return nil;
    } else {
        return [self.freshWebView loadRequest:request];
    }
}

- (WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL {
    self.webMgr.notFirstTrigger = NO;
    if (BEFORE_IOS9) {
        return nil;
    } else {
        return [self.freshWebView loadFileURL:URL allowingReadAccessToURL:readAccessURL];
    }
}// API_AVAILABLE(macosx(10.11), ios(9.0));

- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    self.webMgr.notFirstTrigger = NO;
    if (!self.useWK) {
        [self.oldWebView loadHTMLString:string baseURL:baseURL];
        return nil;
    } else {
        return [self.freshWebView loadHTMLString:string baseURL:baseURL];
    }
}
- (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
    self.webMgr.notFirstTrigger = NO;
    if (BEFORE_IOS9) {
        return nil;
    } else {
        return [self.freshWebView loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
    }
}// API_AVAILABLE(macosx(10.11), ios(9.0));
- (WKNavigation *)goToBackForwardListItem:(WKBackForwardListItem *)item {
    self.webMgr.notFirstTrigger = NO;
    if (!self.useWK) {
        return nil;
    } else {
        return [self.freshWebView goToBackForwardListItem:item];
    }
}

//- (NSString *)title {
//    if (BEFORE_IOS8) {
//        return nil;
//    } else {
//        return self.freshWebView.title;
//    }
//}
- (NSURL *)URL {
    if (!self.useWK) {
        return self.oldWebView.request.URL;
    } else {
        return self.freshWebView.URL;
    }
}

- (BOOL)isLoading {
    if (!self.useWK) {
        return self.oldWebView.isLoading;
    } else {
        return self.freshWebView.isLoading;
    }
}
//- (double)estimatedProgress {
//    if (BEFORE_IOS8) {
//        return 0;
//    } else {
//        return self.freshWebView.estimatedProgress;
//    }
//}
- (BOOL)hasOnlySecureContent {
    if (!self.useWK) {
        return NO;
    } else {
        return self.freshWebView.hasOnlySecureContent;
    }
}
- (SecTrustRef)serverTrust {
    if (BEFORE_IOS10) {
        return nil;
    } else {
        return self.freshWebView.serverTrust;
    }
}
- (BOOL)canGoBack {
    if (!self.useWK) {
        return self.oldWebView.canGoBack;
    } else {
        return self.freshWebView.canGoBack;
    }
}
- (BOOL)canGoForward {
    if (!self.useWK) {
        return self.oldWebView.canGoForward;
    } else {
        return self.freshWebView.canGoForward;
    }
}
- (WKNavigation *)goBack {
    self.webMgr.notFirstTrigger = NO;
    if (!self.useWK) {
        [self.oldWebView goBack];
        return nil;
    } else {
        return [self.freshWebView goBack];
    }
}
- (WKNavigation *)goForward {
    self.webMgr.notFirstTrigger = NO;
    if (!self.useWK) {
        [self.oldWebView goForward];
        return nil;
    } else {
        return [self.freshWebView goForward];
    }
}
- (WKNavigation *)reload {
    self.webMgr.notFirstTrigger = NO;
    if (!self.useWK) {
        if (![self.urlString hasPrefix:@"http"]) {
            [self loadWithBundleFile:self.urlString];
            return nil;
        }
        [self.oldWebView reload];
        return nil;
    } else {
        return [self.freshWebView reload];
    }
}
- (WKNavigation *)reloadFromOrigin {
    self.webMgr.notFirstTrigger = NO;
    if (!self.useWK) {
        return nil;
    } else {
        return [self.freshWebView reloadFromOrigin];
    }
}
- (void)stopLoading {
    if (!self.useWK) {
        [self.oldWebView stopLoading];
    } else {
        return [self.freshWebView stopLoading];
    }
}
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id result, NSError *error))completionHandler {
    if (!self.useWK) {
        NSString *result = [self.oldWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        !completionHandler?:completionHandler(result, nil);
    } else {
        return [self.freshWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    }
}
- (BOOL)allowsBackForwardNavigationGestures {
    if (!self.useWK) {
        return NO;
    } else {
        return [self.freshWebView allowsBackForwardNavigationGestures];
    }
}
- (void)setAllowsBackForwardNavigationGestures:(BOOL)allowsBackForwardNavigationGestures {
    if (!self.useWK) {
    } else {
        if (!(BEFORE_IOS9)) {
            return [self.freshWebView setAllowsBackForwardNavigationGestures:allowsBackForwardNavigationGestures];
        }
        
    }
}
- (NSString *)customUserAgent {
    if (!self.useWK) {
        [self.oldWebView stringByEvaluatingJavaScriptFromString:@"window.navigator.userAgent"];
        return nil;
    } else {
        return [self.freshWebView customUserAgent];
    }
}
- (void)setCustomUserAgent:(NSString *)customUserAgent {
    if (!self.useWK) {
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    } else {
        return [self.freshWebView setCustomUserAgent:customUserAgent];
    }
}
- (BOOL)allowsLinkPreview {
    if (BEFORE_IOS9) {
        return NO;
    } else {
        if (!self.useWK) {
            return [self.oldWebView allowsLinkPreview];
        } else {
            return [self.freshWebView allowsLinkPreview];
        }
    }
}
- (void)setAllowsLinkPreview:(BOOL)allowsLinkPreview {
    if (BEFORE_IOS9) {
    } else {
        if (!self.useWK) {
            return [self.oldWebView setAllowsLinkPreview:allowsLinkPreview];
        } else {
            return [self.freshWebView setAllowsLinkPreview:allowsLinkPreview];
        }
    }
}
- (UIScrollView *)scrollView {
    if (!self.useWK) {
        return [self.oldWebView scrollView];
    } else {
        return [self.freshWebView scrollView];
    }
}

- (id <UIWebViewDelegate>)delegate {
    return self.oldWebView.delegate;
}
- (void)setDelegate:(id<UIWebViewDelegate>)delegate {
    [self.oldWebView setDelegate:delegate];
}
- (BOOL)scalesPageToFit {
    return self.oldWebView.scalesPageToFit;
}
- (void)setScalesPageToFit:(BOOL)scalesPageToFit {
    [self.oldWebView setScalesPageToFit:scalesPageToFit];
}
- (UIDataDetectorTypes)dataDetectorTypes {
    return self.oldWebView.dataDetectorTypes;
}
- (void)setDataDetectorTypes:(UIDataDetectorTypes)dataDetectorTypes {
    [self.oldWebView setDataDetectorTypes:dataDetectorTypes];
}
- (BOOL)allowsInlineMediaPlayback {
    return self.oldWebView.allowsInlineMediaPlayback;
}
- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback {
    [self.oldWebView setAllowsInlineMediaPlayback:allowsInlineMediaPlayback];
}
- (BOOL)mediaPlaybackRequiresUserAction {
    return self.oldWebView.mediaPlaybackRequiresUserAction;
}
- (void)setMediaPlaybackRequiresUserAction:(BOOL)mediaPlaybackRequiresUserAction {
    [self.oldWebView setMediaPlaybackRequiresUserAction:mediaPlaybackRequiresUserAction];
}
- (BOOL)mediaPlaybackAllowsAirPlay {
    return self.oldWebView.mediaPlaybackAllowsAirPlay;
}
- (void)setMediaPlaybackAllowsAirPlay:(BOOL)mediaPlaybackAllowsAirPlay {
    self.oldWebView.mediaPlaybackAllowsAirPlay = mediaPlaybackAllowsAirPlay;
}
- (BOOL)suppressesIncrementalRendering {
    return self.oldWebView.suppressesIncrementalRendering;
}
- (void)setSuppressesIncrementalRendering:(BOOL)suppressesIncrementalRendering {
    self.oldWebView.suppressesIncrementalRendering = suppressesIncrementalRendering;
}
- (BOOL)keyboardDisplayRequiresUserAction {
    return self.oldWebView.keyboardDisplayRequiresUserAction;
}
- (void)setKeyboardDisplayRequiresUserAction:(BOOL)keyboardDisplayRequiresUserAction {
    self.oldWebView.keyboardDisplayRequiresUserAction = keyboardDisplayRequiresUserAction;
}
- (UIWebPaginationMode)paginationMode {
    return self.paginationMode;
}
- (void)setPaginationMode:(UIWebPaginationMode)paginationMode {
    self.paginationMode = paginationMode;
}
- (UIWebPaginationBreakingMode)paginationBreakingMode {
    return self.paginationBreakingMode;
}
- (void)setPaginationBreakingMode:(UIWebPaginationBreakingMode)paginationBreakingMode {
    self.paginationBreakingMode = paginationBreakingMode;
}
- (CGFloat)pageLength {
    return self.oldWebView.pageLength;
}
- (void)setPageLength:(CGFloat)pageLength {
    self.oldWebView.pageLength = pageLength;
}
- (CGFloat)gapBetweenPages {
    return self.oldWebView.gapBetweenPages;
}
- (void)setGapBetweenPages:(CGFloat)gapBetweenPages {
    self.oldWebView.gapBetweenPages = gapBetweenPages;
}
- (NSUInteger)pageCount {
    return self.oldWebView.pageCount;
}
- (BOOL)allowsPictureInPictureMediaPlayback {
    if (BEFORE_IOS9) {
        return NO;
    } else {
        return self.oldWebView.allowsPictureInPictureMediaPlayback;
    }
}
- (void)setAllowsPictureInPictureMediaPlayback:(BOOL)allowsPictureInPictureMediaPlayback {
    if (BEFORE_IOS9) {
    } else {
        self.oldWebView.allowsPictureInPictureMediaPlayback = allowsPictureInPictureMediaPlayback;
    }
}

#pragma mark - webview progress
- (void)setShowProgress:(BOOL)showProgress {
    _showProgress = showProgress;
    if (showProgress) {
        [self progressInit];
    } else {
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.progressView removeFromSuperview];
    }
}
- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        self.oldWebView.delegate = self.progressProxy;
        [self.webMgr solveBridgeDelegate:self];
        self.progressProxy.progressDelegate = self;
    }
    return _progressProxy;
}

- (void)progressInit {
    if (!self.progressView) {
        self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.scrollView.contentInset.top, SCREEN_WIDTH_V0, kProgressHeaderH)];
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(self.topEdge);
            make.height.mas_equalTo(kProgressHeaderH);
        }];
        [self.progressView setProgress:0.f animated:NO];
        self.progressView.progressBarView.backgroundColor = YDC_G;
        
    }
    [self progressProxy];
}
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    self.estimatedProgress = progress;
    [self callback_webViewUpdateProgress:progress];
    [self.progressView setProgress:progress animated:YES];
}

- (void)updateProgressConstraints {
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.scrollView.contentInset.top);
    }];
}

//WkWebView的progress 回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.estimatedProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self callback_webViewUpdateProgress:self.estimatedProgress];
        [self.progressView setProgress:self.estimatedProgress animated:YES];
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = change[NSKeyValueChangeNewKey];
    }
}


#pragma mark -- delegate
#pragma mark -----------
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
    return resultBOOL;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self callback_webViewDidStartLoad];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(self.originRequest == nil) {
        self.originRequest = webView.request;
    }
    
    [self callback_webViewDidFinishLoad];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self callback_webViewDidFailLoadWithError:error];
}
#pragma mark -----------
/*! @abstract Creates a new web view.
 @param webView The web view invoking the delegate method.
 @param configuration The configuration to use when creating the new web
 view.
 @param navigationAction The navigation action causing the new web view to
 be created.
 @param windowFeatures Window features requested by the webpage.
 @result A new web view or nil.
 @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.
 
 If you do not implement this method, the web view will cancel the navigation.
 */
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//
//}

/*! @abstract Notifies your app that the DOM window object's close() method completed successfully.
 @param webView The web view invoking the delegate method.
 @discussion Your app should remove the web view from the view hierarchy and update
 the UI as needed, such as by closing the containing browser tab or window.
 */
- (void)webViewDidClose:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
}

/*! @abstract Displays a JavaScript alert panel.
 @param webView The web view invoking the delegate method.
 @param message The message to display.
 @param frame Information about the frame whose JavaScript initiated this
 call.
 @param completionHandler The completion handler to call after the alert
 panel has been dismissed.
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have a single OK button.
 
 If you do not implement this method, the web view will behave as if the user selected the OK button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (self.currentViewController.presentedViewController) {
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler(); }]];
    if (self.currentViewController)
        [self.currentViewController presentViewController:alertController animated:YES completion:^{}];
    else
        completionHandler();
}

/*! @abstract Displays a JavaScript confirm panel.
 @param webView The web view invoking the delegate method.
 @param message The message to display.
 @param frame Information about the frame whose JavaScript initiated this call.
 @param completionHandler The completion handler to call after the confirm
 panel has been dismissed. Pass YES if the user chose OK, NO if the user
 chose Cancel.
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have two buttons, such as OK and Cancel.
 
 If you do not implement this method, the web view will behave as if the user selected the Cancel button.
 */
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
//}

/*! @abstract Displays a JavaScript text input panel.
 @param webView The web view invoking the delegate method.
 @param message The message to display.
 @param defaultText The initial text to display in the text entry field.
 @param frame Information about the frame whose JavaScript initiated this call.
 @param completionHandler The completion handler to call after the text
 input panel has been dismissed. Pass the entered text if the user chose
 OK, otherwise nil.
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have two buttons, such as OK and Cancel, and a field in
 which to enter text.
 
 If you do not implement this method, the web view will behave as if the user selected the Cancel button.
 */
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
//
//}

/*! @abstract Allows your app to determine whether or not the given element should show a preview.
 @param webView The web view invoking the delegate method.
 @param elementInfo The elementInfo for the element the user has started touching.
 @discussion To disable previews entirely for the given element, return NO. Returning NO will prevent
 webView:previewingViewControllerForElement:defaultActions: and webView:commitPreviewingViewController:
 from being invoked.
 
 This method will only be invoked for elements that have default preview in WebKit, which is
 limited to links. In the future, it could be invoked for additional elements.
 */
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo API_AVAILABLE(ios(10.0)) {
    return NO;
}

/*! @abstract Allows your app to provide a custom view controller to show when the given element is peeked.
 @param webView The web view invoking the delegate method.
 @param elementInfo The elementInfo for the element the user is peeking.
 @param defaultActions An array of the actions that WebKit would use as previewActionItems for this element by
 default. These actions would be used if allowsLinkPreview is YES but these delegate methods have not been
 implemented, or if this delegate method returns nil.
 @discussion Returning a view controller will result in that view controller being displayed as a peek preview.
 To use the defaultActions, your app is responsible for returning whichever of those actions it wants in your
 view controller's implementation of -previewActionItems.
 
 Returning nil will result in WebKit's default preview behavior. webView:commitPreviewingViewController: will only be invoked
 if a non-nil view controller was returned.
 */
- (UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions API_AVAILABLE(ios(10.0)) {
    return nil;
}

/*! @abstract Allows your app to pop to the view controller it created.
 @param webView The web view invoking the delegate method.
 @param previewingViewController The view controller that is being popped.
 */
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController API_AVAILABLE(ios(10.0)) {
    
}
#pragma mark -----------
/*! @abstract Decides whether to allow or cancel a navigation.
 @param webView The web view invoking the delegate method.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(navigationAction.targetFrame == nil) {
        YDBridgeWebViewController *vc = [[YDBridgeWebViewController alloc] init];
        vc.urlString = navigationAction.request.URL.absoluteString;
        [self.currentViewController.navigationController pushViewController:vc animated:YES];
        !decisionHandler?:decisionHandler(WKNavigationActionPolicyCancel);
    } else if (!navigationAction.targetFrame.isMainFrame) {
//        YDURLDelivery *URLDelivery = [self.webMgr triggerOuterEventWithURLString:navigationAction.request.URL];
//        if (URLDelivery.shouldLoad) {
//            !decisionHandler?:decisionHandler(WKNavigationActionPolicyAllow);
//        } else {
//            !decisionHandler?:decisionHandler(WKNavigationActionPolicyCancel);
//        }
    } else {
        BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
        if (resultBOOL) {
            self.currentRequest = navigationAction.request;
            !decisionHandler?:decisionHandler(WKNavigationActionPolicyAllow);
        } else {
            !decisionHandler?:decisionHandler(WKNavigationActionPolicyCancel);
        }
    }
}

/*! @abstract Decides whether to allow or cancel a navigation after its
 response is known.
 @param webView The web view invoking the delegate method.
 @param navigationResponse Descriptive information about the navigation
 response.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
 @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
 */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
//        self.webMgr.helper.setCookie = [((NSHTTPURLResponse *)(navigationResponse.response)).allHeaderFields objectForKey:@"Set-Cookie"];
//    }
//    !decisionHandler?:decisionHandler(WKNavigationResponsePolicyAllow);
//}

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self callback_webViewDidStartLoad];
}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"request header: %@", self.currentRequest.allHTTPHeaderFields);
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"wkwebview error: %@", error);
    [self callback_webViewDidFailLoadWithError:error];
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self callback_webViewDidFinishLoad];
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"wkwebview error:%@", error);
    //    [self callback_webViewDidFailLoadWithError:error];
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler {
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

/*! @abstract Invoked when the web view's web content process is terminated.
 @param webView The web view whose underlying web content process was terminated.
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    [webView reload];
}

#pragma mark- CALLBACK  Delegate

- (void)callback_webViewDidFinishLoad {
    if (!self.isLoading) {
        [self.scrollView.mj_header endRefreshing];
    }
    
    self.notFirstLoad = YES;
    self.webMgr.notFirstTrigger = YES;
    //    [self evaluateJavaScript:@"document.cookie" completionHandler:^(id result, NSError *error) {
    //        MSLogD(@"cookie:%@", result);
    //    }];
    if (self.isBackForward) {
        for (NSInteger i = 0; i < self.freshWebView.subviews.count; i++) {
            UIView *view = self.freshWebView.subviews[i];
            if (![view isKindOfClass:[UIScrollView class]]) {
                view.hidden = YES;
            }
        }
        [self evaluateJavaScript:@"if ('viewWillAppear' in window) { viewWillAppear(); }" completionHandler:^(id result, NSError *error) {
            
        }];
        [self evaluateJavaScript:@"if ('viewDidAppear' in window) { viewDidAppear(); }" completionHandler:^(id result, NSError *error) {
            
        }];
    }
    self.webMgr.currentTitle = self.title;
    if (self.useWK) {
        if (self.freshWebView.canGoBack && [self.currentViewController isKindOfClass:[YDBridgeWebViewController class]]) {
//            if (self.freshWebView.canGoBack && ![[MSUtil noParamsURLStringFromURLString:self.originalUrlString] isEqualToString:[MSUtil noParamsURLStringFromURLString:self.urlString]] && [self.currentViewController isKindOfClass:[YDBridgeWebViewController class]]) {
            if (AFTER_IOS9) {
                self.currentViewController.navigationController.interactivePopGestureRecognizer.enabled = NO;
                self.allowsBackForwardNavigationGestures = YES;
            }
            
        } else {
            self.currentViewController.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.allowsBackForwardNavigationGestures = NO;
        }
    }
//    NSDictionary *param = [MSUtil queryDicFromUrl:self.URL];
    if([self.mDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.mDelegate webViewDidFinishLoad:self];
    }
}
- (void)callback_webViewDidStartLoad {
    self.noNetworkView.hidden = YES;
    if([self.mDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.mDelegate webViewDidStartLoad:self];
    }
}
- (void)callback_webViewDidFailLoadWithError:(NSError *)error {
    self.noNetworkView.hidden = NO;
    if([self.mDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.mDelegate webView:self didFailLoadWithError:error];
    }
}
-(BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType {
    NSLog(@"webview request:%@", request);
    if (navigationType == UIWebViewNavigationTypeBackForward) {
        self.isBackForward = YES;
    } else {
        self.isBackForward = NO;
    }
    BOOL resultBOOL = YES;
//    __weak typeof(self) wSelf = self;
//    YDURLDelivery *URLDelivery = [self.webMgr triggerEventWithURLString:request.URL];
//    resultBOOL = URLDelivery.shouldLoad;
//    [wSelf solveURLDelivery:URLDelivery then:nil];
//    if ([self.mDelegate respondsToSelector:@selector(webView:solveURLDelivery:)]) {
//        [self.mDelegate webView:self solveURLDelivery:URLDelivery];
//    }
    if([self.mDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        if(navigationType == -1) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.mDelegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType] & resultBOOL;
    }
    if (resultBOOL) {
        self.urlString = request.URL.absoluteString;
        self.webMgr.currentURLString = self.urlString;
        if (!self.notFirstLoad) {
//            if (self.useWK) {
//                NSURLRequest *mReq = [self.webMgr.helper setCookieWithWKRequest:request];
//                if (mReq == request) {
//                    return YES;
//                } else {
//                    [self loadRequest:mReq];
//                }
//                return NO;
//            }
        }
//        [self.webMgr.helper setCookieWithRequest:request];
    }
    return resultBOOL;
}
- (void)callback_webViewUpdateProgress:(float)progress {
    if([self.mDelegate respondsToSelector:@selector(webView:updateProgress:)]) {
        [self.mDelegate webView:self updateProgress:progress];
    }
}

#pragma mark -- 清理
-(void)dealloc {
    NSLog(@"webview dealloc");
    if(BEFORE_IOS8) {
        self.oldWebView.delegate = nil;
    } else {
        WKWebView* webView = self.freshWebView;
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        
        [webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [webView removeObserver:self forKeyPath:@"title"];
    }
    [self scrollView].delegate = nil;
    [self stopLoading];
    [self loadHTMLString:@"" baseURL:nil];
    [self stopLoading];
    [self.webView removeFromSuperview];
    self.webView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- function
- (void)setCurrentViewController:(UIViewController *)viewController {
    _currentViewController = viewController;
    [self.webMgr setCurrentViewController:viewController];
}
- (void)getSnapShotImage:(void(^)(UIImage *snapShotImage))then {
//    [TYSnapshot screenSnapshot:self.webView finishBlock:^(UIImage *snapShotImage) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            !then?:then(snapShotImage);
//        });
//    }];
}

- (void)setTopEdge:(CGFloat)topEdge {
    [self updateTopEdge:topEdge];
}

- (void)updateTopEdge:(CGFloat)topEdge {
    _topEdge = topEdge;
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topEdge);
    }];
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topEdge);
    }];
}

@end
