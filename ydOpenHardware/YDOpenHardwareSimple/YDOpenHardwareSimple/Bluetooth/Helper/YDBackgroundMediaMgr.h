//
//  YDAudioMgr.h
//  Test_Audio
//
//  Created by Aka on 2017/8/22.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@class YDAudioVideo;

@interface YDBackgroundMediaMgr : UIResponder
    
+ (instancetype)shared;

    
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSArray *lrcs;

//two methods to deal with
- (void)playControl; //time the time interval
- (void)playByTheLyricsTimes; //by the times array
- (void)createRemoteCommandCenter;

////background info which is need
- (void)loadBaseWithAudioVideo:(YDAudioVideo *)audioVideo;

- (void)enableBackground;
- (void)setLockPlayerInfo;
- (void)setLockPlayerWithInfo:(YDAudioVideo *)info;

@end
