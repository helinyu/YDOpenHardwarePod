//
//  UIViewController+YDNavigation.m
//  SportsBar
//
//  Created by Szythum on 17/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIViewController+YDNavigation.h"
#import "YDBaseTabBarController.h"
#import <objc/runtime.h>
#import "YDMBaseViewController.h"
#import "YDBaseViewController.h"

@interface UIViewController ()

@property (nonatomic, strong, readwrite) UINavigationBar *navBar;
@property (nonatomic, assign, readwrite) BOOL yd_isViewAppear;
@property (nonatomic, assign, readwrite) BOOL yd_shouldPopup;

@end

@implementation UIViewController (YDNavigation)

#pragma mark - lifecycle
- (void)yd_viewDidAppear:(BOOL)animated {
    self.yd_isViewAppear = YES;
    if (self.yd_shouldPopup) {
        self.yd_shouldPopup = NO;
        [self yd_popUp];
    }
}

#pragma mark - property

- (void)setNavBar:(UINavigationBar *)navBar {
    objc_setAssociatedObject(self, @selector(navBar), navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationBar *)navBar {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYd_isViewAppear:(BOOL)yd_isViewAppear {
    objc_setAssociatedObject(self, @selector(yd_isViewAppear), @(yd_isViewAppear), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)yd_isViewAppear {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
}

- (void)setYd_shouldPopup:(BOOL)yd_shouldPopup {
    objc_setAssociatedObject(self, @selector(yd_shouldPopup), @(yd_shouldPopup), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)yd_shouldPopup {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
}

#pragma mark -- public

- (void)yd_navBarInitWithStyle:(YDNavBarStyle)style {
    if (self.navBar == nil) {
        UINavigationBar *vobj = [[UINavigationBar alloc] init];
        [self.view addSubview: vobj];
        [self setNavBar:vobj];
        [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(YDTopLayoutH);
        }];
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:self.title];
        item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_white"] style:UIBarButtonItemStylePlain target:self action:@selector(yd_popUp)];
        [self.navBar pushNavigationItem:item animated:NO];
        
        switch (style) {
            case YDNavBarStyleGreen: {
                //            [self.navBar setTintColor:[UIColor whiteColor]];
                //            [self.navBar setBarTintColor:YDC_G];
                //            [self.navBar setTitleTextAttributes:@{NSFontAttributeName: YDF_SYS(YDFontSizeNav),
                //                                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                //                                                  }];
                [self.navBar setBarStyle:UIBarStyleBlack];
                [self.navBar setTintColor:YD_WHITE(1)];
                [self.navBar setBarTintColor:YDC_G];
                [self.navBar setTitleTextAttributes:@{NSFontAttributeName:YDF_DEFAULT_R(YDFontSizeNav), NSForegroundColorAttributeName: YD_WHITE(1)}];
                //            [self.navBar setBackgroundImage:[UIImage imageFromColor:YDC_G withSize:CGSizeMake(1, 1) radius:0] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
                //            [self.navBar setShadowImage:[UIImage imageFromColor:YDC_G withSize:CGSizeMake(1, 1) radius:0]];
                //            self.navBar.translucent = YES;
                break;
            }
            case YDNavBarStyleGray: {
                [self.navBar setBarStyle:UIBarStyleDefault];
                [self.navBar setTintColor:YDC_NAV_TINT];
                [self.navBar setBarTintColor:YDC_NAV];
                [self.navBar setTitleTextAttributes:@{NSFontAttributeName: YDF_DEFAULT_R(YDFontSizeNav),
                                                      NSForegroundColorAttributeName: YDC_TITLE,
                                                      }];
                self.navBar.translucent = YES;
                self.navBar.topItem.leftBarButtonItem.tintColor = YDC_NAV_TINT_WEAK;
                self.navBar.topItem.rightBarButtonItem.tintColor = YDC_NAV_TINT;
//                UIView *blurView = [UIView new];
//                blurView.frame = CGRectMake(0, 0, SCREEN_WIDTH_V0, 64);
//                CAGradientLayer *layer = [CAGradientLayer layer];
//                layer.frame = CGRectMake(0, 0, SCREEN_WIDTH_V0, 64);
//                layer.colors = @[(__bridge id)YD_GRAYA(242, 0.76).CGColor, (__bridge id)YD_GRAYA(242, 0.28).CGColor];
//                layer.startPoint = CGPointMake(0, 0);
//                layer.endPoint = CGPointMake(0, 1.0);
//                [blurView.layer addSublayer:layer];
//                blurView.userInteractionEnabled = NO;
//                blurView.alpha = 0.5;
//                [self.navBar insertSubview:blurView atIndex:0];
                
                break;
            }
            case YDNavBarStyleNone: {
                [self.navBar setBarStyle:UIBarStyleDefault];
                [self.navBar setTintColor:YDC_NAV_TINT];
                [self.navBar setBarTintColor:YDC_NAV];
                [self.navBar setTitleTextAttributes:@{NSFontAttributeName: YDF_DEFAULT_R(YDFontSizeNav),
                                                      NSForegroundColorAttributeName: YDC_TITLE,
                                                      }];
                self.navBar.translucent = YES;
                self.navBar.topItem.leftBarButtonItem.tintColor = YDC_NAV_TINT_WEAK;
                self.navBar.topItem.rightBarButtonItem.tintColor = YDC_NAV_TINT;
                self.navBar.subviews.firstObject.alpha = 0;
                break;
            }
        }
    } else {
        if (![self.view.subviews containsObject:self.navBar]) {
            [self.view addSubview: self.navBar];
            [self.navBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.view);
                make.height.mas_equalTo(YDTopLayoutH);
            }];
        }
    }
    [self msNavBarInit: self.navBar];
}

- (void)msNavBarInit: (UINavigationBar *)navBar {
    
}

- (void)yd_setTitle:(NSString *)title {
    self.title = title;
    self.navBar.topItem.title = title;
}

- (void)yd_popUp {
    BOOL flag = YES;
    if ([self isKindOfClass:[YDMBaseViewController class]] || [self isKindOfClass:[YDBaseViewController class]]) {
        if (!self.yd_isViewAppear) {
            flag = NO;
        }
    }
    if (flag) {
        UIViewController *vc = self;
        if (vc.navigationController.viewControllers.count > 1) {
            [vc.navigationController popViewControllerAnimated:YES];
        } else {
            [vc dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        self.yd_shouldPopup = YES;
    }
    
    
}

- (void)yd_popToRootIfResetTabBar:(BOOL)resetTabBar {
    YDBaseTabBarController *rootTabBarController = [[YDBaseTabBarController alloc] init];
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    if (keyWindow == nil) {
        return;
    }
    rootTabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [UIView transitionWithView:keyWindow
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        keyWindow.rootViewController = rootTabBarController;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
}

- (void)yd_switchNavPopGesture:(BOOL)enable {
    self.navigationController.interactivePopGestureRecognizer.enabled = enable;
}

#pragma mark - private

@end
