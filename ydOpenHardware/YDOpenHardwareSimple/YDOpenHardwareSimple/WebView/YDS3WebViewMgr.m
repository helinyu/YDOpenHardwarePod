//
//  YDBluetoothWebViewMgr.m
//  SportsBar
//
//  Created by Aka on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YDS3WebViewMgr.h"
#import "YDBlueToothMgr.h"
#import "YDBridgeWebMgr.h"
#import "WebViewJavascriptBridge.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YYModel.h"
#import "MSJsonKit.h"

#import <YDOpenHardwareSDK/YDOpenHardwareManager.h>
#import <YDOpenHardwareSDK/YDOpenHardwareDataProvider.h>
#import <YDOpenHardwareSDK/YDOpenHardwareIntelligentScale.h>
#import <YDOpenHardwareSDK/YDOpenHardwareHeartRate.h>
#import <YDOpenHardwareSDK/YDOpenHardwareSDK.h>



@interface YDS3WebViewMgr ()

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

@implementation YDS3WebViewMgr

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidFinishLaunchNotify:) name:YDNtfOpenHardwareAppdidFinishLaunch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActiveNotify:) name:YDNtfOpenHardwareAppWillResignActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackgroundNotify:) name:YDNtfOpenHardwareAppDidEnterBackground object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForegroundNotify:) name:YDNtfOpenHardwareAppWillEnterForeground object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActiveNotify:) name:YDNtfOpenHardwareAppDidBecomeActive object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillTerminateNotify:) name:YDNtfOpenHardwareAppWillTerminate object:nil];
}

- (void)scanPeripheralWithMatchWord:(NSString *)matchWord {
    _btMgr = [YDBlueToothMgr shared];
    _btMgr.filterType = YDBlueToothFilterTypeMatch;
    _btMgr.matchField = matchWord;
}

- (void)startScanThenSourcesCallback:(void(^)(NSArray *peirpherals))callback {
    _btMgr.scanCallBack = ^(NSArray<CBPeripheral *> *peripherals) {
        !callback?:callback(peripherals);
    };
    _btMgr.startScan();
}

- (void)registerHandlers {
    
//    other index.html methods
    [_webViewBridge registerHandler:@"deliverFromjs" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js dispatch oc");
    }];
    
    __weak typeof (self) wSelf = self;
    [_webViewBridge registerHandler:@"onScan" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data) {
            return ;
        }
        
        [wSelf scanPeripheralWithMatchWord:data];
        wSelf.btMgr.startScan().scanCallBack = ^(NSArray<CBPeripheral *> *peripherals) {
            NSLog(@"count: %lu index.0:%@",(unsigned long)peripherals.count,peripherals[0]);
            CBPeripheral *peripheral = peripherals[0];
            [wSelf onAddPeripheralToHtmlWithPeripheral:peripheral];
            wSelf.choicePeripheal = peripheral;
        };
    }];

    [_webViewBridge registerHandler:@"onConnect" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data) {
            return ;
        }

        CBPeripheral *peripheral = wSelf.choicePeripheal;
        [wSelf.btMgr onConnectBluetoothWithPeripheral:peripheral];
        wSelf.btMgr.connectionCallBack = ^(BOOL success) {
            if (success) {
                [wSelf registerOpenHardWareWithPeripheral:peripheral];
                [wSelf backDatas];
            }
        };
    }];
    
    [_webViewBridge registerHandler:@"onQuitConnect" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (_btMgr) {
            _btMgr.quitConnected();
        }
    }];
    
//    source register
    [_webViewBridge registerHandler:@"onSecondConnect" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"on Source connect");
    }];
    
    [_webViewBridge registerHandler:@"onSecondScan" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"source on Second Scan");
    }];
    
    [_webViewBridge registerHandler:@"deliverSecondFromjs" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"deliverSecondFromjs ");
    }];

//    S3
    [_webViewBridge registerHandler:@"onScanS3Click" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (!data) {
            return ;
        }
        [wSelf scanPeripheralWithMatchWord:data];
        [self reloadWithUrl:@"peripheralList.html"];
        wSelf.btMgr.startScan().scanPeripheralCallback = ^(CBPeripheral *peripheral) {
            [wSelf onAddPeripheralToHtmlWithPeripheral:peripheral];
            [wSelf onAddToS3ListWithPeripheral:peripheral];
        };
    }];
    
//    选择连接的对象
    [_webViewBridge registerHandler:@"onTouchPeripheral" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@" choice peripheral data : %@",data);
        if (data) {
            
            _btMgr.stopScan().connectingPeripheralUuid(data);
            [wSelf.btMgr onConnectCurrentPeripheralOfBluetooth];
            _choicePeripheal = _btMgr.currentPeripheral;
            wSelf.btMgr.connectionCallBack = ^(BOOL success) {
                if (success) {
                    [wSelf registerOpenHardWareWithPeripheral:_choicePeripheal];
                    [wSelf backDatas];
                }
            };
        }
    }];
    
}

- (void)reloadWithUrl:(NSString *)string {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yd.readload.html" object:string userInfo:nil];
}

- (void)backDatas {
    
    __weak typeof (self) wSelf = self;
    _btMgr.servicesCallBack = ^(NSArray<CBService *> *services) {
        
    };
//    back the data which we read
    _btMgr.characteristicCallBack = ^(CBCharacteristic *c) {
        if (c.value && c.UUID) {
            [wSelf insertDataToYDOpen:c];
            [wSelf onDeliverToHtmlWithCharateristic:c];
          }
     };
}

// 公共的数据传递——
- (void)onDeliverToHtmlWithCharateristic:(CBCharacteristic *)c {
    Byte *resultP = (Byte *)[c.value bytes];
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
//        NSError *parseError = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:characteristicInfo options:NSJSONWritingPrettyPrinted error:&parseError];
//        NSString *infoString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [_webViewBridge callHandler:@"deliverCharacteristic" data:characteristicInfo responseCallback:^(id responseData) {
            NSLog(@"response data : %@",responseData);
        }];
 
    }
}

#pragma mark --xx handler with html

- (void)onAddPeripheralToHtmlWithPeripheral:(CBPeripheral *)peripheral {
    if (peripheral.name && peripheral.identifier) {
        NSDictionary *peripheralInfo = @{@"name":peripheral.name,@"uuid":peripheral.identifier.UUIDString};
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:peripheralInfo options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *infoString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [_webViewBridge callHandler:@"onPeripheral" data:infoString responseCallback:^(id responseData) {
            NSLog(@"peripheral : %@",peripheral);
        }];
        
    }
 }

- (void)onAddToS3ListWithPeripheral:(CBPeripheral *)peripheral {
    if (peripheral.name && peripheral.identifier) {
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
   
}

#pragma mark -- link to openHardware

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

#pragma mark -- insert datas

- (void)insertDataToYDOpen:(CBCharacteristic *)characteristic{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        
        for(int i=0;i<[data length];i++){
            if (i == 2) {
                int heartNum = resultByte[i];
                if (heartNum == 0) {
                    return;
                }
                
                NSDate * now = [self currentTime:[NSDate date]];
                YDOpenHardwareHeartRate *hr = [[YDOpenHardwareHeartRate alloc] init];
                [hr constructByOhhId: nil DeviceId: _deviceIdentify HeartRate:@(heartNum) StartTime: now EndTime: now UserId:_userId Extra: @"" ServerId:nil Status:nil];
                //插入心率新记录,插入成功后会自动更新传入数据的主键
                [[YDOpenHardwareManager dataProvider] insertHeartRate: hr completion:^(BOOL success) {
                    
                }];
                
                NSString *heartRateString = [NSString stringWithFormat:@"%d",heartNum];
                [_webViewBridge callHandler:@"deliverHeartRate" data:@{@"heartRate":heartRateString} responseCallback:^(id responseData) {
                    NSLog(@"response data : %@",responseData);
                }];
                
                //建立OpenHardwarePedometer
                YDOpenHardwarePedometer *pedomenter = [[YDOpenHardwarePedometer alloc]init];
                
                NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
                NSString *stepStr = [defaluts objectForKey:@"lastInsertStepsS3"];
                
                _lastStepNum = stepStr.intValue;
                if (_step == 0 || _lastStepNum == _step) {
                    return;
                }
                if ((_lastStepNum > _step)|| (_isFirstReload == YES)) {
                    _lastStepNum = 0;
                }
                
                [pedomenter constructByOhpId:nil DeviceId:_deviceIdentify NumberOfStep:[NSNumber numberWithInteger:(_step-_lastStepNum)] Distance:[NSNumber numberWithFloat:_disM] Calorie:[NSNumber numberWithInteger:_calorie] StartTime:now EndTime:now UserId:_userId Extra:@"" ServerId:nil Status:nil];
                
                //插入计步数据
                [[YDOpenHardwareManager dataProvider] insertPedometer:pedomenter completion:^(BOOL success) {
                    
                    NSUserDefaults *defalut = [NSUserDefaults standardUserDefaults];
                    [defalut setObject:[NSString stringWithFormat:@"%ld",(long)_step] forKey:@"lastInsertStepsS3"];
                    _isFirstReload = NO;
                }];
            }
        }
    }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF3"]]) {
        //步数
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        
        for(int i=0;i<[data length];i++){
            int a = resultByte[3];
            _step = resultByte[2];
            if (a !=0) {
                _step = resultByte[2] + 256*a;
            }
            if (i == 2) {
                //                //卡路里
                _calorie = (int) (_step * 0.5 / 14);
                //                //距离
                _disM = (float)(_step * 0.5 / 1000);
                NSString *calorieString = [NSString stringWithFormat:@"%d",_calorie];
                NSString *disMString = [NSString stringWithFormat:@"%f",_disM];
                NSString *stepString = [NSString stringWithFormat:@"%d",_step];
                [_webViewBridge callHandler:@"deliverCalorieAndDisM" data:@{@"calorie":calorieString,@"disM":disMString,@"step":stepString} responseCallback:^(id responseData) {
                    NSLog(@"response data : %@",responseData);
                }];
            }
        }
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]){
        
    }
}

- (NSDate *)currentTime:(NSDate *)date{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMT];
    date = [date dateByAddingTimeInterval:interval];
    return date;
}

#pragma mark -- notification

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

- (void)onAppDidFinishLaunchNotify:(NSNotification *)notification{

}

- (void)onAppWillResignActiveNotify:(NSNotification *)notification{

}

- (void)onAppDidEnterBackgroundNotify:(NSNotification *)notification{

}

- (void)onAppWillEnterForegroundNotify:(NSNotification *)notification{

}

- (void)onAppDidBecomeActiveNotify:(NSNotification *)notification{

}

- (void)onAppWillTerminateNotify:(NSNotification *)notification{

}

@end
