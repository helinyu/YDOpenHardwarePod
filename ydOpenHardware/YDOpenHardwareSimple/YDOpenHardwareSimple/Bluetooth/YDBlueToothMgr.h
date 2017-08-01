//
//  YDBlueToothMgr.h
//  test
//
//  Created by Aka on 2017/7/18.
//  Copyright © 2017年 forest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CBPeripheral;
@class CBService;
@class CBCharacteristic;

typedef NS_ENUM(NSInteger, YDBlueToothFilterType) {
    YDBlueToothFilterTypeMatch = 0,  // match to filter and find the specify device
    YDBlueToothFilterTypeContain,    // contain the keyword to filter and find the specify device
    YDBlueToothFilterTypePrefix,     // key word by the prefix
    YDBlueToothFilterTypeSuffix,     // key word by the suffix
    YDBlueToothFilterTypePrefixAndSuffix, // key word by the prefix & suffix
    YDBlueToothFilterTypePrefixAndContain, // key word by the prefix & contain
    YDBlueToothFilterTypeSuffixAndContrain, // key word by the suffix & contain
    YDBlueToothFilterTypePrefixAndContrainAndSuffix, //key word by the prefix & contrain * suffix
};

@interface YDBlueToothMgr : NSObject

+ (instancetype)shared;

//- (void)startScan;
- (YDBlueToothMgr *(^)(void))startScan;
- (YDBlueToothMgr *(^)(void))stopScan;

/*
 *@metod quit the connection abount the central with the peripheral
 *@discussion may be like that ,the VC dealloc, we may be need to quit the connected
 */
- (YDBlueToothMgr *(^)(void))quitConnected;

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
- (YDBlueToothMgr * (^)(CBPeripheral *peripheral))connectedPeripheral;
- (YDBlueToothMgr *(^)(NSString *uuidString))connectingPeripheralUuid;
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

//connect
/*
 *@param : index was deliver by the outside which help to choose the peripheral
 *@discussion : this method was rely on the logic of business (no recommended)
 *@discussion ; onConnectCurrentPeripheralOfBluetooth this method must deliver the current peripheral before which will connect
 */
- (void)onConnectBluetoothWithIndex:(NSInteger)index;
- (void)onConnectBluetoothWithPeripheral:(CBPeripheral *)peripheral;// (recommended)
- (void)onConnectCurrentPeripheralOfBluetooth;

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

@property (nonatomic, copy) void(^characteristicCallBack)(CBCharacteristic *c);



@end
