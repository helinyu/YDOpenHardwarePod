//
//  YDBluetoothWebViewMgr+DB.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr.h"

@interface YDBluetoothWebViewMgr (DB)

//--reigsterHandle
- (void)registerDBHandles;

//--operate db ,this only for native method to invoke,but it is no recommeded ,you can invoke by the openhadwareSDk.framework mathod directly
// 体重秤
- (void)insertIntelligentScale:(id)infoDic;
- (void)selectNewIntelligentScaleByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectIntelligentScaleByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectIntelligentScaleInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;

//心率
- (void)insertHeartRate:(id)infoDic;
- (void)selectNewHeartRateByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectHeartRateByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectHeartRateInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;

//计步
- (void)insertPedometer:(id)infoDic;
- (void)selectNewPedometerByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectPedometerByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectPedometerInPageByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;

//睡眠
- (void)insertSleep:(id)infoDic;
- (void)selectNewSleepByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectSleepByInfo:(id)infoDic completion:(ResponseJsonObject)responseJsonObject;
- (void)selectSleepInPageByInfo:(id)infoDic completion:(ResponseJsonObject)reponseJsonObject;

//--notify
- (void)onOpenHardwareUserChangeNotify:(NSNotification *)notification;

@end
