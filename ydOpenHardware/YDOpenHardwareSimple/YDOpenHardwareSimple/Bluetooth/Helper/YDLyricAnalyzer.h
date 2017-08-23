//
//  YDLyricAnalyzer.h
//  TestAudio
//
//  Created by Aka on 2017/8/23.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDLyricAnalyzer : NSObject

@property(nonatomic,strong)NSMutableArray * lrcArray;

/*
 * 文件加载
 */

-(NSMutableArray *)analyzerLrcByPath:(NSString *)path;


/*
 * 直接歌词加载
 */
-(NSMutableArray *)analyzerLrcBylrcString:(NSString *)string;

//url 的方式加载歌词
- (NSArray *)analyzerByUrlString:(NSString *)urlString;


@property (nonatomic, strong, readonly) NSArray *times;
@property (nonatomic, strong, readonly) NSArray *pureLyrics;

typedef void (^NSArrayBlock)(NSArray *arrs);
@property (nonatomic, copy) NSArrayBlock timesBlock;
@property (nonatomic, copy) NSArrayBlock lyricsBlock;

@end
