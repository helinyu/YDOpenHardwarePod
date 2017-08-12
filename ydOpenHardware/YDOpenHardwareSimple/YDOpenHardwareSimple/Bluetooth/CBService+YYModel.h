//
//  CBService+YYModel.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/11.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBService (YYModel)

@end

@interface CBCharacteristic (YYModel)

- (NSDictionary *)convertToDictionary;

@end
