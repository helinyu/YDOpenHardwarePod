//
//  YDPeripheralInfo.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CBPeripheral;

@interface YDPeripheralInfo : NSObject

@property (nonatomic, strong) NSDictionary *advertisementData;
@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong) CBPeripheral *peripheral;

+ (YDPeripheralInfo *)Peripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;

- (instancetype)init NS_UNAVAILABLE;

@end
