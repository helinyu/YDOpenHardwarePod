//
//  MSVCRouter.h
//  MSVCRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSVCRouteURLType) {
    MSVCRouteURLType_invalid,            // 无效
    MSVCRouteURLType_nothing,            // 当前目录               : .
    MSVCRouteURLType_pop,                // 回上一个目录            : ..
    MSVCRouteURLType_gotoRoot,           // 回根目录               : /
    MSVCRouteURLType_push                // push
    // MSVCRouteURLType_push,                     // 在当前目录push               : 空
};

typedef UIViewController *  (^MSVCRouterBlock)();

@interface MSVCRouter : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy, readonly) NSString *currentPath;
@property (nonatomic, strong) UIViewController *rootViewController;     // windows.rootViewController
@property (nonatomic, strong) NSString *mainVCKey;
@property (nonatomic, strong) NSArray<NSString *> *tabVCArr;
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *tabChildVCDic;

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className;
- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController;
- (void)mapKey:(NSString *)key toBlock:(MSVCRouterBlock)block;

- (void)initWithJSONConfig;

// 当取出ViewController的时候, 如果有单例[ViewController sharedInstance], 默认返回单例, 如果没有, 返回[[ViewController alloc] init].
- (id)viewControllerForKey:(NSString *)key;

- (void)openURLString:(NSString *)URLString;

#pragma mark - override
/// 默认有个返回实际显示navigationController的方法. 你也可以在重写这个方法,以返回你期望的 navigationController
+ (UINavigationController *)expectedVisibleNavigationController;
@end


#pragma mark - UIViewController (MSVCRouter)
@interface UIViewController (MSVCRouter)
@property (nonatomic, copy, readonly) NSString *ms_URLPath;

- (UIViewController *)ms_topViewController;
@end

#pragma mark - UIViewController (MSVCRouter)
@interface UITabBarController (MSVCRouter)

@property (nonatomic, assign) BOOL ms_hasObserveSelectedViewController;
- (void)ms_init;
- (void)ms_setViewControllers: (NSArray *)vcs;
- (void)ms_unInit;

@end





