//
//  YDPeripheralInfo.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/16.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDPeripheralInfo.h"

@implementation YDPeripheralInfo

+ (YDPeripheralInfo *)Peripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    YDPeripheralInfo *item = [YDPeripheralInfo new];
    item.peripheral = peripheral;
    item.advertisementData = advertisementData;
    item.RSSI = RSSI;
    return item;
}

@end
