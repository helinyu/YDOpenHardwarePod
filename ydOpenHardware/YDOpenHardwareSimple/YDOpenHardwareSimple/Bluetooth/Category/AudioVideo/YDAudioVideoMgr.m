//
//  YDAudioVideoMgr.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDAudioVideoMgr.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YDBundle.h"
#import <UIKit/UIkit.h>
#import "YYImage.h"


#import "YDAudioVideo.h"

@interface YDAudioVideoMgr ()

@property (nonatomic, strong) YDAudioVideo *audioVideo;

//@property (nonatomic ,strong) AVQueuePlayer *queuePlayer;
@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, assign) BOOL isPlay;

@end

@implementation YDAudioVideoMgr

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self beginReceiVingRemoteControlEvents];
    }
    return self;
}

- (void)dealloc {
    [self endReceivingRemoteControlEvents];
}

- (void)beginReceiVingRemoteControlEvents {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)endReceivingRemoteControlEvents {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)PlayWithFilePath:(NSString *)filePath type:(NSString *)type {
    NSString *wholeFilePath = [YDBundle bundlePath:filePath type:type];
    [self playWithFilePath:wholeFilePath];
}

- (void)playWithFilePath:(NSString *)wholeFilePath {
    NSURL *url = [NSURL fileURLWithPath:wholeFilePath];
    [self playWithUrl:url];
}

- (void)playWithUrl:(NSURL *)url {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    if (!_player) {
//        _player = [[AVQueuePlayer alloc] initWithPlayerItem:Item];
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
    }
    [_player play];
    _isPlay = YES;
    [self _configureBackgroundModeNowPlayingInfo];
}

- (void)playEnableBgModelWithAudio:(YDAudioVideo *)audio {
    [self playEnableBackgroundMode];
    [self playWithAudio:audio];
}

- (void)playWithAudio:(YDAudioVideo *)audio {
    _audioVideo = audio;
    [self playWithUrl:[NSURL URLWithString:audio.urlString]];
}

- (void)playEnableBackgroundMode {
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"后台播放设置失败");
    }
}

- (void)playEnableBackgroundModeWithFilePath:(NSString*)wholeFilePath {
    [self playEnableBackgroundMode];
    [self playWithFilePath:wholeFilePath];
}

- (void)playEnableBackgroundModeWithAsset:(AVAsset *)asset {
    NSError *backgroudError = nil;
    NSError *activeError = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:&activeError];
    if (activeError) {
        NSLog(@"激活失败");
    }
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&backgroudError];
    if (backgroudError) {
        NSLog(@"后台播放设置失败");
    }
}

#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case UIEventSubtypeNone:
                break;
            case  UIEventSubtypeRemoteControlPlay:
            {
                if (!_isPlay) {
                    [_player play];
                    _isPlay = YES;
                }
            }
                break;
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlStop:
            {
                [_player pause];
                _isPlay = NO;
            }
                break;
            case UIEventSubtypeMotionShake:
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                break;
            case UIEventSubtypeRemoteControlNextTrack:
            {
//                [_player advanceToNextItem];
                if (!_isPlay) {
                    _isPlay = YES;
                }
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                break;
            default:
                break;
        }
    }
}

- (void)_configureBackgroundModeNowPlayingInfo {
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:_audioVideo.imageUrlString]];
    NSDictionary *dic = @{MPMediaItemPropertyTitle:_audioVideo.title,MPMediaItemPropertyArtist:_audioVideo.artist,MPMediaItemPropertyArtwork:artWork};
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}


@end
