//
//  YDBluetoothWebViewMgr+Time.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/15.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+Time.h"

@implementation YDBluetoothWebViewMgr (Time)

//dis for convert the info dic of time to selected specify
- (void)convertToSelectedTimeWithInfo:(NSDictionary *)infoDic then:(TimeBlock)timeBlock {
    NSInteger timeSecNum = [infoDic[@"timeSec"] integerValue];
    NSDate *timeSec;
    NSDate *startTime;
    NSDate *endTime;
    if (timeSecNum > 0) {
        timeSec = [NSDate dateWithTimeIntervalSince1970:[infoDic[@"timeSec"] integerValue]];
    }
    else{
        NSInteger startTimeNum = [infoDic[@"startTime"] integerValue];
        startTimeNum >0? (startTime = [NSDate dateWithTimeIntervalSince1970:startTimeNum]):[NSDate dateWithTimeIntervalSince1970:0];
        NSInteger endTimeNum = [infoDic[@"endTime"] integerValue];
        endTimeNum >0? (endTime = [NSDate dateWithTimeIntervalSince1970:endTimeNum]):(endTime =[NSDate date]);
    }
    !timeBlock?:timeBlock(timeSec,startTime,endTime);
}

@end
