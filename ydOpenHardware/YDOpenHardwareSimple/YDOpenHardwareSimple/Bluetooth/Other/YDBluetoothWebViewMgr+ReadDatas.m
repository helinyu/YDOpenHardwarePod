//
//  YDBluetoothWebViewMgr+ReadDatas.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/17.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+ReadDatas.h"

@implementation YDBluetoothWebViewMgr (ReadDatas)

-(void)readByteWithData:(NSData*)DataD {
    //    Byte *data = (Byte *)[DataD bytes];
    Byte *dataB = (Byte *)[DataD bytes];
    Byte headerId = dataB[0];
    NSLog(@"headerId_a == %2x",headerId);
    switch (headerId) {
            // 心率，暂不支持
        case (Byte) 0x01: {
            NSLog(@"写入时间成功");
            break;
        }
        case (Byte) 0x81: {
            NSLog(@"写入时间失败");
            break;
        }
        case (Byte) 0x41: {
            int year1 = (int)((dataB[1] & 0XF0) >> 4)*10;
            int year2 = (int)(dataB[1] & 0X0F);
            int year = year1 + year2;
            
            int month1 = (int)((dataB[2] & 0XF0) >> 4)*10;
            int month2 = (int)(dataB[2] & 0X0F);
            int month = month1 + month2;
            
            int day1 = (int)((dataB[3] & 0XF0) >> 4)*10;
            int day2 = (int)(dataB[3] & 0X0F);
            int day = day1 + day2;
            
            int hour1 = (int)((dataB[4] & 0XF0) >> 4)*10;
            int hour2 = (int)(dataB[4] & 0X0F);
            int hour = hour1 + hour2;
            
            int min1 = (int)((dataB[5] & 0XF0) >> 4)*10;
            int min2 = (int)(dataB[5] & 0X0F);
            int min = min1 + min2;
            
            int sec1 = (int)((dataB[6] & 0XF0) >> 4)*10;
            int sec2 = (int)(dataB[6] & 0X0F);
            int sec = sec1 + sec2;
            NSLog(@"%2d:%2d:%2d:%2d:%2d:%2d",year,month,day,hour,min,sec);
            break;
        }
        case (Byte) 0x09: {
            
            int todayStep = (int)((dataB[1] & 0XFF) << 16) + (int)((dataB[2] & 0XFF) << 8) + (int)(dataB[3] & 0XFF);
            int todayRunStep = (int)((dataB[4] & 0XFF) << 16) + (int)((dataB[5] & 0XFF) << 8) + (int)(dataB[6] & 0XFF);
            NSInteger calorie = (int)((dataB[7] & 0XFF) << 16) + (int)((dataB[8] & 0XFF) << 8) + (int)(dataB[9] & 0XFF);
            CGFloat todayCalorie  = (CGFloat)calorie/100.0f;
            int todayDistance = (int)((dataB[10] & 0XFF) << 16) + (int)((dataB[11] & 0XFF) << 8) + (int)(dataB[12] & 0XFF);
            int todaySportsTime = (int)((dataB[13] & 0XFF) << 8) + (int)(dataB[14] & 0XFF);
            break;
        }
        case (Byte) 0x02: {
            NSLog(@"设置用户个人信息成功");
            break;
        }
        case (Byte) 0x82: {
            NSLog(@"设置用户个人信息失败");
            break;
        }
        case (Byte) 0x42: {
//            YDBandUserInfoModel *model = [YDBandUserInfoModel shareModel];
            int sex = (int)dataB[1];
            int age = (int)dataB[2];
            int height = (int)dataB[3];
            int weight = (int)dataB[4];
            int stepLength = (int)dataB[5];
            NSString *deviceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11]];
            NSLog(@"获取个人信息成功 : age : %d, deviceId : %@",age, deviceId);
            break;
        }
        case (Byte) 0x43: {
            Byte b1 = dataB[1];
            NSLog(@"detail_info_a:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            
            if (b1 == 0xF0) {
                //save dayinfo
                NSString *dayStr = [NSString stringWithFormat:@"20%02x%02x%02x",dataB[2],dataB[3],dataB[4]];
                Byte seq = dataB[5];
                Byte type = dataB[6];
           if (seq == 0x01){
                
                NSInteger distance = (NSInteger)((dataB[6] & 0XFF) << 16) + (int)((dataB[7] & 0XFF) << 8) + (int)(dataB[8] & 0XFF);//单位0.01km
                NSInteger minute = (int)((dataB[9] & 0XFF) << 8) + (int)(dataB[10] & 0XFF);
                NSLog(@"distance : %d , minute : %d",distance, minute);
            }
            
            break;
        }
        case (Byte) 0x87: {
            NSLog(@"读取某天总运动信息失败");
            break;
        }
        case (Byte) 0x08: {
            NSLog(@"目标达成率:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取某天目标达成率成功");
            break;
        }
        case (Byte) 0x88: {
            NSLog(@"读取某天目标达成率失败");
            break;
        }
        case (Byte) 0x0A: {
            NSLog(@"停止实时计步模式成功");
            break;
        }
        case (Byte) 0x8A: {
            NSLog(@"停止实时计步模式失败");
            break;
        }
        case (Byte) 0x0B: {
            NSLog(@"设置目标成功");
            break;
        }
        case (Byte) 0x8B: {
            NSLog(@"设置目标失败");
            break;
        }
        case (Byte) 0x4B: {
            NSLog(@"取得目标:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"取得目标成功");
            break;
        }
        case (Byte) 0xCB: {
            NSLog(@"取得目标失败");
            break;
        }
        case (Byte) 0x0D: {
            NSLog(@"激活设备成功");
            break;
        }
        case (Byte) 0x8D: {
            NSLog(@"激活设备失败");
            break;
        }
        case (Byte) 0x12: {
            NSLog(@"恢复出厂设置成功");
            break;
        }
        case (Byte) 0x92: {
            NSLog(@"恢复出厂设置失败");
            break;
        }
        case (Byte) 0x13: {
            NSLog(@"读取设备电量:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSInteger energy = dataB[1];
//            if (_electricityDelegate && [_electricityDelegate respondsToSelector:@selector(refreshEnergyWithEnergy:)]) {
//                [_electricityDelegate refreshEnergyWithEnergy:energy];
            }
            NSLog(@"读取设备电量成功");
            break;
        }
        case (Byte) 0x93: {
            NSLog(@"读取设备电量失败");
            break;
        }
        case (Byte) 0x20: {
            NSLog(@"设备绑定成功");
            break;
        }
        case (Byte) 0xA0: {
            NSLog(@"设备绑定失败");
            break;
        }
        case (Byte) 0x21: {
            NSLog(@"绑定应答成功");
            break;
        }
        case (Byte) 0xA1: {
            NSLog(@"绑定应答失败");
            break;
        }
        case (Byte) 0x22: {
            NSLog(@"读取MAC地址:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取MAC地址成功");
            NSString *macStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6]];
            break;
        }
        case (Byte) 0xA2: {
            NSLog(@"读取MAC地址失败");
            break;
        }
        case (Byte) 0x23: {
            NSLog(@"设置闹钟成功");
            break;
        }
        case (Byte) 0xA3: {
            NSLog(@"设置闹钟失败");
            break;
        }
        case (Byte) 0x24: {
            NSInteger number = dataB[1];
            Byte enabel = dataB[2];
            NSString *hourString = [NSString stringWithFormat:@"%02x",dataB[3]];
            NSInteger hour = hourString.integerValue;
            NSString *minString = [NSString stringWithFormat:@"%02x",dataB[4]];
            NSInteger min = minString.integerValue;
            //0x01星期日、0x02星期一、0x04星期二、0x08星期三、0x10星期四、0x20星期五、0x40星期六
            Byte status = 0x00;
            if (dataB[5]) {
                status += 0x01;
            }
            if (dataB[6]) {
                status += 0x02;
            }
            if (dataB[7]) {
                status += 0x04;
            }
            if (dataB[8]) {
                status += 0x08;
            }
            if (dataB[9]) {
                status += 0x10;
            }
            if (dataB[10]) {
                status += 0x20;
            }
            if (dataB[11]) {
                status += 0x40;
            }
//            if (_normalClockDelegate && [_normalClockDelegate respondsToSelector:@selector(loadClockWithNumber:andStatus:andHour:andMin:andEnable:)]) {
//                [_normalClockDelegate loadClockWithNumber:number andStatus:status andHour:hour andMin:min andEnable:enabel];
//            }
            NSLog(@"读取闹钟:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取闹钟成功");
            break;
        }
        case (Byte) 0xA4: {
            NSLog(@"读取闹钟失败");
            break;
        }
        case (Byte) 0x25: {
            NSLog(@"设置运动时段成功");
            break;
        }
        case (Byte) 0xA5: {
            NSLog(@"设置运动时段失败");
            break;
        }
        case (Byte) 0x26: {
            NSLog(@"读取运动时段:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取运动时段成功");
            break;
        }
        case (Byte) 0xA6: {
            NSLog(@"读取运动时段失败");
            break;
        }
        case (Byte) 0x27: {
            NSLog(@"读取软件版本号:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取软件版本号成功");
            break;
        }
        case (Byte) 0xA7: {
            NSLog(@"读取软件版本号失败");
            break;
        }
        case (Byte) 0x2E: {
            NSLog(@"MCU软复位指令成功");
            break;
        }
        case (Byte) 0xAE: {
            NSLog(@"MCU软复位指令失败");
            break;
        }
        case (Byte) 0x36: {
            NSLog(@"传送马达振动信号成功");
            break;
        }
        case (Byte) 0xB6: {
            NSLog(@"传送马达振动信号失败");
            break;
        }
        case (Byte) 0x37: {
            NSLog(@"设置时间模式成功");
            break;
        }
        case (Byte) 0xB7: {
            NSLog(@"设置时间模式失败");
            break;
        }
        case (Byte) 0x38: {
            NSLog(@"读取时间模式:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取时间模式成功");
            break;
        }
        case (Byte) 0xB8: {
            NSLog(@"读取时间模式失败");
            break;
        }
        case (Byte) 0x3D: {
            NSLog(@"设置蓝牙设备名称成功");
            break;
        }
        case (Byte) 0xBD: {
            NSLog(@"设置蓝牙设备名称失败");
            break;
        }
        case (Byte) 0x3E: {
            NSLog(@"读取蓝牙设备名称:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取蓝牙设备名称成功");
            break;
        }
        case (Byte) 0xBE: {
            NSLog(@"读取蓝牙设备名称失败");
            break;
        }
        case (Byte) 0x3F: {
            NSLog(@"设置产品信息成功");
            break;
        }
        case (Byte) 0xBF: {
            NSLog(@"设置产品信息失败");
            break;
        }
        case (Byte) 0x40: {
            NSLog(@"读取产品信息:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"读取产品信息成功");
            break;
        }
        case (Byte) 0xC0: {
            NSLog(@"读取产品信息失败");
            break;
        }
        case (Byte) 0x47: {
            NSLog(@"固件升级命令成功");
            break;
        }
        case (Byte) 0xC7: {
            NSLog(@"固件升级命令失败");
            break;
        }
        case (Byte) 0x48: {
            NSLog(@"获取当前运动信息:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSLog(@"获取当前运动信息成功");
            break;
        }
        case (Byte) 0xC8: {
            NSLog(@"获取当前运动信息失败");
            break;
        }
        case (Byte) 0x69: {
            NSLog(@"成功获取实时心率:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            NSInteger heartRate = dataB[1] & 0xFF;
            NSLog(@"实时心率： %@", @(heartRate));
            break;
        }
            
        case (Byte) 0xE9: {
            NSLog(@"获取实时心率失败");
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kNtfMgrBandHeartOperate object:[MSBaseResult instanceWith:NO error:error data:nil mid:-1]];
            break;
        }
            
        case (Byte) 0x6A: {
            NSLog(@"成功关闭实时心率");
            break;
        }
        case (Byte) 0xEA: {
            NSLog(@"关闭实时心率失败");
            break;
        }
            
            
        case (Byte) 0x6B: {
            NSLog(@"成功获取某天心率:%@",[NSString stringWithFormat:@"%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",dataB[0],dataB[1],dataB[2],dataB[3],dataB[4],dataB[5],dataB[6],dataB[7],dataB[8],dataB[9],dataB[10],dataB[11],dataB[12],dataB[13],dataB[14],dataB[15]]);
            if (dataB[1] == 0xF0) {
                NSString *dayStr = [NSString stringWithFormat:@"20%02x%02x%02x",dataB[2],dataB[3],dataB[4]];
                NSInteger count = dataB[5] & 0XFF;

                NSLog(@"%@记录条数:%@", dayStr, @(count));

            } else if (dataB[1] == 0xAA) {
                NSString *timeStr = [NSString stringWithFormat:@"%02x%02x%02x",dataB[3],dataB[4],dataB[5]];
            } else if (dataB[1] == 0xA0) {
                NSInteger innerSeq = dataB[2] & 0xFF;
                NSLog(@"数据包刻度：%@", @(innerSeq));
                NSInteger heartRateSum = 0;
                NSInteger heartRateCount = 0;
                for (NSInteger i = 3; i < 15; i++) {
                    NSInteger heartRate = dataB[i] & 0xFF;
                    if (heartRate > 0) {
                        heartRateSum += heartRate;
                        heartRateCount++;
                    }
                }
                NSInteger heartRateAvg = heartRateSum / heartRateCount;
            }
            
            break;
        }
            
        case (Byte) 0xEB: {
            NSLog(@"获取某天心率失败");
            break;
        }
        default:{
            break;
        }
    }
}

@end
