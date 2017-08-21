//
//  YDAudioVideoMgr.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAsset;
@class YDAudioVideo;
@class AVQueuePlayer;

@interface YDAudioVideoMgr : NSObject

+ (instancetype)shared;
- (void)beginReceiVingRemoteControlEvents;
- (void)endReceivingRemoteControlEvents;
- (void)PlayWithFilePath:(NSString *)filePath type:(NSString *)type;
- (void)playWithFilePath:(NSString *)wholeFilePath;
- (void)playWithUrl:(NSURL *)url;
- (void)playEnableBackgroundModeWithFilePath:(NSString*)wholeFilePath;

//custom business

- (void)playWithAudio:(YDAudioVideo *)audio;
- (void)playEnableBgModelWithAudio:(YDAudioVideo *)audio;


#pragma mark - 接收方法的设置
//- (void)remoteControlReceivedWithEvent:(UIEvent *)event;

@end
