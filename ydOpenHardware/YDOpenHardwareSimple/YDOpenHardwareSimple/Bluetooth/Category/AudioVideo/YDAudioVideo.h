//
//  YDSongEnty.h
//  _YDBridgeWebViewController
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

// 先实现音乐
@interface YDAudioVideo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *imageUrlString; // 也可能是设置imageName
@property (nonatomic, copy) NSString *artist; // 作者
@property (nonatomic, strong) YDAudioVideo *nextEnty;

@end


@interface YDAudioVideoList : NSObject

@property (nonatomic, strong) NSArray<YDAudioVideo *> *audioVideo;

@end
