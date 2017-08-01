//
//  YDThirdPardModel.h
//  YDOpenHardwareSimple
//
//  Created by 张旻可 on 16/6/29.
//  Copyright © 2016年 YD. All rights reserved.
//
/**
 *  测试时必须要填写plugName yInitClassName yInitClassSelector yInitClassSelectorVarList status 其他必填项在第三方自己测试完后与悦动圈联调时提供给悦动圈即可
    测试代码进入第三方界面时会默认选择plist中的最后一个第三方插件初始vc 进入 所以第三方测试时要保证自己填写的dictionary是plist中的最后一个
 */

#import <Foundation/Foundation.h>
#import "MSJsonKit.h"

@interface YDThirdPardModel : NSObject <MSJsonSerializing>

@property (nonatomic, copy) NSString *plugName; //插件名称，建议使用sdk bundleID 必填
@property (nonatomic, copy) NSString *versionCode; //版本号
@property (nonatomic, copy) NSString *md5; //sdkMD5
@property (nonatomic, copy) NSString *bundleInfo; //sdk信息
@property (nonatomic, copy) NSString *name; //名称 必填
@property (nonatomic, copy) NSString *introduction; //描述 必填 最好控制在15个字以内
@property (nonatomic, copy) NSString *downloadUrl; //sdk下载路径
@property (nonatomic, copy) NSString *detailUrl; //详情下载路径
@property (nonatomic, assign) BOOL status; //状态 是否合法 true 为合法
@property (nonatomic, copy) NSString *frameworkName; //framework包名
@property (nonatomic, strong) NSNumber *frameworkSize; //framework大小
@property (nonatomic, copy) NSString *supportClientVersionCode; //支持的客户端最小版本号
@property (nonatomic, copy) NSString *lastSupportClientVersionCode; //支持的客户端最大版本号
@property (nonatomic, copy) NSString *firstSupportUpdateVersionCode; //需要更新的最低framework版本号
@property (nonatomic, copy) NSString *iconUrl; //入口iconUrl 必填
@property (nonatomic, copy) NSString *rootVCName; //插件初始vc类名 必填
@property (nonatomic, strong) NSDate *ctime; //创建时间
@property (nonatomic, strong) NSDate *uptime; //更新时间
@property (nonatomic, strong) NSNumber *thirdPartId; //插件id
@property (nonatomic, copy) NSString *yInitClassName; //插件初始化类名 必填
@property (nonatomic, copy) NSString *yInitClassSelector; //插件初始化方法名 必填
@property (nonatomic, strong) NSArray *yInitClassSelectorVarList; //插件初始化参数 必填

@end
