//
//  YDSongEnty.m
//  _YDBridgeWebViewController
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDAudioVideo.h"

@implementation YDAudioVideo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _title = @"";
        _urlString = @"";
        _artist = @"";
        _imageUrlString = @"";
        _lyric = @"";
        _albumTitle = @"";
        _currentTime = 0;
        _totalTime = 0;
    }
    return self;
}

@end

@implementation YDAudioVideoList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioVideo = [NSArray<YDAudioVideo *> new];
    }
    return self;
}

@end
