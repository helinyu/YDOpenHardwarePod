//
//  YDThirdPartLoader.h
//  YDOpenHardwareSimple
//
//  Created by 张旻可 on 16/6/29.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDThirdPardModel;

@interface YDThirdPartLoader : NSObject

+ (instancetype)shared;
- (void)load;
- (NSArray<YDThirdPardModel *> *)datas;
- (void)toThirdPartVC;

@end
