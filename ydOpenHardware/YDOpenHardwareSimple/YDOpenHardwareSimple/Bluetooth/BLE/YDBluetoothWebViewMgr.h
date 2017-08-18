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

//蓝牙设备ID
@property (nonatomic, copy, readonly) NSString *deviceId;
//第三方标识名称
@property (nonatomic, copy, readonly) NSString *plugName;
//悦动圈用户id
@property (nonatomic, strong, readonly) NSNumber *userId;
//悦动圈提供的设备id
@property (nonatomic, copy, readonly) NSString *deviceIdentify;



@property (nonatomic, strong) WebViewJavascriptBridge *webViewBridge;

+ (instancetype)shared;

//scan peripheral
/*@method onScanPeripheral: onScanPeripheral which may scan with the default constraint condition ,when invoke this method ,you may invoke the scanPeripheralWithMatchInfo method (recommeded)
 *@method scanPeripheralWithDic: scanPeripheralWithDic which mainly for configure the constraint condition
 *@see YDBlueToothFilterType enum type which is & filter field
 *@see also scanPeripheralWithMatchInfo: which is configure the constraint condition
 @see also matchField,containField , prefixField, suffixField
 */
- (void)onScanPeripheral;
- (void)scanPeripheralWithDic:(NSDictionary *)dic;


- (void)scanPeripheralWithMatchInfo:(NSDictionary *)filterInfo;

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

//service callback
typedef void(^ServicesCallback)(NSArray<CBService *> *services);
@property (nonatomic, copy) ServicesCallback servicesCallBack;

// chacteristic callback
typedef void (^CharacteristicCallback)(CBCharacteristic *c);
@property (nonatomic, copy) CharacteristicCallback discoverCharacteristicCallback;
@property (nonatomic, copy) CharacteristicCallback updateValueCharacteristicCallBack;

@property (nonatomic, strong, readonly) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong, readonly) CBCharacteristic *readCharacteristic;

- (void)writeDataWithByte:(NSData*)data;

//set notify for the chacateristic which is need ,peripheral is the one which is chose
- (void)setNotifyWithCharacteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;
- (void)setNotifyWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;

// void (^)(bool flag)
typedef void(^BoolCallBack)(BOOL flag);
@property (nonatomic, copy) BoolCallBack connectStateCallback;

- (void)loadAnotherHTMLWithDatas:(id)datas;

@end
