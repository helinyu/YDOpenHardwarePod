//
//  YDBgMediaMgr.m
//  SportsBar
//
//  Created by Aka on 2017/8/24.
//  Copyright © 2017年 yuedong. All rights reserved.
//

#import "YDBgMediaMgr.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YDMedia.h"
#import "YYWebImage.h"

@interface YDBgMediaMgr ()

@property (nonatomic, strong) YDMedia *media;
@property (nonatomic, assign) NSTimeInterval nowSecondTime;

@end

@implementation YDBgMediaMgr

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}


- (void)createRemoteCommandCenter {
    MPRemoteCommandCenter *cmdCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    __weak typeof (self) wSelf = self;
    [cmdCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"播放");
        NSTimeInterval nowSecondTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval lastTime = _media.currentTime;
        _media.currentTime = (nowSecondTime - _nowSecondTime) + lastTime;
        [wSelf setLockPlayerWithInfo:_media];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [cmdCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"暂停播放");
        NSTimeInterval nowSecondTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval lastTime = _media.currentTime;
        _media.currentTime = (nowSecondTime - nowSecondTime) + lastTime;
        [wSelf setLockPlayerWithInfo:_media];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [cmdCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)dealloc {
    [self removeObserver];
}

- (void)removeObserver{
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand removeTarget:self];
    [commandCenter.pauseCommand removeTarget:self];
    [commandCenter.changePlaybackPositionCommand removeTarget:self];
}

- (void)setLockPlayerWithInfo:(YDMedia *)media {
    _media = media;
    _nowSecondTime = [NSDate date].timeIntervalSince1970;
    NSLog(@"设置后台播放信息");
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSMutableDictionary * songDict = @{}.mutableCopy;
    [songDict setObject:@"test" forKey:MPMediaItemPropertyTitle];
    [songDict setObject:@"test" forKey:MPMediaItemPropertyArtist];
    UIImage *image = [UIImage imageNamed:@"backgroundImage5.jpg"];
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:image]
                 forKey:MPMediaItemPropertyArtwork];
    [songDict setObject:@(MPMediaTypeAnyAudio) forKey:MPMediaItemPropertyMediaType];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];

}

@end
