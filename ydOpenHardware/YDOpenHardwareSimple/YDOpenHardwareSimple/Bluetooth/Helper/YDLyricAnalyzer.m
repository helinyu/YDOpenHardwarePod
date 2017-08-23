//
//  YDLyricAnalyzer.m
//  TestAudio
//
//  Created by Aka on 2017/8/23.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "YDLyricAnalyzer.h"
#import "YDOneLyricUnit.h"

@interface YDLyricAnalyzer ()

@property (nonatomic, strong) NSMutableArray *times;
@property (nonatomic, strong) NSMutableArray *lyrics;

@end

@implementation YDLyricAnalyzer


-(NSMutableArray *)lrcArray
{
    if (_lrcArray == nil) {
        _lrcArray = [[NSMutableArray alloc] init];
    }return _lrcArray;
}

- (NSArray *)times {
    return _times;
}

-(NSMutableArray *)analyzerLrcByPath:(NSString *)path
{
    _times = @[].mutableCopy;
    _lyrics = @[].mutableCopy;
    [self  analyzerLrc:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
    return self.lrcArray;
}

- (NSArray *)analyzerByUrlString:(NSString *)urlString {
    _times = @[].mutableCopy;
    _lyrics = @[].mutableCopy;
    NSError *erro = nil;
    NSString *lyricUTF8UrlSting = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:lyricUTF8UrlSting];
    NSString *lyrics = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&erro];
    [self analyzerLrc:lyrics];
    return self.lrcArray;
}

-(NSMutableArray *)analyzerLrcBylrcString:(NSString *)string{
    _times = @[].mutableCopy;
    _lyrics = @[].mutableCopy;
    [self  analyzerLrc:string];
    return self.lrcArray;
}

//根据换行符\n分割字符串，获得包含每一句歌词的数组
-(void)analyzerLrc:(NSString *)lrcConnect
{
    NSArray *lrcConnectArray = [lrcConnect componentsSeparatedByString:@"\n"];
    NSMutableArray *lrcConnectArray1 =[[NSMutableArray  alloc] initWithArray: lrcConnectArray ];
    for (NSUInteger i = 0;  i < [lrcConnectArray1  count]  ;i++ ) {
        if ([lrcConnectArray1[i]   length] == 0 ) {
            [lrcConnectArray1  removeObjectAtIndex:i];
            i--;
        }
    }
    [self analyzerEachLrc:lrcConnectArray1];
}

//删除没有用的字符
-(NSMutableArray *)deleteNoUseInfo:(NSMutableArray *)lrcmArray
{
    for (NSUInteger i = 0; i < [lrcmArray count] ; i++)
    {
        unichar  ch = [lrcmArray[i] characterAtIndex:1];
        if(!isnumber(ch)){
            [lrcmArray removeObjectAtIndex:i];
            i--;
        }
    }
    return lrcmArray;
}

//解析每一行歌词字符，获得时间点和对应的歌词
-(void)analyzerEachLrc:(NSMutableArray *)lrcConnectArray
{
    for (NSUInteger i = 0;  i < [lrcConnectArray  count]; i++) {
        NSArray * eachLrcArray = [lrcConnectArray[i] componentsSeparatedByString:@"]"];
        NSString * lrc = [eachLrcArray  lastObject];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df  setDateFormat:@"[mm:ss.SS"];
        NSDate * date1 = [df  dateFromString:eachLrcArray[0] ];
        NSDate *date2 = [df dateFromString:@"[00:00.00"];
        NSTimeInterval  interval1 = [date1  timeIntervalSince1970];
        NSTimeInterval  interval2 = [date2  timeIntervalSince1970];
        interval1 -= interval2;
        if (interval1 < 0) {
            interval1 *= -1;
        }
        
        YDOneLyricUnit *unitLyric = [YDOneLyricUnit new];
        unitLyric.oneLyric = lrc;
        unitLyric.time = interval1;
        [_times addObject:@(interval1)];
        [_lyrics addObject:lrc];
        [self.lrcArray addObject:unitLyric];
    }
    !_timesBlock?:_timesBlock(_times);
    !_lyricsBlock?:_lyricsBlock(_lyrics);
    
}

@end
