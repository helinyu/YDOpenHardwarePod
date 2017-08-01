//
//  MSVCRouter.m
//  MSVCRouter
//
//  Created by heaven on 15/1/21.
//  Copyright (c) 2015年 heaven. All rights reserved.
//

#import "MSVCRouter.h"
#import <objc/runtime.h>

static NSString *re = @"(?<=T@\")(.*)(?=\",)";

#pragma mark - MSVCRouter_private
@interface NSString (MSVCRouter_private)
- (NSMutableDictionary *)__ms_dictionaryFromQueryComponents;
@end
#pragma mark - UIViewController_private
@interface UIViewController (UIViewController_private)
@property (nonatomic, copy) NSString *ms_URLPath;
@end

#pragma mark -
@interface MSVCRouter ()

@property (nonatomic, strong) NSMutableDictionary *map;
@property (nonatomic, weak, getter=getCurrentViewRoute) UIViewController *currentViewRoute;       // 当前的控制器
@property (nonatomic, copy) NSString *currentPath;

@property (nonatomic, assign) BOOL isPathCacheChanged;

@end

@implementation MSVCRouter

+ (instancetype)sharedInstance {
    static MSVCRouter *router = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[self alloc] init];
        }
    });
    return router;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _map                = [@{} mutableCopy];
        _isPathCacheChanged = YES;
        _mainVCKey = @"";
        _tabVCArr = @[];
        _tabChildVCDic = @{};
    }
    return self;
}

- (NSString *)currentPath {
    if (_isPathCacheChanged) {
        NSMutableString *string = [[NSMutableString alloc] init];
        UIViewController *vc = self.currentViewRoute;
        while (vc) {
            if (vc.parentViewController && [vc.parentViewController isKindOfClass: [UINavigationController class]]) {
                UINavigationController *nc = (UINavigationController *)vc.parentViewController;
                for (NSInteger i = nc.viewControllers.count - 1; i >= 0; i --) {
                    UIViewController *t_vc = nc.viewControllers[i];
                    if (t_vc.ms_URLPath) {
                        [string insertString: [NSString stringWithFormat: @"/%@", t_vc.ms_URLPath] atIndex: 0];
                    }
                }
            } else {
                if (vc.ms_URLPath && ![vc isKindOfClass: [UINavigationController class]]) {
                    [string insertString: [NSString stringWithFormat: @"/%@", vc.ms_URLPath] atIndex: 0];
                }
            }
            
            vc = vc.parentViewController;
        }
        _currentPath = string;
    }
    
    return _currentPath;
}

- (void)mapKey:(NSString *)key toControllerClassName:(NSString *)className {
    if (key.length == 0) {
        return;
    }
    
    _map[key] = className;
}

- (void)mapKey:(NSString *)key toControllerInstance:(UIViewController *)viewController {
    if (key.length == 0) {
        return;
    }
    
    _map[key] = viewController;
}


- (void)mapKey:(NSString *)key toBlock:(MSVCRouterBlock)block {
    if (key.length == 0) {
        return;
    }
    
    _map[key] = block;
}

- (void)initWithJSONConfig {
    NSString *manifestPath = [[NSBundle mainBundle] pathForResource:@"manifest" ofType:@"json"];
    NSData *manifestData = [[NSString stringWithContentsOfFile: manifestPath encoding: NSUTF8StringEncoding error: NULL] dataUsingEncoding: NSUTF8StringEncoding];;
    NSDictionary *manifest = [NSJSONSerialization JSONObjectWithData: manifestData options:NSJSONReadingAllowFragments error: nil];
    NSDictionary *applicationRoutes = [manifest valueForKeyPath: @"application.routes"];
    _mainVCKey = [manifest valueForKeyPath: @"application.main"];
    _tabVCArr = [manifest valueForKeyPath: @"application.tabVC"];
    _tabChildVCDic = [manifest valueForKeyPath: @"application.tabChildVC"];
    [applicationRoutes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [[MSVCRouter sharedInstance] mapKey:key toControllerClassName:obj];
    }];
}

- (id)viewControllerForKey:(NSString *)key {
    id obj = nil;
    
    if (key.length > 0) {
        obj = [_map objectForKey:key];
    }

    if (obj == nil)  {
        obj = key;
    }
    
    if (obj == nil) {
        return nil
        ;
    }

    UIViewController *vc = nil;
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)obj;
        NSInteger index = [str rangeOfString:@"?"].location;
        if (index != NSNotFound) {
            obj = [str substringToIndex:index];
        }
        Class classType = NSClassFromString((NSString *)obj);
#ifdef DEBUG
        NSString *error = [NSString stringWithFormat:@"%@ must be  a subclass of UIViewController class", obj];
        NSAssert([classType isSubclassOfClass:[UIViewController class]], error);
#endif
        if ([classType respondsToSelector: @selector(sharedInstance)]) {
            vc = [classType sharedInstance];
        } else {
            vc = [[classType alloc] init];
        }
    } else if ([obj isKindOfClass:[UIViewController class]]) {
        vc = (UIViewController *)obj;
    } else {
        MSVCRouterBlock objBlock = (MSVCRouterBlock)obj;
        vc = objBlock();
    }
    
    if ([vc isKindOfClass:[UINavigationController class]]) {
        ((UINavigationController *)vc).visibleViewController.ms_URLPath = key;
    }
    else {
        vc.ms_URLPath = key;
    }
    
    return vc;
}

- (void)openURLString:(NSString *)URLString {
    
    if ([URLString isEqualToString: self.currentPath]) {
        return;
    }
    
    NSString *URLStringEncoded = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url          = [NSURL URLWithString: URLStringEncoded];
    NSArray *s_components = [url pathComponents];
    NSMutableArray *components = [NSMutableArray arrayWithArray: s_components];
//#ifdef DEBUG
//    NSString *scheme             = url.scheme;
//    NSString *host               = url.host;
//    NSString *parameterString    = url.parameterString;
//#endif
    _isPathCacheChanged = YES;
    BOOL isChanged = [self __handleWindowWithURL:url];
    
    if (isChanged) {
        // todo 处理window.rootViewController改变的情况
    }
    
    isChanged = [self __handleModalWithURL:url];
    
    if (isChanged) {
        // todo 处理modal的情况
    }
    
    
    
    // 处理模态dismiss
    isChanged = [self __handleDismissWithURLString: URLStringEncoded];
    if (isChanged) return;
    
    UINavigationController *nvc = [[self class] __expectedVisibleNavigationController];
    // if (nvc == nil || (components.count == 0)) return;
    
    // 先看需求pop一些vc
    [self __handlePopViewControllerByComponents:components atNavigationController:nvc];
    
    // 多个路径先无动画push中间的vc
    NSInteger start = 0;
    if (components.count > 1) {
        
        NSArray *cur_components = [NSURL URLWithString: self.currentPath].pathComponents;
        start = [self lastSameComponentWithComponents:components components: cur_components];
        NSString *vk = components[start];
        UITabBarController *tvc = [self __expectedVisibleTabBarController: vk];
        if (tvc) {
            if ([self.tabVCArr containsObject: vk]) {
                if (components.count > (start + 1)) {
                    NSString *vk2 = components[start + 1];
                    NSArray *tvca = [self.tabChildVCDic objectForKey: vk];
                    if (tvca && [tvca containsObject: vk2]) {
                        NSUInteger index = [tvca indexOfObject: vk2];
                        if (index != NSNotFound) {
                            tvc.selectedIndex = index;
//                            [[NSNotificationCenter defaultCenter] postNotificationName: @"ChooseIndex" object: @(index)];
                            nvc = [[self class] __expectedVisibleNavigationController];
                            start++;
                        }
                        
                    }
                }
                
            }
        }
        
        
        for (NSInteger i = start + 1; i < components.count - 1; i++) {
            if ([components[i] isEqualToString:@"."] || [components[i] isEqualToString:@".."]) continue;
            
            UIViewController *vc = [self viewControllerForKey:components[i]];
            [self __pushViewController:vc parameters:nil atNavigationController:nvc animated:NO];
        }
    }
    
    // 最后在push最后的vc
    if (start < components.count - 1) {
        UIViewController *vc     = [self viewControllerForKey:[components lastObject]];
        NSDictionary *parameters = [self __dictionaryFromQuery:url.query];
        [self __pushViewController:vc parameters:parameters atNavigationController:nvc animated:YES];
    }
}

+ (UINavigationController *)expectedVisibleNavigationController {
    return (UINavigationController *)@"miss";
}

#pragma mark - private
- (UITabBarController *)__expectedVisibleTabBarController: (NSString *)vc_key {
    id vc = self.rootViewController;
    if (vc && [vc isKindOfClass: [UITabBarController class]] && [((UIViewController *)vc).ms_URLPath isEqualToString: vc_key]) {
        return vc;
    }
    if (vc && [vc isKindOfClass: [UINavigationController class]]) {
        for (id tvc in ((UINavigationController *)vc).viewControllers) {
            if ([tvc isKindOfClass: [UITabBarController class]] && [((UIViewController *)tvc).ms_URLPath isEqualToString: vc_key]) {
                return tvc;
            }
        }
        vc = ((UINavigationController *)vc).viewControllers.lastObject;
    }
    while (vc) {
        if (vc && [vc isKindOfClass: [UITabBarController class]] && [((UIViewController *)vc).ms_URLPath isEqualToString: vc_key]) {
            return vc;
        }
        vc = ((UIViewController *)vc).presentedViewController;
    }
    return nil;
}

+ (BOOL)__isAllPop: (NSArray *)components {
    for (NSInteger i = 0; i < components.count; i++) {
        NSString *cp = components[i];
        if (![cp isEqualToString: @"."] && ![cp isEqualToString: @".."] && ![cp isEqualToString: @"/"]) {
            return NO;
        }
    }
    return YES;
}

+ (MSVCRouteURLType)__routeTypeByComponent:(NSString *)component {
    if ([@"." isEqualToString: component]) {
        return MSVCRouteURLType_nothing;
    } else if ([@".." isEqualToString:component]) {
        return MSVCRouteURLType_pop;
    } else if ([@"/" isEqualToString:component]) {
        return MSVCRouteURLType_gotoRoot;
    }
    
    return MSVCRouteURLType_push;
}



+ (UINavigationController *)__expectedVisibleNavigationController {
    UINavigationController *nvc = [[self class] expectedVisibleNavigationController];
    if ([nvc isKindOfClass:[UINavigationController class]]) {
        return nvc;
    }
    else {
        UIViewController *vc = [self __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
        UINavigationController *nvc = (UINavigationController *)([vc isKindOfClass:[UINavigationController class]] ? vc : vc.navigationController);
        return nvc;
    }
}

+ (UIViewController *)__visibleViewController {
    UIViewController *vc = [self __visibleViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    return vc;
}

+ (UIViewController*)__visibleViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:tbc.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self __visibleViewControllerWithRootViewController:nvc.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self __visibleViewControllerWithRootViewController:presentedVC];
    } else {
        return rootViewController;
    }
}
- (void)__solveParam:(NSDictionary *)param vc:(UIViewController *)vc {
    [param enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        //安全性检查
        Class kClass = vc.class;
        while (kClass) {
            objc_property_t prop = class_getProperty(kClass, [key UTF8String]);
            if (prop) {
                NSString *propAttr = [[NSString alloc] initWithCString: property_getAttributes(prop) encoding: NSUTF8StringEncoding];
                NSRange range = [propAttr rangeOfString: re options: NSRegularExpressionSearch];
                if (range.length != 0) {
                    NSString *propClassName = [propAttr substringWithRange: range];
                    Class propClass = objc_getClass([propClassName UTF8String]);
                    if ([propClass isSubclassOfClass:[NSString class]]) {
                        [vc setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                    } else {
                        [vc setValue:obj forKey:key];
                    }
                    
                } else {
                    [vc setValue:obj forKey:key];
                }
                kClass = nil;
            } else {
                kClass = class_getSuperclass(kClass);
            }
        }
    }];
}

// 处理host改变的情况
- (BOOL)__handleWindowWithURL:(NSURL *)URL {
    NSString *scheme = URL.scheme;
    NSString *host   = URL.host;
    
    if ([@"window" isEqualToString:scheme] && host.length > 0) {
        UIViewController *vc = [self viewControllerForKey:host];
        NSArray *components          = [URL pathComponents];
        if (components.count < 2) {
            NSDictionary *queryDictonary = [self __dictionaryFromQuery:URL.query];
            [self __solveParam:queryDictonary vc:vc];
        }
        self.rootViewController = vc;
        return YES;
    }
    
    return NO;
}

// 处理dismiss模态视图
- (BOOL)__handleDismissWithURLString:(NSString *)URLString {
    if ([@"dismiss" isEqualToString:URLString]) {
        [self.rootViewController dismissViewControllerAnimated:YES completion: ^{
        }];
        return YES;
    }
    
    return NO;
}

// 处理模态视图
- (BOOL)__handleModalWithURL:(NSURL *)URL {
    NSString *scheme = URL.scheme;
    NSString *host   = URL.host;
    
    if ([@"modal" isEqualToString:scheme] && host.length > 0) {
        UIViewController *vc = [self viewControllerForKey:host];
        NSArray *components          = [URL pathComponents];
        BOOL animated = NO;
        if (components.count < 2) {
            NSDictionary *queryDictonary = [self __dictionaryFromQuery:URL.query];
            [self __solveParam:queryDictonary vc:vc];
            animated = YES;
        }
        [self.rootViewController presentViewController:vc animated:animated completion: ^{
        }];
        return YES;
    }
    
    return NO;
}

// 先看需求pop一些vc
- (void)__handlePopViewControllerByComponents:(NSMutableArray *)components atNavigationController:(UINavigationController *)navigationController {
    while (components.count) {
        NSString *cp = components[0];
        MSVCRouteURLType type = [self.class __routeTypeByComponent: cp];
        BOOL animated = NO;
        if ((components.count == 1 &&
            ([components[0] isEqualToString:@".."] || [components[0] isEqualToString:@"/"])) || navigationController.viewControllers.count == 2) {
            animated = YES;
        }
        
        if (type == MSVCRouteURLType_nothing) {
            break;
        } else if (type == MSVCRouteURLType_pop) {
            [navigationController popViewControllerAnimated: animated];
        } else if (type == MSVCRouteURLType_gotoRoot) {
            [navigationController popToRootViewControllerAnimated: animated];
        } else if (type == MSVCRouteURLType_push) {
            break;
        }
        [components removeObjectAtIndex: 0];
    }
}

- (NSInteger)lastSameComponentWithComponents:(NSArray *)components viewControllers:(NSArray *)vcs {
    NSInteger max = MIN(components.count, vcs.count);
    
    NSInteger result = 0;
    for (NSInteger i = 1; i < max; i++) {
        if (![components[i] isEqualToString:[vcs[i] ms_URLPath]]) {
            result = i - 1;
            break;
        }
        result = i;
    }
    
    return result;
}

- (NSInteger)lastSameComponentWithComponents:(NSArray *)components components:(NSArray *)cur_components {
    if ([cur_components containsObject: @"/"]) {
        NSMutableArray *ta = [NSMutableArray arrayWithArray: cur_components];
        if (ta.count > 0) {
            [ta removeObjectAtIndex: 0];
        }
        cur_components = ta;
    }
    NSInteger max = MIN(components.count, cur_components.count);
    
    NSInteger result = 0;
    for (NSInteger i = 0; i < max; i++) {
        if (![components[i] isEqualToString: cur_components[i]]) {
            break;
        }
        result = i;
    }
    result = (result < 0 ? 0: result);
    return result;
}

- (void)__pushViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters atNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated {
    if (viewController == nil || [viewController isKindOfClass:[UINavigationController class]] || navigationController == nil) return;
    
    [self __solveParam:parameters vc:viewController];
    
    [navigationController pushViewController:viewController animated:animated];
}

- (NSString *)__URLDecodingWithEncodingString:(NSString *)encodingString {
    NSMutableString *string = [NSMutableString stringWithString:encodingString];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)__dictionaryFromQuery:(NSString *)query {
    NSMutableDictionary *result = [@{} mutableCopy];
    NSArray *array = [query componentsSeparatedByString:@"&"];
    for (NSString *keyValuePairString in array) {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue;
        
        NSString *key   = [self __URLDecodingWithEncodingString:keyValuePairArray[0]];
        NSString *value = [self __URLDecodingWithEncodingString:keyValuePairArray[1]];
        NSNumber *value2 = nil;
        if ([self __isPureInt: value] || [self __isPureFloat: value]) {
            NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
            value2 = [nf numberFromString: value];
            result[key] = value2;
        } else {
            result[key] = value;
        }
        
    }
    
    return result;
}

- (NSString *)__queryFromUrl:(NSString *)url {
    if (url) {
        NSInteger index1 = [url rangeOfString:@"?"].location;
        NSInteger index2 = [url rangeOfString:@"#"].location;
        if (index1 == NSNotFound) {
            return nil;
        } else {
            if (index2 == NSNotFound) {
                index2 = url.length;
            }
            return [url substringWithRange:NSMakeRange(index1+1, index2-index1-1)];
        }
    }
    return nil;
}

//判断是否为整形：
- (BOOL)__isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)__isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - getter / setter
- (void)setRootViewController:(UIViewController *)rootViewController {
    [UIApplication sharedApplication].delegate.window.rootViewController = rootViewController;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

- (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (UIViewController *)getCurrentViewRoute {
    return self.rootViewController.ms_topViewController;
}
@end

#pragma mark - UIViewController
static const char *MSVCRouter_URLPath = "MS.ViewController.URLPath";

@implementation UIViewController (MSVCRouter)

- (NSString *)ms_URLPath {
    NSString *url_path = objc_getAssociatedObject(self, MSVCRouter_URLPath);
    if (!url_path) {
        url_path = NSStringFromClass([self class]);
    }
    return url_path;
}

- (void)setMs_URLPath:(NSString *)ms_URLPath {
    objc_setAssociatedObject(self, MSVCRouter_URLPath, ms_URLPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIViewController *)ms_topViewController {
    id vc = self;
    if ([vc isKindOfClass: [UITabBarController class]]) {
        UITabBarController *tbc = (UITabBarController *)vc;
        vc = tbc.selectedViewController;
    }
    if ([vc isKindOfClass: [UINavigationController class]]) {
        UINavigationController *nc = vc;
        vc = nc.visibleViewController;
    }
    return vc;
}

@end

#pragma mark - UITabBarController
static const char *MSVCRouter_hasObserveSelectedViewController = "MS.TabBarController.hasOberseveSelectedViewController";
static NSString *const MSVCRouter_selectedViewControllerPropName = @"selectedViewController";

@implementation UITabBarController (MSVCRouter)

- (BOOL)ms_hasObserveSelectedViewController {
    return (BOOL)objc_getAssociatedObject(self, MSVCRouter_hasObserveSelectedViewController);
}

- (void)setMs_hasObserveSelectedViewController:(BOOL)ms_hasObserveSelectedViewController {
    objc_setAssociatedObject(self, MSVCRouter_hasObserveSelectedViewController, @(ms_hasObserveSelectedViewController), OBJC_ASSOCIATION_ASSIGN);
}


- (void)ms_init {
    
    if (self.ms_hasObserveSelectedViewController) {
        [self removeObserver: self forKeyPath: MSVCRouter_selectedViewControllerPropName];
    }
    [self addObserver: self forKeyPath: MSVCRouter_selectedViewControllerPropName options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context: nil];
    self.ms_hasObserveSelectedViewController = YES;
}

- (void)ms_unInit {
    if (self.ms_hasObserveSelectedViewController) {
        [self removeObserver: self forKeyPath: MSVCRouter_selectedViewControllerPropName];
    }
}

- (void)ms_setViewControllers: (NSArray *)vcs {
    self.viewControllers = vcs;
    if (vcs && vcs.count > 0) {
        if ([vcs[0] isKindOfClass: [UINavigationController class]]) {
            UINavigationController *nav = vcs[0];
            [MSVCRouter sharedInstance].currentViewRoute = nav.visibleViewController;
            [MSVCRouter sharedInstance].isPathCacheChanged = YES;
        } else {
            [MSVCRouter sharedInstance].currentViewRoute = vcs[0];
            [MSVCRouter sharedInstance].isPathCacheChanged = YES;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString: MSVCRouter_selectedViewControllerPropName]) {
        id selected_vc = [change objectForKey: NSKeyValueChangeNewKey];
        if (selected_vc) {
            if ([selected_vc isKindOfClass: [UINavigationController class]]) {
                UINavigationController *nav = selected_vc;
                [MSVCRouter sharedInstance].currentViewRoute = nav.visibleViewController;
                [MSVCRouter sharedInstance].isPathCacheChanged = YES;
            } else {
                [MSVCRouter sharedInstance].currentViewRoute = selected_vc;
                [MSVCRouter sharedInstance].isPathCacheChanged = YES;
            }
        }
    }
}

@end

#pragma mark - MSVCRouter_private

#pragma mark -







