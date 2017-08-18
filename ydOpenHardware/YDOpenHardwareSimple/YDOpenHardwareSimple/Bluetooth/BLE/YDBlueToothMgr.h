//
//  YDBlueToothMgr.h
//  test
//
//  Created by Aka on 2017/7/18.
//  Copyright © 2017年 forest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "YDBluetoohWebDefine.h"

@class YDPeripheralInfo;


@interface YDBlueToothMgr : NSObject

+ (instancetype)shared;

//tel phone call
@property (nonatomic, strong) void(^callHandle)(BOOL handerFlag);

//- (void)startScan;
- (YDBlueToothMgr *(^)(void))startScan;
- (YDBlueToothMgr *(^)(void))stopScan;
//- (BOOL)isScanning;

/*
 *@metod quit the connection abount the central with the peripheral
 *@discussion may be like that ,the VC dealloc, we may be need to quit the connected
 */
- (YDBlueToothMgr *(^)(void))quitConnected;
- (YDBlueToothMgr *(^)(CBPeripheral *peripheral))quitConnectedPeripheal;

/*
 * @param :blue tooth search & filter key word and  pattern, required
 * @discussion: this filed must field one and configure with the filterType
 */
@property (nonatomic, copy) NSString *matchField;
@property (nonatomic, copy) NSString *prefixField;
@property (nonatomic, copy) NSString *suffixField;
@property (nonatomic, copy) NSString *containField;

/*
 * param : filterType required
 * discussion : filter determine which type we will use to filter and find the specify bluetooth
 */
@property (nonatomic, assign) YDBlueToothFilterType filterType;


/*
 *@param : this param for the peripheral which we are choosing now
 * see :
 */
@property (nonatomic, strong, readonly) CBPeripheral *currentPeripheral;

/*
 * @parmam : connectedPeripheral (recommended)
 * discussion : 传入参数有两种方式，一种方式是同步block的方式，实现链式调用传入，另外一个种是直接传入
 */
- (YDBlueToothMgr * (^)(CBPeripheral *peripheral))connectingPeripheral;
- (YDBlueToothMgr *(^)(NSString *uuidString))willBeConnetPeiripheralByUUID;
- (YDBlueToothMgr *(^)(CBPeripheral *peripheral))willBeConnetPeiripheral;

/*
 * @param  currentIndex depend on the outside logic ,which help to choose the current peripheral
 * @block connectingPeripheralIndex which help to Chain programming by deliver the currentIndex
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;
- (YDBlueToothMgr * (^)(NSInteger index))connectingPeripheralIndex;


#pragma mark -- action method

// scan
/*
 *@param : peripherals which the bluetooth are scaning now
 *@discussion : you can  use this block to get tehe peripherals which we the bluetooth has scan
 *& we must use the mothod of startScan
 */
@property (nonatomic, copy) void(^scanCallBack)(NSArray<CBPeripheral *> *peripherals);
@property (nonatomic, copy) void(^scanPeripheralCallback)(CBPeripheral *peripheral);

/*
 * @param : info contain more info abount peripheral
 * @attribute : CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI
 * @see : setBlockOnDiscoverToPeripherals methods the result block back
 */
@property (nonatomic, copy) void(^scanPeripheralInfosCallBack)(NSArray<YDPeripheralInfo *> * peripherals);
@property (nonatomic, copy) void(^scanPeripheralInfoCallback)(YDPeripheralInfo *peripheralInfo);


//connect
/*
 *@param : index was deliver by the outside which help to choose the peripheral
 *@discussion : this method was rely on the logic of business (no recommended)
 *@discussion ; onConnectCurrentPeripheralOfBluetooth this method must deliver the current peripheral before which will connect
 */
- (void)onConnectBluetoothWithIndex:(NSInteger)index;
- (void)onConnectBluetoothWithPeripheral:(CBPeripheral *)peripheral;// (recommended)
- (YDBlueToothMgr *(^)())connectingCurrentPeripheral;


/*
 *@param : which callback by the success to diagnosis is connecting success or not
 @disucssion : connect response status
 */
@property (nonatomic, copy) void (^connectionCallBack)(BOOL success);

/*
 *@param : services which bluetooth now get
 *@discussion : this block for getting the service we now get
 * it was trigger by the onConnectBluetoothWith*** method
 * connect repones with services
 */
@property (nonatomic, copy) void(^servicesCallBack)(NSArray<CBService *> *services);


#pragma mark -- datas for callback & chacteristic data

@property (nonatomic, copy) void(^heartRateCallBack)(NSString *heartString);
@property (nonatomic, copy) void(^tripCallBack)(CGFloat calories, CGFloat distance);

//@property (nonatomic, copy) void(^characteristicCallBack)(CBCharacteristic *c);
typedef void (^CharacteristicCallback)(CBCharacteristic *c);
@property (nonatomic, copy) CharacteristicCallback discoverCharacteristicCallback;
@property (nonatomic, copy) CharacteristicCallback updateValueCharacteristicCallBack;

- (void)writeDatas:(NSData *)datas forCharacteristic:(CBCharacteristic *)characteristic; // write datas for the specify characteristic

//obtain the cbperipheal by the uuid which is specified
//@property (nonnull, copy) void(^ObtainPeirpheal)(NSString *uuid);
- (CBPeripheral *)obtainPeripheralWithUUIDString:(NSString *)uuidString;

- (void)setNotifyWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;

@end

FOUNDATION_EXPORT NSString *const YDNtfMangerDidUpdataValueForCharacteristic;
FOUNDATION_EXPORT NSString *const YDNtfMangerDidUpdateNotificationStateForCharacteristic;
FOUNDATION_EXPORT NSString *const YDNtfMangerDiscoverDescriptorsForCharacteristic;
FOUNDATION_EXPORT NSString *const YDNtfMangerReadValueForDescriptors;




