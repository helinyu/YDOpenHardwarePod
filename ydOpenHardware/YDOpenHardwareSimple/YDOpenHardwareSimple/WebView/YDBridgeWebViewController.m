//
//  YDBridgeWebViewController.m
//  SportsBar
//
//  Created by 张旻可 on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YDBridgeWebViewController.h"

#import "YDBridgeWebView.h"
#import "YDBridgeWebMgr.h"

#import "MSUtil.h"


@interface YDBridgeWebViewController () <YDBridgeWebViewDelegate>


@property (nonatomic, copy) NSString *curUrlString;

@property (nonatomic, strong) YDBridgeWebMgr *webMgr;

// left
@property (nonatomic, strong) UIBarButtonItem *closeItem;
// right
@property (nonatomic, strong) UIBarButtonItem *shareItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UILabel *rightBtnLabel;

@property (nonatomic, copy) NSString *rightBtnReloadUrlString;


@property (nonatomic, assign) BOOL shouldBackRefresh;
@property (nonatomic, assign) BOOL forceNotBackRefresh;

@property (nonatomic, assign) BOOL notFirstAppear;

@property (nonatomic, assign) BOOL preNavPopGPEnableStatus;

@property (nonatomic, assign) BOOL backEqualToClose;

@end

@implementation YDBridgeWebViewController

#pragma mark - property init
- (YDBridgeWebMgr *)webMgr {
    if (!_webMgr) {
        _webMgr = [YDBridgeWebMgr webMgrWithController:self];
    }
    return _webMgr;
}

#pragma mark - property lazy init

- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_close"] style:UIBarButtonItemStylePlain target:self action:@selector(toCloseWebView:)];
        _closeItem.tintColor = YDC_NAV_TINT_WEAK;
    }
    return _closeItem;
}

- (UIBarButtonItem *)shareItem {
    if (!_shareItem) {
        _shareItem = [[UIBarButtonItem alloc] initWithTitle:MSLocalizedString(@"分享", nil) style:UIBarButtonItemStylePlain target:self action:@selector(toShare:)];
        _shareItem.tintColor = YDC_NAV_TINT;
    }
    return _shareItem;
}

- (UIBarButtonItem *)rightItem {
    if (!_rightItem) {
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120.f, 40.f)];
        
        _rightBtnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10.f, 90.f, 21.f)];
        _rightBtnLabel.textColor = YDC_NAV_TINT;
        _rightBtnLabel.font = YDF_SYS(15.f);
        _rightBtnLabel.text = MSLocalizedString(@"Location", nil);
        _rightBtnLabel.textAlignment = NSTextAlignmentRight;
        
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [arrowBtn setImage:[UIImage imageNamed:@"arrow_location_white"] forState:UIControlStateNormal];;
        arrowBtn.frame = CGRectMake(96.f, 18.f, 10.f, 6.f);
        arrowBtn.tintColor = YDC_NAV_TINT;
        [arrowBtn addTarget:self action:@selector(toRight:) forControlEvents:UIControlEventTouchUpInside];
        
        [rightView addSubview:_rightBtnLabel];
        [rightView addSubview:arrowBtn];
        _rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    }
    return _rightItem;
}

#pragma mark - initialize and dealloc

+ (instancetype)instanceWithType:(YDWebViewType)type urlString:(NSString *)urlString {
    return [[self alloc] initWithUrl:urlString andType:type];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _topEdge = YDTopLayoutH;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)urlString andType:(YDWebViewType)type {
    self = [self init];
    if (self) {
        _urlString = urlString;
        _type = type;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - framework init

/**
 *  create subviews
 */
- (void)msComInit {
    // ...
    
    [super msComInit];
    
        if (!self.urlString.length) {
            self.urlString = self.url.absoluteString;
        }
        if (!self.curUrlString.length) {
            self.curUrlString = self.urlString;
        }
        YDBridgeWebView *webview = [YDBridgeWebView instanceWithType:self.type urlString:self.curUrlString webMgr:self.webMgr];
        webview.currentViewController = self;
        self.curUrlString = self.webView.urlString;
        [self.view addSubview:webview];
        self.webView = webview;
        self.webView.topEdge = self.topEdge;
        self.webView.mDelegate = self;
        
        [self createViewConstraints];
        [self yd_navBarInitWithStyle:YDNavBarStyleGray];
    
 }

/**
 *  create constraints
 */
- (void)createViewConstraints {
    // ...
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super createViewConstraints];
}

/**
 *  notification bind & touch events bind & delegate bind
 */
- (void)msBind {
    [super msBind];
    
    // ...
//    yd.readload.html
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRealHtmlNotify:) name:@"yd.readload.html" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 *  data init
 */
- (void)msDataInit {
    [super msDataInit];
    
    // ...
    self.preNavPopGPEnableStatus = self.navigationController.interactivePopGestureRecognizer.enabled;
}

/**
 *  static style.
 */
- (void)msStyleInit {
    [super msStyleInit];
    
    // ...
    self.view.backgroundColor = YD_WHITE(1);
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.showProgress = YES;
}

/**
 *  language init
 */
- (void)msLangInit {
    [super msLangInit];
    
    // ...
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView evaluateJavaScript:@"if ('viewWillAppear' in window) { viewWillAppear(); }" completionHandler:^(id result, NSError *error) {
        
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.webView evaluateJavaScript:@"if ('viewDidAppear' in window) { viewDidAppear(); }" completionHandler:^(id result, NSError *error) {
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView evaluateJavaScript:@"if ('viewWillDisappear' in window) { viewWillDisappear(); }" completionHandler:^(id result, NSError *error) {
        
    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.notFirstAppear = YES;
    [self hideCloseItem:NO animated:YES];
    [self.webView evaluateJavaScript:@"if ('viewDidDisappear' in window) { viewDidDisappear(); }" completionHandler:^(id result, NSError *error) {
        
    }];
    
    [self.webMgr onActionByViewDidDisappear];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)yd_popUp {
    if (self.backEqualToClose) {
        [self toCloseWebView:nil];
    } else {
        if (self.webView.isLoading) {
            [super yd_popUp];
            return;
        }
#warning --- goback
//        if (![[MSUtil noParamsURLStringFromURLString:self.curUrlString] isEqualToString:[MSUtil noParamsURLStringFromURLString:self.urlString]] && [self.webView canGoBack]) {
//        [self.webView goBack];
//test
        if ([self.urlString containsString:@"peripheralList"]) {
            self.urlString = @"S3.html";
            [_webView loadWithBundleFile:self.urlString];
        } else {
            
            self.navigationController.interactivePopGestureRecognizer.enabled = self.preNavPopGPEnableStatus;
            [super yd_popUp];
        }
    }
    
}



#pragma mark - custom function
//- (void)share {
//    [self.webMgr share];
//}

#pragma mark - navigation bar

- (void)msNavBarInit:(UINavigationBar *)navBar {
    [self hideCloseItem:YES animated:NO];
    [self hideShareItem:YES animated:NO];
    [self hideRightItem:YES animated:NO];
}

- (void)hideCloseItem:(BOOL)hide animated:(BOOL)animated {
    NSMutableArray *navItems = @[].mutableCopy;
    if (self.navBar.topItem.leftBarButtonItems.count) {
        navItems = self.navBar.topItem.leftBarButtonItems.mutableCopy;
    }
    if (hide && [navItems containsObject:self.closeItem]) {
        [navItems removeObject:self.closeItem];
    } else if (!hide && ![navItems containsObject:self.closeItem]) {
        [navItems addObject:self.closeItem];
    }
    [self.navBar.topItem setLeftBarButtonItems:navItems.copy animated:animated];
}


- (void)hideShareItem:(BOOL)hide animated:(BOOL)animated {
    NSMutableArray *navItems = @[].mutableCopy;
    if (self.navBar.topItem.rightBarButtonItems.count) {
        navItems = self.navBar.topItem.rightBarButtonItems.mutableCopy;
    }
    if (hide && [navItems containsObject:self.shareItem]) {
        [navItems removeObject:self.shareItem];
    } else if (!hide && ![navItems containsObject:self.shareItem]) {
        [navItems addObject:self.shareItem];
    }
    [self.navBar.topItem setRightBarButtonItems:navItems.copy animated:animated];
}

- (void)hideRightItem:(BOOL)hide animated:(BOOL)animated {
    NSMutableArray *navItems = @[].mutableCopy;
    if (self.navBar.topItem.rightBarButtonItems.count) {
        navItems = self.navBar.topItem.rightBarButtonItems.mutableCopy;
    }
    if (hide && [navItems containsObject:self.rightItem]) {
        [navItems removeObject:self.rightItem];
    } else if (!hide && ![navItems containsObject:self.rightItem]) {
        [navItems addObject:self.rightItem];
    }
    [self.navBar.topItem setRightBarButtonItems:navItems.copy animated:animated];
}

#pragma mark - event action
- (void)toRight:(id)sender {
    NSURLRequest *request =[[NSURLRequest alloc]init];
    NSURL *url = [NSURL yd_URLWithString:self.rightBtnReloadUrlString];
    request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)toCloseWebView:(id)sender {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (self.navigationController.viewControllers.count > 1) {
        UIViewController *lastVc;
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[YDBridgeWebViewController class]]) {
                break;
            }
            lastVc = vc;
        }
        self.navigationController.interactivePopGestureRecognizer.enabled = self.preNavPopGPEnableStatus;
        if (lastVc) {
            [self.navigationController popToViewController:lastVc animated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } else {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)toShare:(id)sender {
    [self.webView evaluateJavaScript:@"MetaShareInfo();" completionHandler:^(id result, NSError *error) {
        
    }];
    
}

#pragma mark - network request

#pragma mark - notification
- (void)appBecomActive:(NSNotification *)notification {
    
}

- (void)onRealHtmlNotify:(NSNotification *)notification {
    NSString *urlString = notification.object;
    self.urlString = urlString;
//    self.webView =[YDBridgeWebView instanceWithType:self.type urlString:self.curUrlString webMgr:self.webMgr];
    self.webView.urlString = urlString;
    [self.webView reload];
}

#pragma mark - delegate

#pragma mark - out function
- (void)reloadWebView {
    [self.webView reload];
}
- (void)setTopEdge:(CGFloat)topEdge {
    _topEdge = topEdge;
    if (_webView) {
        _webView.topEdge = topEdge;
    }
}

#pragma mark - webdelegate
- (BOOL)webView:(YDBridgeWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeBackForward) {
        self.notFirstAppear = YES;
        [self hideCloseItem:NO animated:YES];
    } else if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeFormSubmitted || navigationType == UIWebViewNavigationTypeFormResubmitted || navigationType == UIWebViewNavigationTypeOther) {
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(YDBridgeWebView *)webView {
    self.backEqualToClose = NO;
}
- (void)webViewDidFinishLoad:(YDBridgeWebView *)webView {
    self.curUrlString = webView.urlString;
    self.navBar.topItem.title = webView.title;
//    NSDictionary *param = [MSUtil queryDicFromUrl:self.webView.URL];
    
}
- (void)webView:(YDBridgeWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
- (void)webView:(YDBridgeWebView *)webView updateProgress:(double)progress {
    
}

@end
