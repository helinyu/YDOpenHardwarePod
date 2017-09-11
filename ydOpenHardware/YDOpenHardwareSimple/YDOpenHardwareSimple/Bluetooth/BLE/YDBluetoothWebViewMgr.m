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
#import "CBService+YYModel.h"
#import "NSData+YDConversion.h"
#import "YDConstants.h"
#import "YDBluetoothWebViewMgr+Time.h"
#import "SVProgressHUD.h"
#import "YDBluetoothWebViewMgr+WriteDatas.h"
#import "YDBluetoothWebViewMgr+ReadDatas.h"
#import "YDBluetoothWebViewMgr+Extension.h"
#import "YDBluetoothWebViewMgr+ReadDatas.h"
#import <YDOpenHardwareSDK/YDOpenHardwareSDK.h>
#import "YDBluetoothWebViewMgr+DB.h"
#import "YDBluetoothWebViewMgr+Tel.h"

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

//mark
@property (nonatomic, strong) CBPeripheral *choicePeripheal;
@property (nonatomic, assign) NSInteger choiceIndex;

@property (nonatomic, strong) NSMutableArray *mCharacteristics;

@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;

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

- (void)connectDefaultPeirpheal {
    [_btMgr connectingPeripheral];
}

- (void)quitConnectedWithDatasDic:(id)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *uuidString = [info objectForKey:@"uuid"];
        if (uuidString.length >0) {
            CBPeripheral *peripehral = [_btMgr obtainPeripheralWithUUIDString:uuidString];
            if (peripehral) {
                [self cancelConnectedPeripheralWithPeripheal:peripehral];
                return;
            }
        }else{
            [self cancelConnectPeripheal];
        }
    }else{
        [self cancelConnectPeripheal];
    }
}

- (void)cancelConnectPeripheal {
    [_btMgr quitConnected];
}
- (void)cancelConnectedPeripheralWithPeripheal:(CBPeripheral *)peripheal {
    _btMgr.quitConnectedPeripheal(peripheal);
}

- (void)startScanThenSourcesCallback:(void(^)(NSArray *peirpherals))callback {
    _btMgr.scanCallBack = ^(NSArray<CBPeripheral *> *peripherals) {
        !callback?:callback(peripherals);
    };
    _btMgr.startScan();
}

- (void)startScanThenNewPeripheralCallback:(void(^)(CBPeripheral *peripheral))peripheralCallback {
    _btMgr.scanPeripheralCallback = ^(CBPeripheral *peripheral) {
        !peripheralCallback?:peripheralCallback(peripheral);
    };
    _btMgr.startScan();
}

#pragma mark -- register method for interactive in html with person

- (void)registerHandlersWithType:(NSUInteger)type {
    
    [self registerDBHandles];
    [self registerExtension];
    [self initTelCallHandle];
//    [self loadPlistRegisterMethods];
    __weak typeof (self) wSelf = self;

    //write data
    [_webViewBridge registerHandler:@"onFindWriteCharacteristicWithUUIDString" handler:^(id data, WVJBResponseCallback responseCallback) {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_writeCharacteristic) {
#warning for test & can delete
                [self writeBaseDatas];
                responseCallback(@{@"flag":@(YES)});
            }else{
                responseCallback(@{@"flag":@(NO)});
            }
        });

    }];
    
//     read datas from characteristic
    [_webViewBridge registerHandler:@"onFindReadCharacteristicWithUUIDString" handler:^(id data, WVJBResponseCallback responseCallback) {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_readCharacteristic) {
                responseCallback(@{@"flag":@(YES)});
            }else{
                responseCallback(@{@"flag":@(NO)});
            }
        });
        
        [wSelf setNotifyWithCharacteristic:_readCharacteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
            !wSelf.updateValueCharacteristicCallBack?:wSelf.updateValueCharacteristicCallBack(characteristics);
#warning  change & can be delete for release
            [wSelf readByteWithData:characteristics.value];
        }];

    }];
    
    [_webViewBridge registerHandler:@"onScan" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data) {
            return ;
        }
        [self loadAnotherHTMLWithDatas:data];
        [self scanPeripheralWithDic:data];
    }];
    
    [_webViewBridge registerHandler:@"onConnectPeripheral" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data) {
            NSLog(@"please data must not be null");
            return ;
        }
        [self stopScan];
        __weak typeof (self) wSelf = self;
        [self connectPeripheralWithDic:data callback:^(BOOL flag) {
            [wSelf deliverConnectResultToHTmlWithResult:flag];
        }];
        responseCallback(@{});
    }];
    
    [_webViewBridge registerHandler:@"quitConnectClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf quitConnectedWithDatasDic:data];
        responseCallback(nil);
    }];

    
    [_webViewBridge registerHandler:@"writeDatas" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *hexString = data[@"hexString"];
        NSData *writeDatas = [NSData dataWithHexString:hexString];
        [self loadAnotherHTMLWithDatas:data];
        if (wSelf.writeCharacteristic && writeDatas) {
            [wSelf.choicePeripheal writeValue:writeDatas forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    }];
    
    [_webViewBridge registerHandler:@"onWriteDatasClickByDictionay" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"data : %@",data);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self writeDatasWithDictionay:data];
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !responseCallback?:responseCallback(@{@"flag":@(YES)});
        });
    }];
    
}

#pragma mark -- bluetooth

//scan
- (void)scanPeripheralWithDic:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self scanPeripheralWithMatchInfo:dic];
    [self onScanPeripheral];
}

- (void)onScanPeripheral {
    __weak typeof (self) wSelf = self;
    self.btMgr.startScan().scanPeripheralCallback = ^(CBPeripheral *peripheral) {
        [wSelf onDeliverToHtmlWithScanPeripheral:peripheral];
    };
}

- (void)stopScan {
    _btMgr.stopScan();
}

//connect
- (void)connectPeripheralWithDic:(NSDictionary *)dic callback:(BoolCallBack)connectCallback {
    if (![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"dic format must be key/value");
        return;
    }
    
    NSString *uuidString = [dic objectForKey:@"uuid"];
    if (uuidString.length <= 0) {
        NSLog(@"uuid value lenght must larger the 0");
        return;
    }
    
    CBPeripheral *currentPeripheral = [_btMgr obtainPeripheralWithUUIDString:uuidString];
    if (!currentPeripheral) {
        NSLog(@"this peripheral is not in the peripherals which we has found");
        return;
    }
    [self connectPeripheralWithPeripheral:currentPeripheral callback:connectCallback];
}

- (void)connectPeripheralWithPeripheral:(CBPeripheral *)peripheral callback:(BoolCallBack)connectCallback{
    _choicePeripheal = peripheral;
    [[NSUserDefaults standardUserDefaults] setObject:_choicePeripheal.identifier.UUIDString forKey:@"peripheralUUID"];
    [self connectPeripheralThenConnectStateCallback:connectCallback];
}

//新的
- (void)connectPeripheralThenConnectStateCallback:(BoolCallBack)connectFlagCallback {
    if (!_choicePeripheal) {
        NSLog(@"must choice a peripheral or this peripheral is not found");
        return;
    }
    
    CBPeripheral *peripheral = _choicePeripheal;
    __weak typeof (self) wSelf = self;
    _btMgr.connectionCallBack = ^(BOOL success) {
        !connectFlagCallback?:connectFlagCallback(success);
        
        __strong typeof (wSelf) strongSelf = wSelf;
        !strongSelf.connectStateCallback?:strongSelf.connectStateCallback(success);
        if (success) {
            [strongSelf registerOpenHardWareWithPeripheral:peripheral];
            [strongSelf registerDatasFromBluetoothCallback];
        }
    };
    _btMgr.willBeConnetPeiripheral(peripheral).connectingCurrentPeripheral();
}

#pragma mark -- other mathods

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

#pragma mark -- load the plist methods which we can write in the mgr extesion file
- (void)loadPlistRegisterMethods {
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
}


#pragma mark -- deal with datas

- (void)writeDatas:(NSData *)datas {
    if (_writeCharacteristic) {
        [self.choicePeripheal writeValue:datas forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }else{
        NSLog(@"写数据失败");
        [_needWriteDatas addObject:datas];
    }
}

//datas from ble
- (void)registerDatasFromBluetoothCallback {
    __weak typeof (self) wSelf = self;
    
    _btMgr.servicesCallBack = ^(NSArray<CBService *> *services) {
        !wSelf.servicesCallBack?:wSelf.servicesCallBack(services);
        [wSelf onDeliverToHtmlWithServices:services];
    };
    
    _btMgr.updateValueCharacteristicCallBack = ^(CBCharacteristic *c) {
        !wSelf.updateValueCharacteristicCallBack?:wSelf.updateValueCharacteristicCallBack(c);
        if (c.value && c.UUID) {
            [wSelf onDeliverToHtmlWithCharateristic:c];
        }
    };
    
    _btMgr.discoverCharacteristicCallback = ^(CBCharacteristic *c) {
        !wSelf.discoverCharacteristicCallback?:wSelf.discoverCharacteristicCallback(c);
        [wSelf __cacheCharacteristic:c];
        if (c.value && c.UUID) {
            [wSelf onDeliverToHtmlWithCharateristic:c];
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
    [_webViewBridge callHandler:@"onConnectPeripheralResult" data:@{@"result":@(result)} responseCallback:^(id responseData) {
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

#pragma mark -- deliver to html

- (void)onDeliverToHtmlWithServices:(NSArray<CBService *> *)services {
    id jsonObj = [services yy_modelToJSONObject];
    __weak typeof (self) wSelf = self;
    [_webViewBridge callHandler:@"onServicesResultBack" data:jsonObj responseCallback:^(id responseData) {
        [wSelf loadAnotherHTMLWithDatas:responseData];
    }];
}

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
    [_webViewBridge callHandler:@"onCharacteristicResult" data:characteristicInfo responseCallback:^(id responseData) {
        NSLog(@"oc got response data from js : %@",responseData);
    }];
}

- (void)onDeliverToHtmlWithScanPeripheral:(CBPeripheral *)peripheral {
    if (peripheral.name && peripheral.identifier) {
        NSMutableDictionary *peripherlInfo = @{}.mutableCopy;
        peripherlInfo = [peripheral yy_modelToJSONObject];
        [peripherlInfo setObject:peripheral.identifier.UUIDString forKey:@"uuid"];
        [_webViewBridge callHandler:@"onScanPeripheralResult" data:peripherlInfo responseCallback:^(id responseData) {
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

#pragma mark -- did updaet characteristic

- (void)onDidUpdateCharacteristicValueNotify:(NSNotification *)notificaiton {
    CBCharacteristic *c = notificaiton.object;
    NSLog(@"onDidUpdateCharacteristicValueNotify c: %@",c);
    NSDictionary *jsonObj = [c convertToDictionary];
    [_webViewBridge callHandler:@"onDidUpdateCharacteristicValueNotify" data:jsonObj responseCallback:^(id responseData) {
        NSLog(@"notificaiton response characteristic value : %@",responseData);
    }];
}

- (void)onDidUpdateNotificaitonStateForCharacteristicNotify:(NSNotification *)notification {
    CBCharacteristic *c = notification.object;
    NSLog(@"onDidUpdateNotificaitonStateForCharacteristicNotify c: %@:",c);
    NSDictionary *jsonObj = [c convertToDictionary];
    [_choicePeripheal readValueForCharacteristic:c];
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


#pragma mark -- custom methods

- (CBPeripheral *)obtainPeripheralWithUUIDString:(NSString *)uuidString {
    return [_btMgr obtainPeripheralWithUUIDString:uuidString];
}

- (void)writeDataWithByte:(NSData*)data {
    if (_choicePeripheal != nil && _writeCharacteristic != nil) {
        [_choicePeripheal writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        NSLog(@"配置不正确");
    }
}

- (void)setNotifyWithCharacteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block {
    [_btMgr setNotifyWithPeripheral:_choicePeripheal characteristic:characteristic block:block];
}

- (void)setNotifyWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block {
    _choicePeripheal = peripheral;
    [_btMgr setNotifyWithPeripheral:peripheral characteristic:characteristic block:block];
}

@end
