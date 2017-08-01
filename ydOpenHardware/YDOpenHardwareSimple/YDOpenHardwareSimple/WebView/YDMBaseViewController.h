//
//  YDMBaseViewController.h
//  SportsBar
//
//  Created by 张旻可 on 15/12/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Screenshot.h"
#import "UIViewController+YDMessage.h"
#import "UIViewController+YDNavigation.h"
#import "UIViewController+YDLoading.h"
#import "UIViewController+YDAlert.h"
#import "UIViewController+YDActionSheet.h"
#import "UIViewController+YDViewController.h"

@interface YDMBaseViewController : UIViewController

@property (nonatomic, readonly, assign) BOOL isViewAppear;
@property (nonatomic, readwrite, assign) YDVCShowMode showMode;
@property (nonatomic, readonly, copy) NSString *uuid;


#pragma ms
/**
 * 初始化
 */
- (void)msInit;

/**
 * 框架初始化
 */
- (void)msFrameworkInit;

/**
 * 控件初始化
 */
- (void)msComInit;

/**
 * 数据初始化
 */
- (void)msDataInit;

/**
 * 事件绑定
 */
- (void)msBind;

/**
 * 静态样式初始化
 */
- (void)msStyleInit;

/**
 *  重新布局的时候调用
 */
- (void)msReLayout;

/**
 *  语言初始化
 */
- (void)msLangInit;

- (void)createViewConstraints;
- (void)msRemoveViews;

- (void)dismissKeyboard;

@end
