//
//  YDBluetoothWebViewMgr+DB.m
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr+DB.h"
#import <YDOpenHardwareSDK/YDOpenHardwareManager.h>
#import <YDOpenHardwareSDK/YDOpenHardwareDataProvider.h>
#import <YDOpenHardwareSDK/YDOpenHardwareIntelligentScale.h>
#import <YDOpenHardwareSDK/YDOpenHardwareHeartRate.h>
#import <YDOpenHardwareSDK/YDOpenHardwareSDK.h>
#import "CBService+YYModel.h"
#import "SVProgressHUD.h"
#import "YYModel.h"
#import "YDBluetoothWebViewMgr+Time.h"
#import "WebViewJavascriptBridge.h"

@implementation YDBluetoothWebViewMgr (DB)


#pragma mark -- 数据存储操作method name  & data (key/value )

- (void)registerDBHandles {
    //    智能体称
    __weak typeof (self) wSelf = self;
    [self.webViewBridge registerHandler:@"insertIntelligentScale" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertIntelligentScale:data];
        [wSelf loadAnotherHTMLWithDatas:data];
    }];
    
    [self.webViewBridge registerHandler:@"selectNewIntelligentScaleByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewIntelligentScaleByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectIntelligentScaleByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectIntelligentScaleByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectIntelligentScaleInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectIntelligentScaleInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    //    心率
    [self.webViewBridge registerHandler:@"insertHeartRate" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertHeartRate:data];
        [self loadAnotherHTMLWithDatas:data];
    }];
    
    [self.webViewBridge registerHandler:@"selectNewHeartRateByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewHeartRateByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectHeartRateByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectHeartRateByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectHeartRateInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectHeartRateInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    // 计步
    [self.webViewBridge registerHandler:@"insertPedometer" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf insertPedometer:data];
        [self loadAnotherHTMLWithDatas:data];
    }];
    
    [self.webViewBridge registerHandler:@"selectNewPedometerByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewPedometerByInfo:data completion:^(NSDictionary *dic) {
            if (dic) {
                [SVProgressHUD showInfoWithStatus:@"成功获取数据"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
            }
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectPedometerByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectPedometerByInfo:data completion:^(NSDictionary *dic) {
            if (dic) {
                [SVProgressHUD showInfoWithStatus:@"成功获取数据"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
            }
            responseCallback(dic);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectPedometerInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectPedometerInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    //    睡眠
    [self.webViewBridge registerHandler:@"insertSleep" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf insertSleep:data];
    }];
    
    [self.webViewBridge registerHandler:@"selectNewSleepByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectNewSleepByInfo:data completion:^(id idObj) {
            !responseCallback?:responseCallback(idObj);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectSleepByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self loadAnotherHTMLWithDatas:data];
        [wSelf selectSleepByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
    
    [self.webViewBridge registerHandler:@"selectSleepInPageByInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        [wSelf selectSleepInPageByInfo:data completion:^(NSDictionary *dic) {
            !responseCallback?:responseCallback(dic);
        }];
    }];
}

#pragma mark -- self handle
#pragma mark 体重秤

- (void)insertIntelligentScale:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    YDOpenHardwareIntelligentScale *intelligentScale = [YDOpenHardwareIntelligentScale new];
    intelligentScale = [YDOpenHardwareIntelligentScale yy_modelWithDictionary:infoDic];
    intelligentScale.deviceId = self.deviceIdentify;
    intelligentScale.timeSec?nil:(intelligentScale.timeSec =[NSDate date]);
    intelligentScale.weightG?nil:(intelligentScale.weightG = @0);
    intelligentScale.heightCm?nil:(intelligentScale.heightCm = @0);
    intelligentScale.bodyFatPer?nil:(intelligentScale.bodyFatPer = @0);
    intelligentScale.bodyMusclePer?nil:(intelligentScale.bodyMusclePer = @0);
    intelligentScale.bodyMassIndex?nil:(intelligentScale.bodyMassIndex = @0);
    intelligentScale.basalMetabolismRate?nil:(intelligentScale.basalMetabolismRate = @0);
    intelligentScale.bodyWaterPercentage?nil:(intelligentScale.bodyWaterPercentage = @0);
    intelligentScale.userId = self.userId;
    intelligentScale.extra?nil:(intelligentScale.extra = @"");
    intelligentScale.serverId?nil:(intelligentScale.serverId = @0);
    intelligentScale.status?nil:(intelligentScale.status = @0);
    [[YDOpenHardwareManager dataProvider] insertIntelligentScale:intelligentScale completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入体重秤数据成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"插入体重秤数据失败"];
        }
    }];
}

- (void)selectNewIntelligentScaleByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentity = self.deviceIdentify;
    NSNumber *userId = self.userId;
    [[YDOpenHardwareManager dataProvider] selectNewSleepByDeviceIdentity:deviceIdentity userId:userId completion:^(BOOL success, YDOpenHardwareSleep *ohModel) {
        if (success) {
            !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
        }
    }];
}

- (void)selectIntelligentScaleByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = self.deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = self.userId;
    [[YDOpenHardwareManager dataProvider] selectIntelligentScaleByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate completion:^(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *scales) {
        !responseJsonObject?:responseJsonObject([scales yy_modelToJSONObject]);
    }];
}

- (void)selectIntelligentScaleInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = self.deviceIdentify;
    NSDate *timeSec = infoDic[@"timeSec"];
    NSDate *betweenStart = infoDic[@"betweenStart"];
    NSDate *endDate = infoDic[@"endDate"];
    NSNumber *userId = self.userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [[YDOpenHardwareManager dataProvider] selectIntelligentScaleByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:betweenStart end:endDate pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *scales) {
        !responseJsonObject?:responseJsonObject([scales yy_modelToJSONObject]);
    }];
}

#pragma mark 心率

- (void)insertHeartRate:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    YDOpenHardwareHeartRate *hr = [YDOpenHardwareHeartRate yy_modelWithDictionary:infoDic];
    hr.deviceId = self.deviceIdentify;
    hr.heartRate?nil:(hr.heartRate = @0);
    hr.startTime?nil:(hr.startTime =[NSDate date]);
    hr.endTime?nil:(hr.endTime = [NSDate date]);
    hr.userId = self.userId;
    hr.extra?nil:(hr.extra = @"");
    hr.serverId?nil:(hr.serverId = @0);
    hr.status?nil:(hr.status = @0);
    [[YDOpenHardwareManager dataProvider] insertHeartRate:hr completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入心率成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"插入心率失败"];
        }
    }];
}

- (void)selectNewHeartRateByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    [[YDOpenHardwareManager dataProvider] selectNewHeartRateByDeviceIdentity:deviceIdentify userId:userId completion:^(BOOL success, YDOpenHardwareHeartRate *ohModel) {
        !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
    }];
}

- (void)selectHeartRateByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectHeartRateByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime completion:^(BOOL success, NSArray<YDOpenHardwareHeartRate *> *heartRates) {
            !responseJsonObject?:responseJsonObject([heartRates yy_modelToJSONObject]);
        }];
    }];
}

- (void)selectHeartRateInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectHeartRateByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareHeartRate *> *heartRates) {
            !responseJsonObject?:responseJsonObject([heartRates yy_modelToJSONObject]);
        }];
    }];
}

#pragma mark 计步

- (void)insertPedometer:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //    test datas must deliver from the html :note some params(datas must not be nil)
    YDOpenHardwarePedometer *pe = [YDOpenHardwarePedometer yy_modelWithDictionary:infoDic];
    pe.deviceId = self.deviceIdentify;
    pe.userId = [[YDOpenHardwareManager sharedManager] getCurrentUser].userID;
    !pe.startTime?(pe.startTime = [NSDate date]):nil;
    !pe.endTime?(pe.endTime = [NSDate date]):nil;
    !pe.extra?(pe.extra = @""):nil;
    !pe.distance?(pe.distance = @0):nil;
    !pe.calorie?(pe.calorie =@0):nil;
    !pe.extra?(pe.extra = @""):nil;
    !pe.serverId?(pe.serverId = @0):nil;
    !pe.status?(pe.status = @0):nil;
    !pe.numberOfStep?(pe.numberOfStep = @0):nil;
    
    [[YDOpenHardwareManager dataProvider] insertPedometer:pe completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入计步成功"];
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"插入计步失败"];
        }
    }];
}

- (void)selectNewPedometerByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    [[YDOpenHardwareManager dataProvider] selectNewPedometerByDeviceIdentity:deviceIdentify userId:userId completion:^(BOOL success, YDOpenHardwarePedometer *ohModel) {
        !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
    }];
}

- (void)selectPedometerByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectPedometerByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime completion:^(BOOL success, NSArray<YDOpenHardwarePedometer *> *pedometers) {
            if (success) {
                [SVProgressHUD showInfoWithStatus:@"成功"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"失败"];
            }
            !responseJsonObject?:responseJsonObject([pedometers yy_modelToJSONObject]);
        }];
    }];
}

- (void)selectPedometerInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectPedometerByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwarePedometer *> *pedometers) {
            !responseJsonObject?:responseJsonObject([pedometers yy_modelToJSONObject]);
        }];
    }];
    
}

#pragma mark 睡眠

- (void)insertSleep:(id)infoDic {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    YDOpenHardwareSleep *sleep = [YDOpenHardwareSleep yy_modelWithDictionary:infoDic];
    sleep.deviceId = self.deviceIdentify;
    sleep.sleepSec?nil:(sleep.sleepSec = @0);
    sleep.sleepSection?nil:(sleep.sleepSection = @0);
    sleep.startTime?nil:(sleep.startTime = [NSDate date]);
    sleep.endTime?nil:(sleep.endTime = [NSDate date]);
    sleep.userId = self.userId;
    sleep.extra?nil:(sleep.extra = @"");
    sleep.serverId?nil:(sleep.serverId = @0);
    sleep.status?nil:(sleep.status = @0);
    [[YDOpenHardwareManager dataProvider] insertSleep:sleep completion:^(BOOL success) {
        if (success) {
            [SVProgressHUD showInfoWithStatus:@"插入睡眠数据成功"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"插入睡眠数据失败"];
        }
    }];
}

- (void)selectNewSleepByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    [[YDOpenHardwareManager dataProvider] selectNewSleepByDeviceIdentity:deviceIdentify userId:userId completion:^(BOOL success, YDOpenHardwareSleep *ohModel) {
        if (success) {
            !responseJsonObject?:responseJsonObject([ohModel yy_modelToJSONObject]);
        }
    }];
}

- (void)selectSleepByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject {
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectSleepByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime completion:^(BOOL success, NSArray<YDOpenHardwareSleep *> *sleeps) {
            if (success) {
                !responseJsonObject?:responseJsonObject([sleeps yy_modelToJSONObject]);
            }
        }];
    }];
}

- (void)selectSleepInPageByInfo:(id)infoDic completion:(ResponseJsonObject)reponseJsonObject{
    if (!infoDic || ![infoDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *deviceIdentify = self.deviceIdentify;
    NSNumber *userId = self.userId;
    NSNumber *pageNo = infoDic[@"pageNo"];
    NSNumber *pageSize = infoDic[@"pageSize"];
    [self convertToSelectedTimeWithInfo:infoDic then:^(NSDate *timeSec, NSDate *startTime, NSDate *endTime) {
        [[YDOpenHardwareManager dataProvider] selectSleepByDeviceIdentity:deviceIdentify timeSec:timeSec userId:userId betweenStart:startTime end:endTime pageNo:pageNo pageSize:pageSize completion:^(BOOL success, NSArray<YDOpenHardwareSleep *> *sleeps) {
            if (success) {
                !reponseJsonObject?:reponseJsonObject([sleeps yy_modelToJSONObject]);
            }
        }];
    }];
}

#pragma mark -- notify

- (void)onOpenHardwareUserChangeNotify:(NSNotification *)notification{
    
    //    解绑悦动圈（切换账号的时候）
    [[YDOpenHardwareManager sharedManager] unRegisterDevice:self.deviceIdentify plug:self.plugName user:self.userId block:^(YDOpenHardwareOperateState operateState) {
        if (operateState == YDOpenHardwareOperateStateSuccess) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastInsertStepsS3"];
        }else{
            NSLog(@"解除绑定失败");
        }
    }];
}


@end
