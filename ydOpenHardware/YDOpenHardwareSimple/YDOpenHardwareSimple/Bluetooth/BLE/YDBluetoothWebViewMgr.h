//
//  YDBluetoothWebViewMgr.h
//  SportsBar
//
//  Created by Aka on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;
@class CBService;
@class CBCharacteristic;
@class WebViewJavascriptBridge;

@interface YDBluetoothWebViewMgr :NSObject

@property (nonatomic, strong) WebViewJavascriptBridge *webViewBridge;

+ (instancetype)shared;

- (void)scanPeripheralWithMatchInfo:(NSDictionary *)filterInfo;
- (void)connectPeripheral:(CBPeripheral *)peripheal;

- (void)connectDefaultPeirpheal; // 连接上一个已经设置为连接目标的蓝牙
- (void)cancelConnectPeripheal;
- (void)cancelConnectedPeripheralWithPeripheal:(CBPeripheral *)peripheal;

- (void)startScanThenSourcesCallback:(void(^)(NSArray *peirpherals))callback;
- (void)startScanThenNewPeripheralCallback:(void(^)(CBPeripheral *peripheral))peripheralCallback;

- (void)registerHandlersWithType:(NSUInteger)type;

- (void)onActionByViewDidDisappear;

//datas caches
typedef void(^ResponseDic)(NSDictionary *dic);
typedef void(^ResponseIdObject)(id idObj);
typedef ResponseIdObject ResponseJsonObject;

//test for write dats
- (void)writeDatas:(NSData *)datas;

- (CBPeripheral *)obtainPeripheralWithUUIDString:(NSString *)uuidString;

typedef void(^ServicesCallback)(NSArray<CBService *> *services);
@property (nonatomic, copy) ServicesCallback servicesCallBack;

- (void)onConnectPeripheral:(CBPeripheral *)peripheral then:(ServicesCallback)servicesCallback;

@property (nonatomic, copy) void (^connectionCallBack)(BOOL success);

//@property (nonatomic, copy) void(^characteristicCallBack)(CBCharacteristic *c);
typedef void (^CharacteristicCallback)(CBCharacteristic *c);
@property (nonatomic, copy) CharacteristicCallback discoverCharacteristicCallback;
@property (nonatomic, copy) CharacteristicCallback updateValueCharacteristicCallBack;

@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;

- (void)writeDataWithByte:(NSData*)data;

- (void)setNotifyWithCharacteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;
- (void)setNotifyWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;



@end
