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
#import "CBService+YYModel.h"
#import "NSData+YDConversion.h"
#import "YDConstants.h"
#import "SVProgressHUD.h"
#import "YDBluetoothWebViewMgr+Time.h"

//test
#import "YDBluetoothWebViewMgr+Extension.h"
#import "YDBluetoothWebViewMgr+ReadDatas.h"

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

@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
@property (nonatomic, strong) NSMutableArray *mCharacteristics;

//need write datas
@property (nonatomic, strong) NSMutableArray<NSData *> *needWriteDatas;

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
        [self __addNotify];
        [self __baseInit];
    }
    return self;
}

#pragma mark -- custom inner methods

- (void)__baseInit {
    _mCharacteristics = @[].mutableCopy;
    _needWriteDatas = @[].mutableCopy;
}

- (void)__addNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOpenHardwareUserChangeNotify:) name:YDNtfOpenHardwareUserChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidUpdateCharacteristicValueNotify:) name:YDNtfMangerDidUpdataValueForCharacteristic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDidUpdateNotificaitonStateForCharacteristicNotify:) name:YDNtfMangerDidUpdateNotificationStateForCharacteristic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDiscoverDescriptorsForCharacteristicNotify:) name:YDNtfMangerDiscoverDescriptorsForCharacteristic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReadValueForDescriptorsNotify:) name:YDNtfMangerReadValueForDescriptors object:nil];
    
}

- (void)__cacheCharacteristic:(CBCharacteristic *)c {
    if (_mCharacteristics.count <= 0 ){
        [_mCharacteristics addObject:c];
        return;
    }
    
    for (NSInteger index = 0; index < _mCharacteristics.count; index++) {
        CBCharacteristic *innerC = _mCharacteristics[index];
        if ([innerC.UUID.UUIDString isEqualToString:c.UUID.UUIDString]) {
//            for warning
//            [_mCharacteristics removeObject:innerC];
//            [_mCharacteristics insertObject:c atIndex:index];
            [_mCharacteristics replaceObjectAtIndex:index withObject:c];
            break;
        }else{
            if (index == (_mCharacteristics.count -1)) {
                [_mCharacteristics addObject:c];
            }
        }
    }
    
}

- (CBCharacteristic *)__patternCharacteristicWithUUIDString:(NSString *)uuidString {
    for (CBCharacteristic *innerC in _mCharacteristics) {
        if ([innerC.UUID.UUIDString isEqualToString:uuidString]) {
            return innerC;
        }
    }
    return nil;
}

- (void)scanPeripheralWithMatchInfo:(NSDictionary *)filterInfo {
    _btMgr = [YDBlueToothMgr shared];
    _btMgr.filterType = (YDBlueToothFilterType)[filterInfo[@"YDBlueToothFilterType"] integerValue];

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

- (void)reConnectLastPeripherl {
    
}

- (void)registerHandlersWithType:(NSUInteger)type {
    
//    for extension business extension
    [self registerExtension];
    
    __weak typeof (self) wSelf = self;
    
//    load the YDRegisterInteractiveHtmlMethods.plist register methods
     NSString *path =[[NSBundle mainBundle] pathForResource:@"YDRegisterInteractiveHtmlMethods" ofType:@"plist"];
    NSArray *methods = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *typeObj in methods) {
        if ([typeObj objectForKey:@"type"]) {
            for (NSString *methodString in [typeObj objectForKey:@"methods"]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:NSSelectorFromString(methodString)];
                #pragma clang diagnostic pop
            }
        }
    }
    
//    set the read & write characteristic
    [_webViewBridge registerHandler:@"writeCharacteristicWithUUIDString" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data && ![data isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD showInfoWithStatus:@"传入数据不可以为空"];
            return ;
        }
        NSString *uuidString = [data objectForKey:@"uuid"];
        if (uuidString.length <= 0) {
            [SVProgressHUD showInfoWithStatus:@"uuid 不可以为空"];
            return;
        }
        _writeCharacteristic = [self __patternCharacteristicWithUUIDString:uuidString];
        if (_writeCharacteristic) {
            !responseCallback?:responseCallback(@"设置成功");
        }else{
            !responseCallback?:responseCallback(@"设置失败");
        }
    }];
    
    [_webViewBridge registerHandler:@"readCharacteristicWithUUIDString" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data && ![data isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD showInfoWithStatus:@"传入数据不可以为空"];
            return ;
        }
        NSString *uuidString = [data objectForKey:@"uuid"];
        if (uuidString.length <= 0) {
            [SVProgressHUD showInfoWithStatus:@"uuid 不可以为空"];
            return;
        }
        _readCharacteristic = [self __patternCharacteristicWithUUIDString:uuidString];
        if (_readCharacteristic) {
            !responseCallback?:responseCallback(@"设置成功");
        }else{
            !responseCallback?:responseCallback(@"设置失败");
        }
    }];
    
//    for test bundle html
    [_webViewBridge registerHandler:@"onLoadHtmlByLink" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
    }];
    
    [_webViewBridge registerHandler:@"onScanClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data) {
            return ;
        }
        [wSelf scanPeripheralWithMatchInfo:data];
        [self loadAnotherHTMLWithDatas:data];
        wSelf.btMgr.startScan().scanPeripheralCallback = ^(CBPeripheral *peripheral) {
            [wSelf onAddToListWithPeripheral:peripheral];
        };
    }];
    
//    这个方法名也是需要加载的  （这里是触发链接&注册数据库）
    [_webViewBridge registerHandler:@"onConnectPeripheralClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data) {
//            [self loadAnotherHTMLWithDatas:data];
            _btMgr.stopScan().connectingPeripheralUuid(data);
            [wSelf.btMgr onConnectCurrentPeripheralOfBluetooth];
            wSelf.btMgr.connectionCallBack = ^(BOOL success) {
                __strong typeof (wSelf) strongSelf = wSelf;
                [strongSelf deliverConnectResultToHTmlWithResult:success];
                if (success) {
                    [strongSelf registerOpenHardWareWithPeripheral:_choicePeripheal];
                    [strongSelf backDatasFromBluetooth];
                }
            };
            _choicePeripheal = _btMgr.currentPeripheral;
            [[NSUserDefaults standardUserDefaults] setObject:_choicePeripheal.identifier.UUIDString forKey:@"peripheralUUID"];
        }
    }];
    
#pragma mark -- 数据存储操作method name  & data (key/value )
//    智能体称
    [_webViewBridge registerHandler:@"insertIntelligentScale" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertIntelligentScale:data];
        [self loadAnotherHTMLWithDatas:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewIntelligentScaleByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewIntelligentScaleByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectIntelligentScaleByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectIntelligentScaleByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectIntelligentScaleInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectIntelligentScaleInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
//    心率
    [_webViewBridge registerHandler:@"insertHeartRate" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertHeartRate:data];
        [self loadAnotherHTMLWithDatas:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewHeartRateByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewHeartRateByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectHeartRateByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectHeartRateByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectHeartRateInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectHeartRateInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
// 计步
    [_webViewBridge registerHandler:@"insertPedometer" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertPedometer:data];
        [self loadAnotherHTMLWithDatas:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewPedometerByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewPedometerByInfo:data completion:^(NSDictionary *dic) {
            if (dic) {
                [SVProgressHUD showInfoWithStatus:@"成功获取数据"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
            }
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectPedometerByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectPedometerByInfo:data completion:^(NSDictionary *dic) {
            if (dic) {
                [SVProgressHUD showInfoWithStatus:@"成功获取数据"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
            }
            responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectPedometerInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectPedometerInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
//    睡眠
    [_webViewBridge registerHandler:@"insertSleep" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf insertSleep:data];
    }];
    
    [_webViewBridge registerHandler:@"selectNewSleepByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewSleepByInfo:data completion:^(id idObj) {
            !responseCallback?:responseCallback(idObj);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectSleepByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectSleepByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [_webViewBridge registerHandler:@"selectSleepInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectSleepInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
//    write dats
    [_webViewBridge registerHandler:@"writeDatas" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *hexString = data[@"hexString"];
        NSData *writeDatas = [NSData dataWithHexString:hexString];
        [self loadAnotherHTMLWithDatas:data];
        if (wSelf.writeCharacteristic && writeDatas) {
            [wSelf.choicePeripheal writeValue:writeDatas forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    }];
    
    [_webViewBridge registerHandler:@"onWriteDatasClickByDictionay" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [self onAlarmClicked];
        NSLog(@"data : %@",data);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self writeDatasWithDictionay:data];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !responseCallback?:responseCallback(@{@"flag":@(YES)});
        });
    }];
    
}

- (void)writeDatasWithDictionay:(NSDictionary *)dic{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"传入的数据不是字典 dic; %@",dic);
        return;
    }
    
    NSString *value = [dic objectForKey:@"value"];
    if (value.length <= 0) {
        [SVProgressHUD showInfoWithStatus:@"传入的value 解析之后为空"];
        return;
    }

    NSData *data  = [NSData dataWithHexString:value];
    [self writeDatas:data];
}

- (void)writeDatas:(NSData *)datas {
    if (_writeCharacteristic) {
        [self.choicePeripheal writeValue:datas forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"写数据失败");
        [_needWriteDatas addObject:datas];
    }
}

- (void)backDatasFromBluetooth {
    __weak typeof (self) wSelf = self;
    _btMgr.servicesCallBack = ^(NSArray<CBService *> *services) {
        [wSelf onDeliverToHtmlWithServices:services];
    };

    _btMgr.characteristicCallBack = ^(CBCharacteristic *c) {
        [wSelf __cacheCharacteristic:c];
        if (c.value && c.UUID) {
            [wSelf onDeliverToHtmlWithCharateristic:c];
//            if ([c.UUID.UUIDString isEqualToString:@"FFF7"]) {
//                [wSelf.choicePeripheal readValueForCharacteristic:c];
//            }
        }
     };
}

// 写入那些需要写的数据而没有写的数据
- (void)__writeNeedWrittenDatas {
    if (_needWriteDatas.count == 0) {
        return;
    }
    
    for (NSData *data in _needWriteDatas) {
        [self writeDatas:data];
        [_needWriteDatas removeObject:data];
    }
}

- (void)isWriteCharacteristicWithC:(CBCharacteristic *)c UUIDString:(NSString *)uuidString {
    if ([c.UUID.UUIDString isEqualToString:uuidString]) {
        _writeCharacteristic = c;
    }else{
        
    }
}

- (void)deliverConnectResultToHTmlWithResult:(BOOL)result {
    __weak typeof (self) wSelf = self;
    [_webViewBridge callHandler:@"onConnectPeripheralResultBack" data:@{@"result":@(result)} responseCallback:^(id responseData) {
        [wSelf loadAnotherHTMLWithDatas:responseData];
    }];
}

- (void)onDeliverToHtmlWithServices:(NSArray<CBService *> *)services {
    id jsonObj = [services yy_modelToJSONObject];
    __weak typeof (self) wSelf = self;
    [_webViewBridge callHandler:@"onServicesResultBack" data:jsonObj responseCallback:^(id responseData) {
        [wSelf loadAnotherHTMLWithDatas:responseData];
    }];
}


- (void)loadAnotherHTMLWithDatas:(id)datas {
    if (![datas isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *toLink = (NSString *)[datas objectForKey:@"toLink"];
    if (toLink) {
        if (![toLink hasPrefix:@"http"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YDNtfLoadOutsideBundleHtml object:toLink];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:YDNtfLoadHtml object:toLink userInfo:nil];
        }
    }
}

// plist 文件加载数据格式
- (void)onDeliverToHtmlWithCharateristic:(CBCharacteristic *)c {
    Byte *resultP = (Byte *)[c.value bytes];
    //    数据格式需要进行加载，解析数据格式 （变化），这里应该是怎么读取的，有关的格式
    NSMutableDictionary *characteristicInfo = @{}.mutableCopy;
    [characteristicInfo setObject:c.UUID.UUIDString forKey:@"uuid"];
    NSMutableDictionary *valueInfo = @{}.mutableCopy;
    for (int index =0; index <c.value.length; index++) {
        NSString *key = [NSString stringWithFormat:@"value%d",index];
        NSString *value = [NSString stringWithFormat:@"0x%02X",resultP[index]];
        if (key && value) {
            [valueInfo setObject:value forKey:key];
        }
    }
    [characteristicInfo setObject:valueInfo forKey:@"value"];
    [_webViewBridge callHandler:@"onCharacteristicResultBack" data:characteristicInfo responseCallback:^(id responseData) {
        NSLog(@"oc got response data from js : %@",responseData);
    }];
}

#pragma mark --xx handler with html

- (void)onAddToListWithPeripheral:(CBPeripheral *)peripheral {
    if (peripheral.name && peripheral.identifier) {
//        NSDictionary *peripheralInfo = @{@"name":peripheral.name,@"uuid":peripheral.identifier.UUIDString};
        NSMutableDictionary *peripherlInfo = @{}.mutableCopy;
        peripherlInfo = [peripheral yy_modelToJSONObject];
        [peripherlInfo setObject:peripheral.identifier.UUIDString forKey:@"uuid"];
        [_webViewBridge callHandler:@"scanResultSingleBack" data:peripherlInfo responseCallback:^(id responseData) {
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

#pragma mark -- did updaet characteristic

- (void)onDidUpdateCharacteristicValueNotify:(NSNotification *)notificaiton {
    CBCharacteristic *c = notificaiton.object;
    NSLog(@"onDidUpdateCharacteristicValueNotify c: %@",c);
#warning  for test
    [self readByteWithData:c.value];
//    for test
    NSDictionary *jsonObj = [c convertToDictionary];
    [_webViewBridge callHandler:@"onDidUpdateCharacteristicValueNotify" data:jsonObj responseCallback:^(id responseData) {
        NSLog(@"notificaiton response characteristic value : %@",responseData);
    }];
}

- (void)onDidUpdateNotificaitonStateForCharacteristicNotify:(NSNotification *)notification {
    CBCharacteristic *c = notification.object;
    NSDictionary *jsonObj = [c convertToDictionary];
    NSLog(@"onDidUpdateNotificaitonStateForCharacteristicNotify :");
    [_webViewBridge callHandler:@"onNotificaitonStateForCharacteristicNotify" data:jsonObj responseCallback:^(id responseData) {
        NSLog(@"notificaiton response characteristic :%@",responseData);
    }];
}

- (void)onDiscoverDescriptorsForCharacteristicNotify:(NSNotification *)notification {
    CBCharacteristic *c =  notification.object;
    NSDictionary *jsonObj = [c convertToDictionary];
    [_webViewBridge callHandler:@"onDiscoverDescriptorsForCharacteristicNotify" data:jsonObj responseCallback:^(id responseData) {
        NSLog(@"notification response descriptors for characteristic : %@",responseData);
    }];
}

- (void)onReadValueForDescriptorsNotify:(NSNotification *)notificaiton {
    CBDescriptor *desc = notificaiton.object;
    NSMutableDictionary * jsonObj = @{}.mutableCopy;
    [jsonObj setObject:desc.UUID.UUIDString forKey:@"uuid"];
    if (desc.value) {
        [jsonObj setObject:[NSString stringWithFormat:@"%@",desc.value] forKey:@"value"];
    }
    [_webViewBridge callHandler:@"onReadValueForDescriptorsNotify" data:jsonObj responseCallback:^(id responseData) {
        NSLog(@"notificaiton response descriptors notify : %@",notificaiton);
    }];
}

#pragma mark 体重秤

- (void)insertIntelligentScale:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    YDOpenHardwareIntelligentScale *intelligentScale = [YDOpenHardwareIntelligentScale new];
    intelligentScale = [YDOpenHardwareIntelligentScale yy_modelWithDictionary:infoDic];
    intelligentScale.deviceId = _deviceIdentify;
    intelligentScale.timeSec?nil:(intelligentScale.timeSec =[NSDate date]);
    intelligentScale.weightG?nil:(intelligentScale.weightG = @0);
    intelligentScale.heightCm?nil:(intelligentScale.heightCm = @0);
    intelligentScale.bodyFatPer?nil:(intelligentScale.bodyFatPer = @0);
    intelligentScale.bodyMusclePer?nil:(intelligentScale.bodyMusclePer = @0);
    intelligentScale.bodyMassIndex?nil:(intelligentScale.bodyMassIndex = @0);
    intelligentScale.basalMetabolismRate?nil:(intelligentScale.basalMetabolismRate = @0);
    intelligentScale.bodyWaterPercentage?nil:(intelligentScale.bodyWaterPercentage = @0);
    intelligentScale.userId = _userId;
    intelligentScale.extra?nil:(intelligentScale.extra = @"");
    intelligentScale.serverId?nil:(intelligentScale.serverId = @0);
    intelligentScale.status?nil:(intelligentScale.status = @0);
    [[YDOpenHardwareManager dataProvider] insertIntelligentScale:intelligentScale completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入体重秤数据成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"插入体重秤数据失败"];
        }
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
    hr.deviceId = _deviceIdentify;
    hr.heartRate?nil:(hr.heartRate = @0);
    hr.startTime?nil:(hr.startTime =[NSDate date]);
    hr.endTime?nil:(hr.endTime = [NSDate date]);
    hr.userId = _userId;
    hr.extra?nil:(hr.extra = @"");
    hr.serverId?nil:(hr.serverId = @0);
    hr.status?nil:(hr.status = @0);
    [[YDOpenHardwareManager dataProvider] insertHeartRate:hr completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入心率成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"插入心率失败"];
        }
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
    NSNumber *userId = _userId;
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectHeartRateByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime completion:^(BOOL success, NSArray<YDOpenHardwareHeartRate *> *heartRates) {
            !responseJsonObject?:responseJsonObject([heartRates yy_modelToJSONObject]);
        }];
    }];
}

- (void)selectHeartRateInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }

    NSString *deviceIdentify = _deviceIdentify;
    NSNumber *userId = _userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectHeartRateByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareHeartRate *> *heartRates) {
            !responseJsonObject?:responseJsonObject([heartRates yy_modelToJSONObject]);
        }];
    }];
}

#pragma mark 计步

- (void)insertPedometer:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //    test datas must deliver from the html :note some params(datas must not be nil)
    YDOpenHardwarePedometer *pe = [YDOpenHardwarePedometer yy_modelWithDictionary:infoDic];
    pe.deviceId = _deviceIdentify;
    pe.userId = [[YDOpenHardwareManager sharedManager] getCurrentUser].userID;
    !pe.startTime?(pe.startTime = [NSDate date]):nil;
    !pe.endTime?(pe.endTime = [NSDate date]):nil;
    !pe.extra?(pe.extra = @""):nil;
    !pe.distance?(pe.distance = @0):nil;
    !pe.calorie?(pe.calorie =@0):nil;
    !pe.extra?(pe.extra = @""):nil;
    !pe.serverId?(pe.serverId = @0):nil;
    !pe.status?(pe.status = @0):nil;
    !pe.numberOfStep?(pe.numberOfStep = @0):nil;

    [[YDOpenHardwareManager dataProvider] insertPedometer:pe completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入计步成功"];
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"插入计步失败"];
        }
    }];
}

- (void)selectNewPedometerByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
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
    NSNumber *userId = _userId;
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectPedometerByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime completion:^(BOOL success, NSArray<YDOpenHardwarePedometer *> *pedometers) {
            if (success) {
                [SVProgressHUD showInfoWithStatus:@"成功"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"失败"];
            }
            !responseJsonObject?:responseJsonObject([pedometers yy_modelToJSONObject]);
        }];
    }];
}

- (void)selectPedometerInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSNumber *userId = _userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectPedometerByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwarePedometer *> *pedometers) {
            !responseJsonObject?:responseJsonObject([pedometers yy_modelToJSONObject]);
        }];
    }];

}

#pragma mark 睡眠

- (void)insertSleep:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    YDOpenHardwareSleep *sleep = [YDOpenHardwareSleep yy_modelWithDictionary:infoDic];
    sleep.deviceId = _deviceIdentify;
    sleep.sleepSec?nil:(sleep.sleepSec = @0);
    sleep.sleepSection?nil:(sleep.sleepSection = @0);
    sleep.startTime?nil:(sleep.startTime = [NSDate date]);
    sleep.endTime?nil:(sleep.endTime = [NSDate date]);
    sleep.userId = _userId;
    sleep.extra?nil:(sleep.extra = @"");
    sleep.serverId?nil:(sleep.serverId = @0);
    sleep.status?nil:(sleep.status = @0);
    [[YDOpenHardwareManager dataProvider] insertSleep:sleep completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入睡眠数据成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"插入睡眠数据失败"];
        }
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
    NSNumber *userId = _userId;
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectSleepByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime completion:^(BOOL success, NSArray<YDOpenHardwareSleep *> *sleeps) {
            if (success) {
                !responseJsonObject?:responseJsonObject([sleeps yy_modelToJSONObject]);
            }
        }];
    }];
}

- (void)selectSleepInPageByInfo:(id)infoDic completion:(ResponseJsonObject)reponseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = _deviceIdentify;
    NSNumber *userId = _userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectSleepByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareSleep *> *sleeps) {
            if (success) {
                !reponseJsonObject?:reponseJsonObject([sleeps yy_modelToJSONObject]);
            }
        }];
    }];
}

@end
