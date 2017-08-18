//
//  YDBluetoothWebViewMgr.h
//  SportsBar
//
//  Created by Aka on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;
@class WebViewJavascriptBridge;

@interface YDBluetoothWebViewMgr :NSObject

@property (nonatomic, strong) WebViewJavascriptBridge *webViewBridge;

+ (instancetype)shared;

- (void)scanPeripheralWithMatchInfo:(NSString *)matchWord;

- (void)connectPeripheral:(CBPeripheral *)peripheal;
- (void)connectDefaultPeirpheal; // 连接上一个已经设置为连接目标的蓝牙
- (void)cancelConnectPeripheal;
- (void)cancelConnectedPeripheralWithPeripheal:(CBPeripheral *)peripheal;

- (void)startScanThenSourcesCallback:(void(^)(NSArray *peirpherals))callback;

- (void)registerHandlersWithType:(NSUInteger)type;

- (void)onActionByViewDidDisappear;

//datas caches
typedef void(^ResponseDic)(NSDictionary *dic);
typedef void(^ResponseIdObject)(id idObj);
typedef ResponseIdObject ResponseJsonObject;

//test for write dats
- (void)writeDatas:(NSData *)datas;

@end
