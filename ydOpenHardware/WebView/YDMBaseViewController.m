//
//  YDMBaseViewController.m
//  SportsBar
//
//  Created by 张旻可 on 15/12/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "YDMBaseViewController.h"
//#import "TYPagerController.h"
//#import "YDIndexViewController.h"
//#import "YDMDiscoverViewController.h"
//#import "YDCircleRootViewController.h"
//#import "YDCircleDynamicRootViewController.h"
//#import "YDMMeViewController.h"
//#import "YDNewChallengeViewController.h"
//#import "YDLiveViewController.h"
//#import "YDIndexViewController.h"

//#import "YDIndexStepViewController.h"
//#import "YDIndexRunViewController.h"
//#import "YDIndexFitViewController.h"
//#import "YDIndexRideViewController.h"
//#import "YDMineViewController.h"
#import "CWStatusBarNotification.h"

@implementation YDMBaseViewController

#pragma mark - initialize and dealloc

- (instancetype)init {
    self = [super init];
    if (self) {
        if (self.showMode == YDVCShowModeTabBar || self.showMode == YDVCShowModeBoth) {
            self.hidesBottomBarWhenPushed = NO;
        } else {
//            if (![self.class isSubclassOfClass:[YDIndexViewController class]] && ![self.class isSubclassOfClass:[YDNewChallengeViewController class]] && ![self.class isSubclassOfClass:[YDMDiscoverViewController class]] && ![self.class isSubclassOfClass:[YDCircleDynamicRootViewController class]] && ![self.class isSubclassOfClass:[YDMineViewController class]]) {
//                self.hidesBottomBarWhenPushed = YES;
//            }
        }
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"\n-------------------------------\n%@ %@\n-------------------------------\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
}

#pragma mark lifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"\n0-------------------------------\n%@ %@\n-------------------------------\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
    [self msInit];
}

- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear: animated];
//    if (self.statusBarNotification) {
//        [self.statusBarNotification dismissNotification];
//    }
//    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:NO];
//    NSLog(@"\n1-------------------------------\n%@ %@\n-------------------------------\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
//    //[TalkingData trackPageBegin: NSStringFromClass([self class])];
//    [MobClick beginLogPageView: self.title.length ? self.title : NSStringFromClass([self class])];
}

/**
 *  第二次进入界面时在viewDidAppear后调用
 */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    MSLogI(@"\n\n2-------------------------------\n%@ %@\n-------------------------------\n\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    MSLogI(@"\n\n3-------------------------------\n%@ %@\n-------------------------------\n\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
    if (self.isViewAppear) {
    }
    
    [self msReLayout];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    _isViewAppear = YES;
    NSLog(@"\n4-------------------------------\n%@ %@\n-------------------------------\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
    [self yd_viewDidAppear:animated];
}

- (void)viewWillDisappear: (BOOL)animated {
    [super viewWillDisappear: animated];
//    if (self.statusBarNotification) {
//        [self.statusBarNotification dismissNotification];
//    }
    _isViewAppear = NO;
    NSLog(@"\n5-------------------------------\n%@ %@\n-------------------------------\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
//    [self yd_dismissContinuousMsg];
    //[TalkingData trackPageEnd: NSStringFromClass([self class])];
//    [MobClick endLogPageView: self.title.length ? self.title : NSStringFromClass([self class])];
//    [self yd_clearAllTimeoutLoading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    NSLog(@"\n6-------------------------------\n%@ %@\n-------------------------------\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"\n-------------------------------\n%@ %@\n-------------------------------\n", NSStringFromClass([self class]), [NSString stringWithCString: __PRETTY_FUNCTION__ encoding: NSUTF8StringEncoding]);
//    if (self.isViewLoaded && !self.view.window && ![self isKindOfClass:[EaseRefreshTableViewController class]] && ![self isKindOfClass:[EaseViewController class]] && ![self isKindOfClass:[YDLiveViewController class]] && !self.isViewAppear) {
//        self.view = nil;
//    }
}

#pragma mark orientation
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED {
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationMaskPortrait;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0) __TVOS_PROHIBITED {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


#pragma mark ms
/**
 * 初始化
 */
- (void)msInit {
    [self msFrameworkInit];
    [self msComInit];
    [self msBind];
    [self msDataInit];
    [self msLangInit];
    [self msStyleInit];
}

/**
 * 框架初始化
 */
- (void)msFrameworkInit {
    //业务方法
    
}

/**
 * 控件初始化
 */
- (void)msComInit {
    
}

- (void)msRemoveViews {
    NSMutableArray<UIView *> *arr = @[].mutableCopy;
    [arr addObject:self.view];
    while (arr.firstObject) {
        for (UIView *view in arr.firstObject.subviews) {
            [view removeFromSuperview];
            if (view.subviews.count) {
                [arr addObject:view];
            }
        }
        [arr removeObjectAtIndex:0];
    }
    
}

/**
 * 数据初始化
 */
- (void)msDataInit {
    _uuid = _uuid ?: [NSUUID UUID].UUIDString;
}

/**
 * 事件绑定
 */
- (void)msBind {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

/**
 * 静态样式初始化
 */
- (void)msStyleInit {
    if (self.showMode == YDVCShowModeTabBar || self.showMode == YDVCShowModeBoth) {
        self.hidesBottomBarWhenPushed = NO;
    } else {
//        if (![self.class isSubclassOfClass:[YDIndexViewController class]] && ![self.class isSubclassOfClass:[YDNewChallengeViewController class]] && ![self.class isSubclassOfClass:[YDMDiscoverViewController class]] && ![self.class isSubclassOfClass:[YDCircleDynamicRootViewController class]] && ![self.class isSubclassOfClass:[YDMineViewController class]]) {
//            self.hidesBottomBarWhenPushed = YES;
//        }
    }
    
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/**
 *  重新布局的时候调用
 */
- (void)msReLayout {
    
}

/**
 *  语言初始化
 */
- (void)msLangInit {
    
}

- (void)createViewConstraints {
    
}

- (void)setShowMode:(YDVCShowMode)showMode {
    _showMode = showMode;
    if (_showMode == YDVCShowModeTabBar || _showMode == YDVCShowModeBoth) {
        self.hidesBottomBarWhenPushed = NO;
    } else {
//        if (![self.class isSubclassOfClass:[YDIndexViewController class]] && ![self.class isSubclassOfClass:[YDNewChallengeViewController class]] && ![self.class isSubclassOfClass:[YDMDiscoverViewController class]] && ![self.class isSubclassOfClass:[YDCircleDynamicRootViewController class]] && ![self.class isSubclassOfClass:[YDMineViewController class]]) {
//            self.hidesBottomBarWhenPushed = YES;
//        }
    }
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - keyboard

- (void)dismissKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
