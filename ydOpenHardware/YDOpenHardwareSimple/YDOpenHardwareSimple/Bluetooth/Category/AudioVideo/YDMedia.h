//
//  YDSongEnty.h
//  _YDBridgeWebViewController
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

// 先实现音乐
@interface YDMedia : NSObject

@property (nonatomic, copy) NSString *title; // media title
@property (nonatomic, copy) NSString *mediaUrlString; // medial url
@property (nonatomic, copy) NSString *imageUrlString; // 也可能是设置imageName
@property (nonatomic, copy) NSString *artist; // 作词者
@property (nonatomic, copy) NSString *composer; //作曲者

@property (nonatomic, copy) NSString *lyric; // 歌词
@property (nonatomic, copy) NSString *lyricUrlString; // 歌词链接（url） 先判断歌词是否有，再判断歌词链接

@property (nonatomic, copy) NSString *albumTitle; // 专辑名称
@property (nonatomic, assign) NSTimeInterval currentTime; // 已经播放的时长
@property (nonatomic, assign) NSTimeInterval totalTime; // 总的时间长度（可能不需要）

@property (nonatomic, strong) YDMedia *nextEnty;

+ (instancetype)medialWithTitle:(NSString *)title mediaUrl:(NSString *)mediaUrlStr imageUrl:(NSString *)imageUrl artist:(NSString *)artist currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime;

@end

@interface YDMediaList : NSObject

@property (nonatomic, strong) NSArray<YDMedia *> *media;

@end
