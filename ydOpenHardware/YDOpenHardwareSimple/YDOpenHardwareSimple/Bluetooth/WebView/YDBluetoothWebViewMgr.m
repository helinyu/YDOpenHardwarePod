//
//  YDBluetoothWebViewMgr.m
//  SportsBar
//
//  Created by Aka on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YDBluetoothWebViewMgr.h"
#import "YDBlueToothMgr.h"
#import "YDBridgeWebMgr.h"
#import "WebViewJavascriptBridge.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YYModel.h"

#import <YDOpenHardwareSDK/YDOpenHardwareManager.h>
#import <YDOpenHardwareSDK/YDOpenHardwareDataProvider.h>
#import <YDOpenHardwareSDK/YDOpenHardwareIntelligentScale.h>
#import <YDOpenHardwareSDK/YDOpenHardwareHeartRate.h>
#import <YDOpenHardwareSDK/YDOpenHardwareSDK.h>

@interface YDBluetoothWebViewMgr ()

// openHardware

//蓝牙设备ID
@property (nonatomic, copy) NSString *deviceId;
//第三方标识名称
@property (nonatomic, copy) NSString *plugName;
//悦动圈用户id
@property (nonatomic, strong) NSNumber *userId;
//悦动圈提供的设备id
@property (nonatomic, copy) NSString *deviceIdentify;

//to caculate the datas read from bluetooth
@property (nonatomic, assign) NSInteger lastStepNum;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger calorie;
@property (nonatomic, assign) CGFloat disM;
@property (nonatomic, assign) BOOL isFirstReload;

@property (nonatomic, strong) YDBlueToothMgr *btMgr;

//mark
@property (nonatomic, strong) CBPeripheral *choicePeripheal;
@property (nonatomic, assign) NSInteger choiceIndex;

@end

@implementation YDBluetoothWebViewMgr

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _addNotify];
    }
    return self;
}

- (void)_addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOpenHardwareUserChangeNotify:) name:YDNtfOpenHardwareUserChange object:nil];
}

- (void)scanPeripheralWithMatchInfo:(NSDictionary *)filterInfo {
    _btMgr = [YDBlueToothMgr shared];
    _btMgr.filterType = (YDBlueToothFilterType)filterInfo[@"YDBlueToothFilterType"];

    switch (_btMgr.filterType) {
        case YDBlueToothFilterTypeNone:
            break;
        case YDBlueToothFilterTypeMatch:
            _btMgr.matchField = filterInfo[@"matchField"];
            break;
        case YDBlueToothFilterTypeContain:
            _btMgr.containField = filterInfo[@"containField"];
            break;
        case YDBlueToothFilterTypePrefix:
            _btMgr.prefixField = filterInfo[@"prefixField"];
            break;
        case YDBlueToothFilterTypeSuffix:
            _btMgr.suffixField = filterInfo[@"suffixField"];
            break;
        case YDBlueToothFilterTypePrefixAndSuffix:
        {
            _btMgr.prefixField = filterInfo[@"prefixField"];
            _btMgr.suffixField = filterInfo[@"suffixField"];
        }
            break;
        case YDBlueToothFilterTypePrefixAndContain:
        {
            _btMgr.prefixField = filterInfo[@"prefixField"];
            _btMgr.containField = filterInfo[@"containField"];
        }
            break;
        case YDBlueToothFilterTypeSuffixAndContrain:
        {
            _btMgr.suffixField = filterInfo[@"suffixField"];
            _btMgr.containField = filterInfo[@"containField"];
        }
            break;
        case YDBlueToothFilterTypePrefixAndContrainAndSuffix:
        {
            _btMgr.prefixField = filterInfo[@"prefixField"];
            _btMgr.containField = filterInfo[@"containField"];
            _btMgr.suffixField = filterInfo[@"suffixField"];
        }
            break;
        default:
            break;
    }
    
}

- (void)startScanThenSourcesCallback:(void(^)(NSArray *peirpherals))callback {
    _btMgr.scanCallBack = ^(NSArray<CBPeripheral *> *peripherals) {
        !callback?:callback(peripherals);
    };
    _btMgr.startScan();
}

- (void)registerHandlers {

    //plist 文件加入 、方法名，参数
    __weak typeof (self) wSelf = self;
//    这方法是固定的
    [_webViewBridge registerHandler:@"onScanClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data) {
            return ;
        }
        [wSelf scanPeripheralWithMatchInfo:data];
//        跳转链接是后来处理的
        [self reloadWithUrl:@"peripheralList.html"];
        wSelf.btMgr.startScan().scanPeripheralCallback = ^(CBPeripheral *peripheral) {
//           处理返回来的数据（一般是列表）
            [wSelf onAddToS3ListWithPeripheral:peripheral];
        };
    }];
    
//    这个方法名也是需要加载的  （这里是触发链接&注册数据库）
    [_webViewBridge registerHandler:@"onTouchPeripheral" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data) {
            _btMgr.stopScan().connectingPeripheralUuid(data);
            [wSelf.btMgr onConnectCurrentPeripheralOfBluetooth];
            _choicePeripheal = _btMgr.currentPeripheral;
            [[NSUserDefaults standardUserDefaults] setObject:_choicePeripheal.identifier.UUIDString forKey:@"peripheralUUID"];
            [[NSUserDefaults standardUserDefaults] setObject:_choicePeripheal forKey:@"choicePeripheral"];
            wSelf.btMgr.connectionCallBack = ^(BOOL success) {
                if (success) {
                    [wSelf registerOpenHardWareWithPeripheral:_choicePeripheal];
                    [wSelf backDatasFromBluetooth];
                }
            };
        }
    }];
    
#pragma mark -- 数据存储操作method name  & data (key/value )
//    智能体称
    [_webViewBridge registerHandler:@"insertIntelligentScale" handler:^(id data, WVJBResponseCallback responseCallback) {
            [wSelf insertIntelligentScale:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewIntelligentScaleByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectNewIntelligentScaleByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectIntelligentScaleByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectIntelligentScaleByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectIntelligentScaleInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectIntelligentScaleInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
//    心率
    [_webViewBridge registerHandler:@"insertHeartRate" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertHeartRate:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewHeartRateByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectNewHeartRateByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectHeartRateByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectHeartRateByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectHeartRateInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectHeartRateInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
// 计步
    [_webViewBridge registerHandler:@"insertPedometer" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"peri state : %ld",_choicePeripheal.state);
        [wSelf insertPedometer:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewPedometerByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectNewPedometerByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectPedometerByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectPedometerByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectPedometerInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectPedometerInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
//    睡眠
    [_webViewBridge registerHandler:@"insertSleep" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertSleep:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewSleepByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectNewSleepByInfo:data completion:^(id idObj) {
            !responseCallback?:responseCallback(idObj);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectSleepByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectSleepByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    [_webViewBridge registerHandler:@"selectSleepInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectSleepInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
//   注入通知
//    [_webViewBridge registerHandler:@"onNotificationSource" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"9FBF120D-6301-42D9-8C58-25E699A21DBD"];
//        NSData *uuidDatas = [uuid.UUIDString dataUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"uudi Datas length : %lu",(unsigned long)uuidDatas.length);
//        Byte *uuidBytes = (Byte *)[uuidDatas bytes];
//        NSData *writeDatas;
//        Byte writeBytes[] = {0x00,0x10,0x01,0x03,uuidBytes[0],uuidBytes[1],uuidBytes[2],uuidBytes[3]};
//
//        writeDatas = [[NSData alloc] initWithBytes:writeBytes length:8];
    
//    设置监听

    
}

- (void)reloadWithUrl:(NSString *)string {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yd.readload.html" object:string userInfo:nil];
}

- (void)backDatasFromBluetooth {
    __weak typeof (self) wSelf = self;
    _btMgr.servicesCallBack = ^(NSArray<CBService *> *services) {
        
    };

    _btMgr.characteristicCallBack = ^(CBCharacteristic *c) {
        if (c.value && c.UUID) {
            [wSelf onDeliverToHtmlWithCharateristic:c];
          }
     };
}

// plist 文件加载数据格式
- (void)onDeliverToHtmlWithCharateristic:(CBCharacteristic *)c {
    Byte *resultP = (Byte *)[c.value bytes];
//    数据格式需要进行加载，解析数据格式 （变化），这里应该是怎么读取的，有关的格式
    NSString *value0 = [NSString stringWithFormat:@"0x%02X",resultP[0]];
    NSString *value1 = [NSString stringWithFormat:@"0x%02X",resultP[1]];
    NSString *value2 = [NSString stringWithFormat:@"0x%02X",resultP[2]];
    NSString *value3 = [NSString stringWithFormat:@"0x%02X",resultP[3]];
    if ((value0 !=nil) && (value1 !=nil) && (value2 !=nil) && (value3 !=nil) && (c.UUID.UUIDString.length >0)) {
        NSDictionary *characteristicInfo = @{@"uuid":c.UUID.UUIDString,
                                             @"value":@{
                                                     @"value0":value0,
                                                     @"value1":value1,
                                                     @"value2":value2,
                                                     @"value3":value3
                                                     }
                                             };
//        这个方法可以是写死的
        [_webViewBridge callHandler:@"deliverCharacteristic" data:characteristicInfo responseCallback:^(id responseData) {
            NSLog(@"response data : %@",responseData);
        }];
     }
}

#pragma mark --xx handler with html

- (void)onAddToS3ListWithPeripheral:(CBPeripheral *)peripheral {
    if (peripheral.name && peripheral.identifier) {
//        返回去的参数，这个需要进行加载
        NSDictionary *peripheralInfo = @{@"name":peripheral.name,@"uuid":peripheral.identifier.UUIDString};
        [_webViewBridge callHandler:@"insertPeripheralInHtml" data:peripheralInfo responseCallback:^(id responseData) {
            NSLog(@"response datas from html : %@",responseData);
        }];
    }
}

#pragma mark -- on action by vc

- (void)onActionByViewDidDisappear {

    if (_btMgr) {
        _btMgr.quitConnected().stopScan();
    }
}

- (void)onActionByViewDidAppear {
    _choicePeripheal = [[NSUserDefaults standardUserDefaults] objectForKey:@"choicePeripheral"];
    if (_choicePeripheal) {
        if (!_btMgr) {
            _btMgr = [YDBlueToothMgr shared];
        }
        [_btMgr onConnectBluetoothWithPeripheral:_choicePeripheal];
    }

}

#pragma mark -- link to openHardware to datas caches

- (void)registerOpenHardWareWithPeripheral:(CBPeripheral *)peripheral {
    //   蓝牙连接成功了之后，就会注册数据库
    //是否注册
    _deviceId = peripheral.identifier.UUIDString;
    _plugName = peripheral.name;
    _userId = [[YDOpenHardwareManager sharedManager] getCurrentUser].userID;
    __weak typeof (self) wSelf = self;
    [[YDOpenHardwareManager sharedManager] isRegistered:_deviceId plug:_plugName user:_userId block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity) {
        BOOL flag = operateState == YDOpenHardwareOperateStateHasRegistered;
        NSString *msg = @"";
        if (flag) {
            msg = @"已经注册";
            wSelf.deviceIdentify = deviceIdentity;
        } else {
            msg = @"没有注册";
            //绑定硬件设备后需要向悦动圈注册设备
            [[YDOpenHardwareManager sharedManager] registerDevice:wSelf.deviceId plug:wSelf.plugName user:wSelf.userId  block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity, NSNumber *userId) {
                if (operateState == 0) {
                    wSelf.deviceIdentify = deviceIdentity;
                }
            }];
        }
    }];

}

- (void)onOpenHardwareUserChangeNotify:(NSNotification *)notification{

    //    解绑悦动圈（切换账号的时候）
    [[YDOpenHardwareManager sharedManager] unRegisterDevice:_deviceIdentify plug:self.plugName user:_userId block:^(YDOpenHardwareOperateState operateState) {
        if (operateState == YDOpenHardwareOperateStateSuccess) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastInsertStepsS3"];
        }else{
            NSLog(@"解除绑定失败");
        }
    }];
}

#pragma mark 体重秤

- (void)insertIntelligentScale:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [[YDOpenHardwareManager dataProvider] insertIntelligentScale:[infoDic yy_modelToJSONObject] completion:^(BOOL success) {
        
    }];

}

- (void)selectNewIntelligentScaleByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentity = _deviceIdentify;
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectNewSleepByDeviceIdentity:deviceIdentity userId:userId completion:^(BOOL success, YDOpenHardwareSleep *ohModel) {
        if (success) {
            !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
        }
    }];
}

- (void)selectIntelligentScaleByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectIntelligentScaleByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate completion:^(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *scales) {
        !responseJsonObject?:responseJsonObject([scales yy_modelToJSONObject]);
    }];
}

- (void)selectIntelligentScaleInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = _userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [[YDOpenHardwareManager dataProvider] selectIntelligentScaleByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *scales) {
        !responseJsonObject?:responseJsonObject([scales yy_modelToJSONObject]);
    }];
}

#pragma mark 心率

- (void)insertHeartRate:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    YDOpenHardwareHeartRate *hr = [YDOpenHardwareHeartRate yy_modelWithDictionary:infoDic];
    [[YDOpenHardwareManager dataProvider] insertHeartRate:hr completion:^(BOOL success) {
        
    }];
}

- (void)selectNewHeartRateByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectNewHeartRateByDeviceIdentity:deviceIdentify userId:userId completion:^(BOOL success, YDOpenHardwareHeartRate *ohModel) {
        !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
    }];
}

- (void)selectHeartRateByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSDate *dateTime = infoDic[@"dateTime"];
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectHeartRateByDeviceIdentity:deviceIdentify timeSec:dateTime userId:userId betweenStart:dateTime end:dateTime completion:^(BOOL success, NSArray<YDOpenHardwareHeartRate *> *heartRates) {
        !responseJsonObject?:responseJsonObject([heartRates yy_modelToJSONObject]);
    }];
}

- (void)selectHeartRateInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }

    NSString *deviceIdentify = _deviceIdentify;
    NSDate *dateTime = infoDic[@"dateTime"];
    NSNumber *userId = _userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [[YDOpenHardwareManager dataProvider] selectHeartRateByDeviceIdentity:deviceIdentify timeSec:dateTime userId:userId betweenStart:dateTime end:dateTime pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareHeartRate *> *heartRates) {
        !responseJsonObject?:responseJsonObject([heartRates yy_modelToJSONObject]);
    }];
}


#pragma mark 计步

- (void)insertPedometer:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
//    test datas must deliver from the html
    YDOpenHardwarePedometer *pedometer = [YDOpenHardwarePedometer yy_modelWithDictionary:infoDic];
    pedometer.deviceId = _deviceIdentify;
    pedometer.userId = [[YDOpenHardwareManager sharedManager] getCurrentUser].userID;
    pedometer.startTime = pedometer.endTime = [NSDate date];
    pedometer.startTime?(pedometer.startTime = [NSDate date]):nil;
    pedometer.endTime?(pedometer.endTime = [NSDate date]):nil;

    [[YDOpenHardwareManager dataProvider] insertPedometer:pedometer completion:^(BOOL success) {
        if (success) {
            NSLog(@"插入成功");
        }
        else{
            NSLog(@"插入失败");
        }
        
    }];
}

- (void)selectNewPedometerByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectNewPedometerByDeviceIdentity:deviceIdentify userId:userId completion:^(BOOL success, YDOpenHardwarePedometer *ohModel) {
        !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
    }];
}

- (void)selectPedometerByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }

    NSString *deviceIdentify = _deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectPedometerByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate completion:^(BOOL success, NSArray<YDOpenHardwarePedometer *> *pedometers) {
        !responseJsonObject?:responseJsonObject([pedometers yy_modelToJSONObject]);
    }];
}

- (void)selectPedometerInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = _userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [[YDOpenHardwareManager dataProvider] selectPedometerByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwarePedometer *> *pedometers) {
        !responseJsonObject?:responseJsonObject([pedometers yy_modelToJSONObject]);
    }];
}

#pragma mark 睡眠

- (void)insertSleep:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    YDOpenHardwareSleep *sleep = [YDOpenHardwareSleep yy_modelWithDictionary:infoDic];
    [[YDOpenHardwareManager dataProvider] insertSleep:sleep completion:^(BOOL success) {
//
    }];
}

- (void)selectNewSleepByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *deviceIdentify = _deviceIdentify;
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectNewSleepByDeviceIdentity:deviceIdentify userId:userId completion:^(BOOL success, YDOpenHardwareSleep *ohModel) {
        if (success) {
            !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
        }
    }];
}

- (void)selectSleepByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = _userId;
    [[YDOpenHardwareManager dataProvider] selectSleepByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate completion:^(BOOL success, NSArray<YDOpenHardwareSleep *> *sleeps) {
        if (success) {
            !responseJsonObject?:responseJsonObject([sleeps yy_modelToJSONObject]);
        }
    }];
}

- (void)selectSleepInPageByInfo:(id)infoDic completion:(ResponseJsonObject)reponseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *deviceIdentify = _deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = _userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [[YDOpenHardwareManager dataProvider] selectSleepByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareSleep *> *sleeps) {
        if (success) {
            !reponseJsonObject?:reponseJsonObject([sleeps yy_modelToJSONObject]);
        }
    }];
}

@end
