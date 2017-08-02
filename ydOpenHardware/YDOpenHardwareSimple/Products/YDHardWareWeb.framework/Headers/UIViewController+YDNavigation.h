//
//  UIViewController+YDNavigation.h
//  SportsBar
//
//  Created by Szythum on 17/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YDNavBarStyle) {
    YDNavBarStyleGreen,
    YDNavBarStyleGray,
    YDNavBarStyleNone,
};

typedef NS_ENUM(NSInteger, YDVCShowMode) {
    YDVCShowModeNone = 0,
    YDVCShowModeNavBar = 1,
    YDVCShowModeTabBar = 2,
    YDVCShowModeBoth = 3,
    YDVCShowModeLast = 4
};

@interface UIViewController (YDNavigation)

@property (nonatomic, strong, readonly) UINavigationBar *navBar;

- (void)yd_viewDidAppear:(BOOL)animated;
- (void)yd_switchNavPopGesture:(BOOL)enable;
- (void)yd_navBarInitWithStyle:(YDNavBarStyle)style;
- (void)yd_setTitle:(NSString *)title;
- (void)yd_popUp;
- (void)yd_popToRootIfResetTabBar:(BOOL)resetTabBar;



// override by subclass
- (void)msNavBarInit: (UINavigationBar *)navBar;

@end
