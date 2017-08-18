//
//  YDBlueToothMgr.m
//  test
//
//  Created by Aka on 2017/7/18.
//  Copyright © 2017年 forest. All rights reserved.
//

#import "YDBlueToothMgr.h"
#import "BabyBluetooth.h"
#import "SVProgressHUD.h"
#import "NSString+YDContainsString.h"
#import "YDPeripheralInfo.h"
#import <CoreTelephony/CTCallCenter.h>

@interface YDBlueToothMgr ()

//test
@property (nonatomic, assign) NSInteger step;

@property (nonatomic, strong) BabyBluetooth *bluetooth;

/*
 * param : peripherals , memory store peripheral to display & for selected
 * discussion : this attribute must be implement for selected and search service enable by it ,if not ,it will be not find the services
 */
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;
@property (nonatomic, strong) NSMutableArray<YDPeripheralInfo *> *peripheralInfos;

@property (nonatomic, strong) NSMutableArray<CBService *> *connectedPeripheralServices;

@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, strong, readwrite) CBPeripheral *currentPeripheral;


@end

NSString *const YDNtfMangerDidUpdataValueForCharacteristic = @"yd.ntf.bluetooth.did.update.value.for.characteristic";
NSString *const YDNtfMangerDidUpdateNotificationStateForCharacteristic = @"yd.ntf.manager.did.update.notification.state.for.charcteristic";
NSString *const YDNtfMangerDiscoverDescriptorsForCharacteristic = @"yd.ntf.manager.did.discover.descriptors.for.characteristic";
NSString *const YDNtfMangerReadValueForDescriptors = @"yd.ntf.read.value.for.descriptors";

@implementation YDBlueToothMgr

#pragma mark -- telphone
- (void)registerTelCaller {
    _callCenter = [CTCallCenter new];
    __weak typeof (self) wSelf = self;
    _callCenter.callEventHandler = ^(CTCall *call) {
        NSString *callDescription = [NSString stringWithFormat:@"%@",call];
        NSLog(@"callDescription == %@",callDescription);
        NSArray *strarray0 = [callDescription componentsSeparatedByString:@"]"];
        NSString *sub0 = strarray0[0];
        NSArray *strarray1 = [sub0 componentsSeparatedByString:@"["];
        NSString *callState = strarray1[1];
        NSLog(@"callState == %@",callState);
        if ([callState isEqualToString:@"CTCallStateIncoming"] || [callState isEqualToString:@"CTCallStateConnected"]) {
            wSelf.callHandle(YES);
        }else {
            wSelf.callHandle(NO);
        }
    };
}


#pragma mark -- system function
- (void)dealloc {
    self.quitConnected();
}

#pragma mark -- all delegate block

- (void)babyDelegate {
    
    [self registerTelCaller];
    
    __weak typeof  (self) wSelf = self;
    
    [_bluetooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
            NSLog(@"设备打开成功，开始扫描蓝牙设备");
        }
    }];

    [_bluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        BOOL hasStored = NO;
        for (CBPeripheral *item in wSelf.peripherals) {
            if ([item.name isEqualToString:peripheral.name]) {
                hasStored = YES;
                break;
            }
        }
        if (!hasStored) {
            [wSelf.peripherals addObject:peripheral];
            NSLog(@"find peripheral name is : %@",peripheral.name);
            !wSelf.scanCallBack?:wSelf.scanCallBack(wSelf.peripherals);
            !wSelf.scanPeripheralCallback?:wSelf.scanPeripheralCallback(peripheral);
            
            // add some info
            YDPeripheralInfo *peripheralInfo = [YDPeripheralInfo new];
            peripheralInfo.peripheral = peripheral;
            peripheralInfo.advertisementData = advertisementData;
            peripheralInfo.RSSI = RSSI;
            [wSelf.peripheralInfos addObject:peripheralInfo];
            !wSelf.scanPeripheralInfoCallback?:wSelf.scanPeripheralInfoCallback(peripheralInfo);
            !wSelf.scanPeripheralInfosCallBack?:wSelf.scanPeripheralInfosCallBack(wSelf.peripheralInfos);
        }
    }];
    
   [_bluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
       
       NSLog(@"peripheral name : %@",peripheralName);
       
        switch (wSelf.filterType) {
            case YDBlueToothFilterTypeNone:
            {
                if (peripheralName.length > 0) {
                    return YES;
                }else{
                    return NO;
                }
            }
            case YDBlueToothFilterTypeMatch:
            {
                if ([peripheralName isEqualToString:wSelf.matchField]) {
                    return YES;
                }
                return NO;
            }
                break;
            case YDBlueToothFilterTypeContain:
            {
                if ([peripheralName containsString:wSelf.containField]) {
                    return YES;
                }
                return NO;
            }
                break;
            case YDBlueToothFilterTypePrefix:
            {
                if ([peripheralName hasPrefix:wSelf.prefixField]) {
                    return YES;
                }
                return NO;
            }
                break;
            case YDBlueToothFilterTypeSuffix:
            {
                if ([peripheralName hasSuffix:wSelf.suffixField]) {
                    return YES;
                }
                return NO;
            }
                break;
            case YDBlueToothFilterTypePrefixAndContain:
            {
                if ([peripheralName hasPrefix:wSelf.prefixField] && [peripheralName containsString:wSelf.containField]) {
                    return YES;
                }
                return NO;
            }
                break;
            case YDBlueToothFilterTypePrefixAndSuffix:
            {
                if ([peripheralName hasPrefix:wSelf.prefixField] && [peripheralName hasSuffix:wSelf.suffixField]) {
                    return YES;
                }
                return NO;
            }
                break;
            case YDBlueToothFilterTypeSuffixAndContrain:
            {
                if ([peripheralName hasSuffix:wSelf.suffixField] && [peripheralName containsString:wSelf.containField]) {
                    return YES;
                }
                return NO;
            }
                break;
            case YDBlueToothFilterTypePrefixAndContrainAndSuffix:
            {
                if ([peripheralName hasPrefix:wSelf.prefixField] && [peripheralName containsString:wSelf.containField] && [peripheralName hasSuffix:wSelf.suffixField]) {
                    return YES;
                }
                return NO;
            }
                break;
            default:
                return NO;
                break;
        }
        return NO;
    }];
    
#pragma mark - connect ===> services
    [_bluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"setBlockOnConnected");
        !wSelf.connectionCallBack?:wSelf.connectionCallBack(YES);
    }];
    
    [_bluetooth setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"setBlockOnFailToConnect");
        !wSelf.connectionCallBack?:wSelf.connectionCallBack(NO);
    }];
    
    [_bluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"setBlockOnDisconnect");
        !wSelf.connectionCallBack?:wSelf.connectionCallBack(NO);
    }];
    
    [_bluetooth setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        NSLog(@"setBlockOnDiscoverServices");
        [wSelf addConnectedServicesWithServices:peripheral.services];
        !wSelf.servicesCallBack?:wSelf.servicesCallBack(wSelf.connectedPeripheralServices);
    }];
    
#pragma mark - services ===> characteristic
    
    [_bluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"setBlockOnDiscoverCharacteristics");
        for (CBCharacteristic *c in service.characteristics) {
            !wSelf.discoverCharacteristicCallback?:wSelf.discoverCharacteristicCallback(c);
        }
    }];

    [_bluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnReadValueForCharacteristic");
        !wSelf.updateValueCharacteristicCallBack?:wSelf.updateValueCharacteristicCallBack(characteristic);
        NSLog(@"updateValueCharacteristicCallBack characteristic ; %@",characteristic.UUID.UUIDString);

    }];
    
    [_bluetooth setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YDNtfMangerDidUpdateNotificationStateForCharacteristic object:characteristic];
    }];
    
//    characteristic & discriptors
    [_bluetooth setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YDNtfMangerDiscoverDescriptorsForCharacteristic object:characteristic];
    }];
    
    [_bluetooth setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YDNtfMangerReadValueForDescriptors object:descriptor];
    }];
    
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    [_bluetooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];

}

- (void)writeDatas:(NSData *)datas forCharacteristic:(CBCharacteristic *)characteristic  {
    [self.currentPeripheral writeValue:datas forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

- (void)setNotifyWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block {
    [_bluetooth notify:peripheral characteristic:characteristic block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        if (error) {
            NSLog(@"设置通知失败 : %@",characteristics);
        }else{
            NSLog(@"设置通知成功 : %@",characteristics);
        }
        !block?:block(peripheral,characteristic,error);
    }];
}

#pragma mark -- custom methods

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (YDBlueToothMgr *(^)(void))startScan {
    _peripherals = [NSMutableArray<CBPeripheral *> new];
    _peripheralInfos = [NSMutableArray<YDPeripheralInfo *> new];
    [_bluetooth cancelAllPeripheralsConnection];
    _bluetooth = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    _bluetooth.scanForPeripherals().begin();
    return ^(void){
        return self;
    };
}

- (YDBlueToothMgr *(^)(void))stopScan {
    __weak typeof (self) wSelf = self;
    return ^(void) {
        wSelf.bluetooth.stop(0);
        return self;
    };
}

- (YDBlueToothMgr *(^)(void))quitConnected {
    __weak typeof (self) wSelf = self;
    return ^(void) {
        if (wSelf.currentPeripheral) {
            [wSelf.bluetooth cancelPeripheralConnection:wSelf.currentPeripheral];
            wSelf.currentPeripheral = nil;
        }
        return self;
    };
}

- (YDBlueToothMgr *(^)(CBPeripheral *peripheral))quitConnectedPeripheal {
    __weak typeof (self) wSelf = self;
    return ^(CBPeripheral *peripheral) {
            [wSelf.bluetooth cancelPeripheralConnection:peripheral];
        return self;
    };
}

- (void)addConnectedServicesWithServices:(NSArray<CBService *> *)services {
    for (CBService *service in services) {
        [self addConnectedServicesWithService:service];
    }
}

- (void)addConnectedServicesWithService:(CBService *)service {
    [_connectedPeripheralServices addObject:service];
}

// custom action method

- (void)onConnectBluetoothWithIndex:(NSInteger)index {
    [self onConnectBluetoothWithPeripheral:_peripherals[index]];
}

- (void)onConnectBluetoothWithPeripheral:(CBPeripheral *)peripheral {
    [self onConnectPrepareWithWillConnectingPeripheral:peripheral];
_bluetooth.having(peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}

- (void)onConnectPrepareWithWillConnectingPeripheral:(CBPeripheral *)peripheral {
    _currentPeripheral = peripheral;
    [_bluetooth cancelScan];
    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    _connectedPeripheralServices = [NSMutableArray<CBService *> new];
}

- (YDBlueToothMgr *(^)(void))connectingCurrentPeripheral {
    [self onConnectBluetoothWithPeripheral:_currentPeripheral];
    return ^(void){
        return self;
    };
}

#pragma mark -- some block methods

- (YDBlueToothMgr * (^)(NSInteger index))connectingPeripheralIndex {
    __weak typeof (self) wSelf = self;
    return ^(NSInteger index) {
        wSelf.currentIndex = index;
        wSelf.currentPeripheral = wSelf.peripherals[index];
        return self;
    };
}

- (YDBlueToothMgr *(^)(NSString *uuidString))willBeConnetPeiripheralByUUID {
    __weak typeof (self) wSelf = self;
    return ^(NSString *uuidString) {
        for (CBPeripheral *item in wSelf.peripherals) {
            if ([item.identifier.UUIDString isEqualToString:uuidString]) {
                wSelf.currentPeripheral = item;
            };
        }
        return self;
    };
}

- (YDBlueToothMgr *(^)(CBPeripheral *peripheral))willBeConnetPeiripheral {
    __weak typeof (self) wSelf = self;
    return ^(CBPeripheral *peripheral) {
            wSelf.currentPeripheral = peripheral;
        return self;
    };
}

- (YDBlueToothMgr * (^)(CBPeripheral *peripheral))connectingPeripheral {
    __weak typeof (self) wSelf = self;
    return ^(CBPeripheral *peripheral){
        wSelf.currentPeripheral = peripheral;
        return self;
    };
}

- (CBPeripheral *)obtainPeripheralWithUUIDString:(NSString *)uuidString {
    for (CBPeripheral *peripheal in _peripherals) {
        if ([peripheal.identifier.UUIDString isEqualToString:uuidString]) {
            return peripheal;
        }
    }
    return nil;
}

@end
