//
//  ThirdPartSDK.h
//  YDOpenHardwareThirdPart
//
//  Created by 张旻可 on 16/2/15.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
//
typedef NS_ENUM(NSInteger,RegisterAppState) {//注册app状态
    RegisterAppStateSuccess = 0,//成功
    RegisterAppStateFailParamsError = 1,//appid错误
    RegisterAppStateFailVersionTooLow = 2//版本号过低或过高，需要新的SDK请联系客服
};

//验证app的block，将状态返回
typedef void(^RegisterAppBlock)(RegisterAppState registerAppState);

@interface ThirdPartSDK : NSObject

+ (void)registerApp: (NSString *)appid;

@end
