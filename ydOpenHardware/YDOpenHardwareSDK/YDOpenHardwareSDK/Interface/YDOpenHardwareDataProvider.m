//
//  YDOpenHardwareDataProvider.m
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/19.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDOpenHardwareDataProvider.h"

#import "YDOpenHardwareManager.h"

#import "YDOpenHardwareIntelligentScale.h"
#import "YDOpenHardwareHeartRate.h"
#import "YDOpenHardwarePedometer.h"
#import "YDOpenHardwareSleep.h"

static YDOpenHardwareDataProvider *sOpenHardwareDataProvider;

static NSString *const innerOpenHardwareDPClassName = @"YDOpenHardwareDP";
static NSString *const innerOpenHardwareDPInstanceSelector = @"sharedDP";

@interface YDOpenHardwareDataProvider ()

@property (weak, nonatomic) id delegate;

@end


@implementation YDOpenHardwareDataProvider

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (YDOpenHardwareDataProvider *)dataProvider {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sOpenHardwareDataProvider == nil) {
            sOpenHardwareDataProvider = [[YDOpenHardwareDataProvider alloc] initPrivate];
            [sOpenHardwareDataProvider msInit];
        }
    });
    return sOpenHardwareDataProvider;
}

- (void)msInit {
    Class innerClass = NSClassFromString(innerOpenHardwareDPClassName);
    SEL innerSel = NSSelectorFromString(innerOpenHardwareDPInstanceSelector);
    
    if (innerClass && innerSel && [innerClass respondsToSelector: innerSel]) {
        id delegate_;
        SuppressPerformSelectorLeakWarning(
                                           delegate_ = [innerClass performSelector: innerSel];
                                           );
        self.delegate = delegate_;
        
    }
}

- (void)insertIntelligentScale: (YDOpenHardwareIntelligentScale *)ohModel completion: (void(^)(BOOL success))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(insertIntelligentScale:completion:)]) {
        [self.delegate insertIntelligentScale: ohModel completion: ^(BOOL success) {
            block(success);
        }];
    } else {
        block(NO);
    }
}

- (void)selectNewIntelligentScaleByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareIntelligentScale *ohModel))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectNewIntelligentScaleByDeviceIdentity:userId:completion:)]) {
        [self.delegate selectNewIntelligentScaleByDeviceIdentity: device_identity userId: user_id completion: ^(BOOL success, id model) {
            YDOpenHardwareIntelligentScale *ohModel = [[YDOpenHardwareIntelligentScale alloc] init];
            [ohModel constructByModel: model];
            block(success, ohModel);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectIntelligentScaleByDeviceIdentity:timeSec:userId:betweenStart:end:completion:)]) {
        [self.delegate selectIntelligentScaleByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwareIntelligentScale *ohModel = [[YDOpenHardwareIntelligentScale alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectIntelligentScaleByDeviceIdentity:timeSec:userId:betweenStart:end:pageNo:pageSize:completion:)]) {
        [self.delegate selectIntelligentScaleByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwareIntelligentScale *ohModel = [[YDOpenHardwareIntelligentScale alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)insertHeartRate: (YDOpenHardwareHeartRate *)ohModel completion: (void(^)(BOOL success))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(insertHeartRate:completion:)]) {
        [self.delegate insertHeartRate: ohModel completion: ^(BOOL success) {
            block(success);
        }];
    } else {
        block(NO);
    }
}

- (void)selectNewHeartRateByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareHeartRate *ohModel))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectNewIntelligentScaleByDeviceIdentity:userId:completion:)]) {
        [self.delegate selectNewHeartRateByDeviceIdentity: device_identity userId: user_id completion: ^(BOOL success, id model) {
            YDOpenHardwareHeartRate *ohModel = [[YDOpenHardwareHeartRate alloc] init];
            [ohModel constructByModel: model];
            block(success, ohModel);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareHeartRate *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectHeartRateByDeviceIdentity:timeSec:userId:betweenStart:end:completion:)]) {
        [self.delegate selectHeartRateByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwareHeartRate *ohModel = [[YDOpenHardwareHeartRate alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareHeartRate *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectHeartRateByDeviceIdentity:timeSec:userId:betweenStart:end:pageNo:pageSize:completion:)]) {
        [self.delegate selectHeartRateByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwareHeartRate *ohModel = [[YDOpenHardwareHeartRate alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)insertPedometer: (YDOpenHardwarePedometer *)ohModel completion: (void(^)(BOOL success))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(insertPedometer:completion:)]) {
        [self.delegate insertPedometer: ohModel completion: ^(BOOL success) {
            block(success);
        }];
    } else {
        block(NO);
    }
}

- (void)selectNewPedometerByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwarePedometer *ohModel))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectNewPedometerByDeviceIdentity:userId:completion:)]) {
        [self.delegate selectNewPedometerByDeviceIdentity: device_identity userId: user_id completion: ^(BOOL success, id model) {
            YDOpenHardwarePedometer *ohModel = [[YDOpenHardwarePedometer alloc] init];
            [ohModel constructByModel: model];
            block(success, ohModel);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwarePedometer *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectPedometerByDeviceIdentity:timeSec:userId:betweenStart:end:completion:)]) {
        [self.delegate selectPedometerByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwarePedometer *ohModel = [[YDOpenHardwarePedometer alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwarePedometer *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectPedometerByDeviceIdentity:timeSec:userId:betweenStart:end:pageNo:pageSize:completion:)]) {
        [self.delegate selectPedometerByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwarePedometer *ohModel = [[YDOpenHardwarePedometer alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)insertSleep: (YDOpenHardwareSleep *)ohModel completion: (void(^)(BOOL success))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(insertSleep:completion:)]) {
        [self.delegate insertSleep: ohModel completion: ^(BOOL success) {
            block(success);
        }];
    } else {
        block(NO);
    }
}

- (void)selectNewSleepByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareSleep *ohModel))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectNewSleepByDeviceIdentity:userId:completion:)]) {
        [self.delegate selectNewSleepByDeviceIdentity: device_identity userId: user_id completion: ^(BOOL success, id model) {
            YDOpenHardwareSleep *ohModel = [[YDOpenHardwareSleep alloc] init];
            [ohModel constructByModel: model];
            block(success, ohModel);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareSleep *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectSleepByDeviceIdentity:timeSec:userId:betweenStart:end:completion:)]) {
        [self.delegate selectSleepByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwareSleep *ohModel = [[YDOpenHardwareSleep alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}

- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareSleep *> *))block {
    if (self.delegate && [self.delegate respondsToSelector: @selector(selectSleepByDeviceIdentity:timeSec:userId:betweenStart:end:pageNo:pageSize:completion:)]) {
        [self.delegate selectSleepByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size completion: ^(BOOL success, NSArray *arr) {
            NSMutableArray *arr_t = [NSMutableArray array];
            for (id model in arr) {
                YDOpenHardwareSleep *ohModel = [[YDOpenHardwareSleep alloc] init];
                [ohModel constructByModel: model];
                [arr_t addObject: ohModel];
            }
            block(success, arr_t);
        }];
    } else {
        block(NO, nil);
    }
}


@end
