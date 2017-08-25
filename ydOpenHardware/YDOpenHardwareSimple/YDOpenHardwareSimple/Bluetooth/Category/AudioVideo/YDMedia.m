//
//  YDSongEnty.m
//  _YDBridgeWebViewController
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDMedia.h"

@implementation YDMedia

- (instancetype)init
{
    self = [super init];
    if (self) {
        _title = @"";
        _mediaUrlString = @"";
        _artist = @"";
        _composer = @"";
        _imageUrlString = @"";
        _lyric = @"";
        _lyricUrlString = @"";
        _albumTitle = @"";
        _currentTime = 0;
        _totalTime = 0;
        _composer = @"";
    }
    return self;
}


+ (instancetype)medialWithTitle:(NSString *)title mediaUrl:(NSString *)mediaUrlStr imageUrl:(NSString *)imageUrl artist:(NSString *)artist currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    YDMedia *media = [YDMedia new];
    media.title = title;
    media.mediaUrlString = mediaUrlStr;
    media.imageUrlString = imageUrl;
    media.artist = artist;
    media.currentTime = currentTime;
    media.totalTime = totalTime;
    return media;
}


@end

@implementation YDMediaList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _media = [NSArray<YDMedia *> new];
    }
    return self;
}

@end
