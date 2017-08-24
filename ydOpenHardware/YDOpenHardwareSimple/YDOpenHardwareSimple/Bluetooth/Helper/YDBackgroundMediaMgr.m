//
//  YDAudioMgr.m
//  Test_Audio
//
//  Created by Aka on 2017/8/22.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "YDBackgroundMediaMgr.h"
#import "YDLyricAnalyzer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YDOneLyricUnit.h"
#import <notify.h>
#import "YDLockScreenMgr.h"
#import "YDAudioVideo.h"

@interface YDBackgroundMediaMgr ()<UITableViewDataSource,UITableViewDelegate>
{
    id _playerTimeObserver;
    BOOL _isDragging;
    UIImage * _lastImage;//最后一次锁屏之后的歌词海报
}

//用来显示锁屏歌词
@property (nonatomic, strong) UITableView * lockScreenTableView;
//锁屏图片视图,用来绘制带歌词的image
@property (nonatomic, strong) UIImageView * lrcImageView;;

@property (nonatomic, strong) NSArray *times;
@property (nonatomic, strong) NSArray *pureLyrics;

@property (nonatomic, strong) YDAudioVideo *audioVideo;
@property (nonatomic, assign) NSTimeInterval wholeTime;
@property (nonatomic, assign) NSTimeInterval nowSecondTime;

@end

@implementation YDBackgroundMediaMgr

+ (instancetype)shared {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}
    
- (void)loadBaseWithAudioVideo:(YDAudioVideo *)audioVideo {
    _audioVideo = audioVideo;
    [self _getLrcsWithParams:audioVideo];
}
    
- (AVPlayer *)player {
    if (_player == nil) {
        if (_audioVideo.mediaUrlString.length > 0) {
            _player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:_audioVideo.mediaUrlString]];
        }
    }
    return _player;
}

- (NSTimeInterval)getAudioTotalTime {
    CMTime total = self.player.currentItem.duration;
    return CMTimeGetSeconds(total);
}
    
//获得歌词数组
- (NSArray *)_getLrcsWithParams:(YDAudioVideo *)media{
    YDLyricAnalyzer *analyzer = [YDLyricAnalyzer new];
    if (media.lyric.length > 0) {
        self.lrcs =  [analyzer analyzerLrcBylrcString:media.lyric];
    }else if (media.lyricUrlString.length > 0) {
        self.lrcs = [analyzer analyzerByUrlString:media.lyricUrlString];
    }
    NSLog(@"self.lrcs count; %lu",(unsigned long)self.lrcs.count);
    _times = analyzer.times;
    _pureLyrics = analyzer.pureLyrics;
    return self.lrcs;
}
    
- (void)createRemoteCommandCenter {
    MPRemoteCommandCenter *cmdCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    __weak typeof (self) wSelf = self;
    [cmdCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"播放");
        NSTimeInterval nowSecondTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval lastTime = _audioVideo.currentTime;
        _audioVideo.currentTime = (nowSecondTime - _nowSecondTime) + lastTime;
        [wSelf setLockPlayerWithInfo:_audioVideo];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [cmdCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"暂停播放");
        NSTimeInterval nowSecondTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval lastTime = _audioVideo.currentTime;
        _audioVideo.currentTime = (nowSecondTime - nowSecondTime) + lastTime;
        [wSelf setLockPlayerWithInfo:_audioVideo];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //在控制台拖动进度条调节进度（仿QQ音乐的效果）
    [cmdCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        CMTime totlaTime = self.player.currentItem.duration;
        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
        [self.player seekToTime:CMTimeMake(totlaTime.value*playbackPositionEvent.positionTime/CMTimeGetSeconds(totlaTime), totlaTime.timescale) completionHandler:^(BOOL finished) {
        }];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

- (void)dealloc {
    [self removeObserver];
}
    //移除观察者
- (void)removeObserver{
    
    [self.player removeTimeObserver:_playerTimeObserver];
    _playerTimeObserver = nil;
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.likeCommand removeTarget:self];
    [commandCenter.dislikeCommand removeTarget:self];
    [commandCenter.bookmarkCommand removeTarget:self];
    [commandCenter.nextTrackCommand removeTarget:self];
    [commandCenter.skipForwardCommand removeTarget:self];
    [commandCenter.changePlaybackPositionCommand removeTarget:self];
}
    
//在具体的控制器或其它类中捕获处理远程控制事件,当远程控制事件发生时触发该方法, 该方法属于UIResponder类，iOS 7.1 之前经常用
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    NSLog(@"%ld",(long)event.type);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"songRemoteControlNotification" object:self userInfo:@{@"eventSubtype":@(event.subtype)}];
}
    
    //播放控制和监测
- (void)playControl{
    
    [self enableBackground];
    
    __weak typeof (self) wSelf = self;
    
    _playerTimeObserver = [wSelf.player addPeriodicTimeObserverForInterval:CMTimeMake(6000, 60000) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {

        //监听锁屏状态 lock=1则为锁屏状态
        NSLog(@"time value : %lld, timescale : %d, time flag :%d, second :%lld",time.value,time.timescale,time.flags,time.value/time.timescale);
        uint64_t locked;
        __block int token = 0;
        notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
            NSLog(@"noitify lock state");
        });
        notify_get_state(token, &locked);

        //监听屏幕点亮状态 screenLight = 1则为变暗关闭状态
        uint64_t screenLight;
        __block int lightToken = 0;
        notify_register_dispatch("com.apple.springboard.hasBlankedScreen",&lightToken,dispatch_get_main_queue(),^(int t){
            NSLog(@"lock the state");
        });
        notify_get_state(lightToken, &screenLight);

        BOOL isShowLyricsPoster = NO;
        if (screenLight == 0 && locked == 1) {
            //点亮且锁屏时
            isShowLyricsPoster = YES;
        }else if(screenLight){
            return;
        }
        CGFloat currentTime = CMTimeGetSeconds(time);
        CMTime total = self.player.currentItem.duration;
        CGFloat totalTime = CMTimeGetSeconds(total);
        NSLog(@"currrent Time : %f , totalTime :%f",currentTime,totalTime);
        
        for ( int i = (int)(self.lrcs.count - 1); i >= 0 ;i--) {
            YDOneLyricUnit * lrc = self.lrcs[i];
            if (lrc.time < currentTime) {
                if (isShowLyricsPoster) {
                    [self.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"lyrcScroll" object:@{@"backgroundLight":@(NO),@"row":@(i)}];
                }
                break;
            }
        }

        //展示锁屏歌曲信息，上面监听屏幕锁屏和点亮状态的目的是为了提高效率
        [self showLockScreenTotaltime:totalTime andCurrentTime:currentTime isShow:isShowLyricsPoster];
    }];
    
}

- (void)enableBackground {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)setLockPlayerInfo {
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:_audioVideo.title forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:_audioVideo.artist forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:_audioVideo.albumTitle forKey:MPMediaItemPropertyAlbumTitle];
    UIImage *ircImage ;
    if (_audioVideo.imageUrlString.length <= 0) {
        NSLog(@"must deliver the image url string");
        return;
    }
    if ([_audioVideo.imageUrlString hasPrefix:@"http"]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_audioVideo.imageUrlString] options:NSDataReadingUncached error:nil];
        ircImage = [UIImage imageWithData:data scale:2.f];
    }else{
        ircImage = [UIImage imageNamed:_audioVideo.imageUrlString];
    }
    //设置显示的海报图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:ircImage]
                 forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];

}

- (void)setLockPlayerWithInfo:(YDAudioVideo *)info {
    _audioVideo = info;
    _nowSecondTime = [NSDate date].timeIntervalSince1970;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSMutableDictionary * songDict = @{}.mutableCopy;
    [songDict setObject:@(info.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
    [songDict setObject:@(info.totalTime) forKey:MPMediaItemPropertyPlaybackDuration];//歌曲总时间设置
    [songDict setObject:info.title forKey:MPMediaItemPropertyTitle];
    [songDict setObject:info.artist forKey:MPMediaItemPropertyArtist];
    UIImage *ircImage ;
    if (info.imageUrlString.length <= 0) {
        NSLog(@"must deliver the image url string");
        return;
    }
    if ([info.imageUrlString hasPrefix:@"http"]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:info.imageUrlString] options:NSDataReadingUncached error:nil];
        ircImage = [UIImage imageWithData:data scale:2.f];
    }else{
        ircImage = [UIImage imageNamed:_audioVideo.imageUrlString];
    }
    if (!ircImage) {
        NSLog(@"请传入背景图片");
        return;
    }
    //设置显示的海报图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:ircImage]
                 forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
}

- (void)playByTheLyricsTimes {
    [self enableBackground];
    
    __weak typeof (self) wSelf = self;
    __block NSInteger index = 0;
    if (!(self.times.count >0)) {
        return;
    }
    
    NSLog(@"player status : %d",self.player.status);
    _playerTimeObserver = [self.player addBoundaryTimeObserverForTimes:self.times queue:dispatch_get_main_queue() usingBlock:^{
        [YDLockScreenMgr addObserverLockAndLightScreenBlock:^(BOOL lockAndLightScreen) {
            if (lockAndLightScreen) {
                [wSelf.lockScreenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"lyrcScroll" object:@{@"backgroundLight":@(NO),@"row":@(index)}];
            }
            float totalTime = CMTimeGetSeconds(wSelf.player.currentItem.duration);
            [wSelf showLockScreenTotaltime:totalTime andCurrentTime:[wSelf.times[index] integerValue] isShow:lockAndLightScreen];
            NSLog(@"times : %ld",(long)[wSelf.times[index] integerValue]);
            index++;
        }];
     }];
}
    
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime isShow:(BOOL)isShow {
    
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:_audioVideo.title forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [songDict setObject:_audioVideo.artist forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [songDict setObject:_audioVideo.albumTitle forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];

    UIImage *ircImage ;
    if (_audioVideo.imageUrlString.length <= 0) {
        NSLog(@"must deliver the image url string");
        return;
    }
    if ([_audioVideo.imageUrlString hasPrefix:@"http"]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_audioVideo.imageUrlString] options:NSDataReadingUncached error:nil];
        ircImage = [UIImage imageWithData:data scale:2.f];
    }else{
        ircImage = [UIImage imageNamed:_audioVideo.imageUrlString];
    }
    
    if (isShow) {
        
        //制作带歌词的海报
        if (!_lrcImageView) {
            _lrcImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480,800)];
        }
        
        //主要为了把歌词绘制到图片上，已达到更新歌词的目的
        [_lrcImageView addSubview:self.lockScreenTableView];
        _lrcImageView.image = ircImage;
        _lrcImageView.backgroundColor = [UIColor blackColor];
        
        //获取添加了歌词数据的海报图片
        UIGraphicsBeginImageContextWithOptions(_lrcImageView.frame.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_lrcImageView.layer renderInContext:context];
        ircImage = UIGraphicsGetImageFromCurrentImageContext();
        _lastImage = ircImage;
        UIGraphicsEndImageContext();
        
    }else{
        if (_lastImage) {
            ircImage = _lastImage;
        }
    }
    
    //设置显示的海报图片
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:ircImage]
                 forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    
}

- (UITableView *)lockScreenTableView {
    if (!_lockScreenTableView) {
        _lockScreenTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 800 - 44 * 7 + 20, 480, 44 * 3) style:UITableViewStyleGrouped];
        _lockScreenTableView.dataSource = self;
        _lockScreenTableView.delegate = self;
        _lockScreenTableView.separatorStyle = NO;
        _lockScreenTableView.backgroundColor = [UIColor clearColor];
        [_lockScreenTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _lockScreenTableView;
}

#pragma mark -- tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lrcs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    YDOneLyricUnit *unit = _lrcs[indexPath.row];
    cell.textLabel.text = unit.oneLyric;
    cell.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.f;
}


@end
