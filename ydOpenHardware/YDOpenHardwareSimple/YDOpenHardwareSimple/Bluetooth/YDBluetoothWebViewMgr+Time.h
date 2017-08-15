//
//  YDBluetoothWebViewMgr+Time.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/15.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr.h"

@interface YDBluetoothWebViewMgr (Time)

typedef void (^TimeBlock)(NSDate *timeSec, NSDate *startTime, NSDate *endTime);
- (void)convertToSelectedTimeWithInfo:(NSDictionary *)infoDic then:(TimeBlock)timeBlock;

@end
