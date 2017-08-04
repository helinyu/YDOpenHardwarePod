//
//  YDOpenHardwareUser.h
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/23.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const YDNtfOpenHardwareUserChange = @"YDNtfOpenHardwareUserChange";

@interface YDOpenHardwareUser : NSObject

@property (nonatomic, copy) NSString *province; //所在省
@property (nonatomic, copy) NSString *city; //城市
@property (nonatomic, strong) NSNumber *userID; //用户id
@property (nonatomic, strong) NSNumber *rank; //用户等级
@property (nonatomic, strong) NSNumber *sex; //0为男，1为女
@property (nonatomic, copy) NSString *nick; //用户昵称
@property (nonatomic, copy) NSString *headImageUrl; //头像url

@property (nonatomic, copy) NSString *loveSports; //用户喜欢的运动 逗号隔开
@property (nonatomic, copy) NSString *phone; //用户手机
@property (nonatomic, copy) NSString *signature; //用户签名

@property (nonatomic, strong) NSDate *birth; //生日
@property (nonatomic, strong) NSNumber *height; //身高cm
@property (nonatomic, strong) NSNumber *weight; //重量g

@end
