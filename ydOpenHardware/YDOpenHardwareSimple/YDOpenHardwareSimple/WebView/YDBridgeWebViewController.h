//
//  YDBridgeWebViewController.h
//  SportsBar
//
//  Created by 张旻可 on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YDMBaseViewController.h"

@class YDBridgeWebView;

@interface YDBridgeWebViewController : YDMBaseViewController

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) YDWebViewType type;
@property (nonatomic, weak, readwrite) YDBridgeWebView *webView;
@property (nonatomic, assign) CGFloat topEdge;

+ (instancetype)instanceWithType:(YDWebViewType)type urlString:(NSString *)urlString;
- (instancetype)initWithUrl:(NSString *)urlString andType:(YDWebViewType)type;

- (void)reloadWebView;

@end
