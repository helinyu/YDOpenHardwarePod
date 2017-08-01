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

@interface YDBlueToothMgr ()

//test
@property (nonatomic, assign) NSInteger step;

@property (nonatomic, strong) BabyBluetooth *bluetooth;

/*
 * param : peripherals , memory store peripheral to display & for selected
 * discussion : this attribute must be implement for selected and search service enable by it ,if not ,it will be not find the services
 */
@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

@property (nonatomic, strong) NSMutableArray<CBService *> *connectedPeripheralServices;

@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, strong, readwrite) CBPeripheral *currentPeripheral;


@end

static NSString *const ydNtfMangerDidUpdataValueForCharacteristic = @"yd.bluetooth.DidUpdataValueForCharacteristic";

@implementation YDBlueToothMgr

#pragma mark -- system function
- (void)dealloc {
    self.quitConnected();
}

#pragma mark -- all delegate block

- (void)babyDelegate {
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ontest:) name:BabyNotificationAtDidWriteValueForCharacteristic object:nil];
    
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
        }
    }];
    
   [_bluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {

       if (peripheralName.length <= 0) {
           return NO;
       }else{
           return YES;
       }
       
#warning  need to fix change
       NSLog(@"peripheral name : %@",peripheralName);
        switch (wSelf.filterType) {
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
    
#pragma mark - connect & services
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
    

#pragma mark - services & characteristic
    
    [_bluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"setBlockOnDiscoverCharacteristics");
        for (CBCharacteristic *c in service.characteristics) {
           [wSelf.bluetooth notify:peripheral characteristic:c block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
               !wSelf.characteristicCallBack?:wSelf.characteristicCallBack(c);
               NSLog(@"c; %@",c.UUID.UUIDString);
           }];
        }
    }];
    
    [_bluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnReadValueForCharacteristic");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ydNtfMangerDidUpdataValueForCharacteristic object:characteristic];
        
        if (!error) {
            NSError *error1 = nil;
            id dict = [NSJSONSerialization JSONObjectWithData:characteristic.value options:NSJSONReadingMutableContainers error:&error1];
            NSLog(@"dict is : %@",dict);
        }
        
        !wSelf.characteristicCallBack?:wSelf.characteristicCallBack(characteristic);
        NSLog(@"characteristic ; %@",characteristic.UUID.UUIDString);

    }];
    
    [_bluetooth setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidUpdateNotificationStateForCharacteristic");
    }];
    
// characteristic & discriptors
    [_bluetooth setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDiscoverDescriptorsForCharacteristic");
    }];
    
    [_bluetooth setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"setBlockOnReadValueForDescriptors");
    }];
    
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    [_bluetooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];

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

- (void)initWithFilterField:(NSString *)filterField withFilterType:(YDBlueToothFilterType) type {
    switch (type) {
        case YDBlueToothFilterTypeMatch:
            break;
        case YDBlueToothFilterTypeContain:
            break;
        default:
            break;
    }
}


- (YDBlueToothMgr *(^)(void))startScan {
    _peripherals = [NSMutableArray<CBPeripheral *> new];
    [_bluetooth cancelAllPeripheralsConnection];
    _bluetooth = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    _bluetooth.scanForPeripherals().begin();
    
    return ^(void){
        return self;
    };
}

- (void)ontest:(NSNotification *)notification {
    CBCharacteristic *c = [notification.object objectForKey:@"characteristic"];
    NSLog(@"did update dats ");
//    [    CBCharacteristic *characteristic = notification.object;
//]
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

- (void)onConnectCurrentPeripheralOfBluetooth {
    [self onConnectBluetoothWithPeripheral:_currentPeripheral];
}

- (void)insertDataToYDOpen:(CBCharacteristic *)characteristic{
    NSLog(@"current charactieristic uuid is ： %@",characteristic.UUID);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
        NSData * data = characteristic.value;
        Byte * resultByte = (Byte *)[data bytes];
        
        for(int i=0;i<[data length];i++){
            if (i == 2) {
                
                int heartNUM = resultByte[i];
                NSString *heatString = [NSString stringWithFormat:@"%d",heartNUM];
                NSLog(@"heart reate string : %@",heatString);
                !_heartRateCallBack?:_heartRateCallBack(heatString);
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
               
                //卡路里
                CGFloat calorieValue = (_step * 0.5 / 14);
                NSLog(@"calorieVaule is : %f",calorieValue);
                
                //距离
                CGFloat disMValue = (_step * 0.5 / 1000);
                NSLog(@"disMValue : %f",disMValue);
                !self.tripCallBack?:self.tripCallBack(calorieValue,disMValue);
            }
        }
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]){
    }
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

- (YDBlueToothMgr *(^)(NSString *uuidString))connectingPeripheralUuid {
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

- (YDBlueToothMgr * (^)(CBPeripheral *peripheral))connectedPeripheral {
    __weak typeof (self) wSelf = self;
    return ^(CBPeripheral *peripheral){
        wSelf.currentPeripheral = peripheral;
        return self;
    };
}

@end
