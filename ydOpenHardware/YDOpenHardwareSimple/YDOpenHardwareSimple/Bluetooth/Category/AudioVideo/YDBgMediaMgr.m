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

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

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
        _nowSecondTime = [[NSDate date] timeIntervalSince1970];
        [wSelf setLockPlayerWithInfo:_media];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [cmdCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"暂停播放");
        NSTimeInterval nowSecondTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval lastTime = _media.currentTime;
        _media.currentTime = (nowSecondTime - _nowSecondTime) + lastTime;
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
    AudioSessionSetActive(YES);
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSMutableDictionary * songDict = @{}.mutableCopy;
    [songDict setObject:media.title forKey:MPMediaItemPropertyTitle];
    [songDict setObject:media.artist forKey:MPMediaItemPropertyArtist];
    [songDict setObject:@(media.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [songDict setObject:@(media.totalTime) forKey:MPMediaItemPropertyPlaybackDuration];
    NSLog(@"thread :%@",[NSThread currentThread]);
    
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:media.imageUrlString] options:YYWebImageOptionShowNetworkActivity progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            NSLog(@" block thread :%@",[NSThread currentThread]);
            dispatch_main_async_safe(^{
                NSLog(@"safe block thread :%@",[NSThread currentThread]);
                MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
                [songDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
                [songDict setObject:@(MPMediaTypeAnyAudio) forKey:MPMediaItemPropertyMediaType];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
            });
        }
    }];
 
}

@end
