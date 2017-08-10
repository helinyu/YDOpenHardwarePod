//
//  YDBluetoothWebViewMgr.h
//  SportsBar
//
//  Created by Aka on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebViewJavascriptBridge;

@interface YDBluetoothWebViewMgr :NSObject

@property (nonatomic, strong) WebViewJavascriptBridge *webViewBridge;

+ (instancetype)shared;

- (void)scanPeripheralWithMatchInfo:(NSString *)matchWord;

- (void)startScanThenSourcesCallback:(void(^)(NSArray *peirpherals))callback;

- (void)registerHandlers;

- (void)onActionByViewDidDisappear;


//datas caches
typedef void(^ResponseDic)(NSDictionary *dic);

typedef void(^ResponseIdObject)(id idObj);
typedef ResponseIdObject ResponseJsonObject;


@end
