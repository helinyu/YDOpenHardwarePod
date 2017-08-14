//
//  YDOpenHardwareSDK.h
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/2.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//! Project version number for YDOpenHardwareSDK.
FOUNDATION_EXPORT double YDOpenHardwareSDKVersionNumber;

//! Project version string for YDOpenHardwareSDK.
FOUNDATION_EXPORT const unsigned char YDOpenHardwareSDKVersionString[];

static NSString *const YDNtfOpenHardwareAppDidFinishLaunch = @"YDNtfOpenHardwareAppDidFinishLaunch";
static NSString *const YDNtfOpenHardwareAppWillResignActive = @"YDNtfOpenHardwareAppWillResignActive";
static NSString *const YDNtfOpenHardwareAppDidEnterBackground = @"YDNtfOpenHardwareAppDidEnterBackground";
static NSString *const YDNtfOpenHardwareAppWillEnterForeground = @"YDNtfOpenHardwareAppWillEnterForeground";
static NSString *const YDNtfOpenHardwareAppDidBecomeActive = @"YDNtfOpenHardwareAppDidBecomeActive";
static NSString *const YDNtfOpenHardwareAppWillTerminate = @"YDNtfOpenHardwareAppWillTerminate";

// In this header, you should import all the public headers of your framework using statements like #import <YDOpenHardwareSDK/PublicHeader.h>

#import <YDOpenHardwareSDK/YDOpenHardwareManager.h>
#import <YDOpenHardwareSDK/YDOpenHardwareDataProvider.h>
#import <YDOpenHardwareSDK/YDOpenHardwareSDKDefine.h>
#import <YDOpenHardwareSDK/YDOpenHardwareHeartRate.h>
#import <YDOpenHardwareSDK/YDOpenHardwareIntelligentScale.h>
#import <YDOpenHardwareSDK/YDOpenHardwarePedometer.h>
#import <YDOpenHardwareSDK/YDOpenHardwareSleep.h>
#import <YDOpenHardwareSDK/YDOpenHardwareUser.h>
