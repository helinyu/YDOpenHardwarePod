//
//  YDOpenHardwareSDKDefine.h
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/3.
//  Copyright © 2016年 YD. All rights reserved.
//

#ifndef YDOpenHardwareDefine_h
#define YDOpenHardwareDefine_h

#pragma once

#define YD_UNAVAILABLE(x) __attribute__((unavailable(x)))

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

typedef NS_ENUM(NSInteger, YDOpenHardwareOperateState) {//注册app状态
    YDOpenHardwareOperateStateSuccess = 0,//成功
    YDOpenHardwareOperateStateFailParamsError = 1,//appid错误
    YDOpenHardwareOperateStateFailVersionTooLow = 2,//版本号过低或过高，需要新的SDK请联系客服
    YDOpenHardwareOperateStateFailDBError = 3, //数据库操作失败
    YDOpenHardwareOperateStateFailIsExist = 4, //已经存在，或者重复重复操作
    YDOpenHardwareOperateStateFailNotExist = 5, //不存在导致操作失败
    YDOpenHardwareOperateStateHasRegistered = 6, //已经注册
    YDOpenHardwareOperateStateNotRegistered = 7, //没有注册
    YDOpenHardwareOperateStateFailInnerError = 8 //内部错误
};

//操作的block，将状态返回
typedef void(^YDOpenHardwareOperateBlock)(YDOpenHardwareOperateState operateState);
//注册的block，将状态和悦动圈提供的设备id返回
typedef void(^YDOpenHardwareRegisterBlock)(YDOpenHardwareOperateState operateState, NSString *deviceIdentity, NSNumber *userId);
//检测有没有注册的block
typedef void(^YDOpenHardwareRegisterStateBlock)(YDOpenHardwareOperateState operateState, NSString *deviceIdentity);

#endif /* YDOpenHardwareDefine_h */
