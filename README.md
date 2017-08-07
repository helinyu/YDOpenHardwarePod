# YDOpenHardwarePod
YDOpenHardware library for hard ware to cache or store datas from bluetooth and so on

# YDOpenHardware
用于悦动圈跑步开放平台的简单demo
问题咨询： qq:295235985  邮箱：zhangminke@51yund.com

第三方最终提供给我们一个framework，模拟器和真机通用的
YDOpenHardwarePod 
第三方最终提供给我们一个framework，模拟器和真机通用的
YDOpenHardwarePod 


#S3.html (this file for interative with oc) 
define the mathod to call the oc in html file

1、this module it not be modified
```
function setupWebViewJavascriptBridge(callback) {
if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
window.WVJBCallbacks = [callback];
var WVJBIframe = document.createElement('iframe');
WVJBIframe.style.display = 'none';
WVJBIframe.src = 'https://__bridge_loaded__';
document.documentElement.appendChild(WVJBIframe);
setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}
```

2、 invoke the last method to do business neccesary
like that:

```
setupWebViewJavascriptBridge(function(bridge) {
…………………………
to do the business necessary
}
````

3、sj invoke the oc method 
```
var callbackButton = document.getElementById('scanBtn')
callbackButton.innerHTML = 'scanBtn'
callbackButton.onclick = function(e) {
e.preventDefault();
log('JS calling handler "scan peripheral"')
// window.location.href='./peripheralList.html';
bridge.callHandler('onScanS3Click', 'S3', function(response) {
log('JS got response', response)
});
};

```
4、oc invoke the js method , so that we must register the method
```
bridge.registerHandler('deliverCharacteristic', function(data, responseCallback) {
log('data'+data+':'+data.uuid+data.value.value0 +':'+data.value.value1+':'+data.value.value2+':'+data.value.value3+'.');

var stepLabel = document.getElementById('stepLabel');
// stepLabel.innerHTML = 
var calorieLabel = document.getElementById('calorieLabel');
// calorieLabel.innerHTMLp =
var distanceLabel = document.getElementById('distanceLabel');
// distanceLabel.innerHTML = 

responseCallback(responseData);
});
```

5、data deliver protocol:
we must deliver the data by the json format , you can deliver json object or data string and so on which can deliver to the oc 
so we recomend the format si key:value  which is simpler ,it will more eaier to use.
like the data of oc that :
```
@{
@"uuid":c.UUID.UUIDString,
@"value":@{
@"value0":value0,
@"value1":value1,
@"value2":value2,
@"value3":value3
}
};
`````

more detail you can see the [S3.html](https://github.com/helinyu/YDOpenHardwarePod/blob/master/ydOpenHardware/Html/S3.html)

#storage & cache datas
invoke this methods in js as follow:
```
体称
insertIntelligentScale
selectNewIntelligentScaleByInfo
selectIntelligentScaleByInfo
selectIntelligentScaleInPageByInfo

心率
insertHeartRate
selectNewHeartRateByInfo
selectHeartRateByInfo
selectHeartRateInPageByInfo

步数
insertPedometer
selectNewPedometerByInfo
selectPedometerByInfo
selectPedometerInPageByInfo

睡眠
insertSleep
selectNewSleepByInfo
selectSleepByInfo
selectSleepInPageByInfo

参数的传入：parmas
格式：dictionary || (key/value) || jsonObject
``````

#下面是对应的数据模型关键系

```
@interface YDOpenHardwareSleep : NSObject

@property (nonatomic, strong) NSNumber *ohsId;//对应数据库字段：ohs_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSNumber *sleepSec;//对应数据库字段：sleep_sec
@property (nonatomic, strong) NSNumber *sleepSection;//对应数据库字段：sleep_section
@property (nonatomic, strong) NSDate *startTime;//对应数据库字段：start_time
@property (nonatomic, strong) NSDate *endTime;//对应数据库字段：end_time
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status
@end

@interface YDOpenHardwareUser : NSObject
@property (nonatomic, copy) NSString *province; //所在省
@property (nonatomic, copy) NSString *city; //城市
@property (nonatomic, strong) NSNumber *userID; //用户id
@property (nonatomic, strong) NSNumber *rank; //用户等级
@property (nonatomic, strong) NSNumber *sex; //0为男，1为女
@property (nonatomic, copy) NSString *nick; //用户昵称
@property (nonatomic, copy) NSString *headImageUrl; //头像url
@property (nonatomic, copy) NSString *loveSports; //用户喜欢的运动 逗号隔开
@property (nonatomic, copy) NSString *phone; //用户手机
@property (nonatomic, copy) NSString *signature; //用户签名
@property (nonatomic, strong) NSDate *birth; //生日
@property (nonatomic, strong) NSNumber *height; //身高cm
@property (nonatomic, strong) NSNumber *weight; //重量g
@end


@interface YDOpenHardwarePedometer : NSObject
@property (nonatomic, strong) NSNumber *ohpId;//对应数据库字段：ohp_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSNumber *numberOfStep;//对应数据库字段：number_of_step
@property (nonatomic, strong) NSNumber *distance;//对应数据库字段：distance
@property (nonatomic, strong) NSNumber *calorie;//对应数据库字段：calorie
@property (nonatomic, strong) NSDate *startTime;//对应数据库字段：start_time
@property (nonatomic, strong) NSDate *endTime;//对应数据库字段：end_time
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status
@end


@interface YDOpenHardwareIntelligentScale : NSObject
@property (nonatomic, strong) NSNumber *ohiId;//对应数据库字段：ohi_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSDate *timeSec;//对应数据库字段：time_sec
@property (nonatomic, strong) NSNumber *weightG;//对应数据库字段：weight_g
@property (nonatomic, strong) NSNumber *heightCm;//对应数据库字段：height_cm
@property (nonatomic, strong) NSNumber *bodyFatPer;//对应数据库字段：body_fat_per
@property (nonatomic, strong) NSNumber *bodyMusclePer;//对应数据库字段：body_muscle_per
@property (nonatomic, strong) NSNumber *bodyMassIndex;//对应数据库字段：body_mass_index
@property (nonatomic, strong) NSNumber *basalMetabolismRate;//对应数据库字段：basal_metabolism_rate
@property (nonatomic, strong) NSNumber *bodyWaterPercentage;//对应数据库字段：body_water_percentage
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status
@end


@interface YDOpenHardwareHeartRate : NSObject
@property (nonatomic, strong) NSNumber *ohhId;//对应数据库字段：ohh_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSNumber *heartRate;//对应数据库字段：heart_rate
@property (nonatomic, strong) NSDate *startTime;//对应数据库字段：start_time
@property (nonatomic, strong) NSDate *endTime;//对应数据库字段：end_time
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status
@end

注意：device_id & user_id 默认不用传入，在native 这边默认是当前的用户设备
其他字段按需传入

```
`
#蓝牙操作过程中的几个必要的方法

```
var callbackButton = document.getElementById('scanBtn')
callbackButton.innerHTML = 'scanBtn'
callbackButton.onclick = function(e) {
e.preventDefault();
log('JS calling handler "scan peripheral"')
// window.location.href='./peripheralList.html';
var scanParams = {'prefixField':'S3','YDBlueToothFilterType':3};
bridge.callHandler('onScanClick', scanParams, function(response) {
log('JS got response', response)
});
};
```
method: onScanClick
params: scanParams (key/value)

第一个参数是对应的过滤的类型：
YDBlueToothFilterTypeNone = 0,
YDBlueToothFilterTypeMatch,  // match to filter and find the specify device
YDBlueToothFilterTypeContain,    // contain the keyword to filter and find the specify device
YDBlueToothFilterTypePrefix,     // key word by the prefix
YDBlueToothFilterTypeSuffix,     // key word by the suffix
YDBlueToothFilterTypePrefixAndSuffix, // key word by the prefix & suffix
YDBlueToothFilterTypePrefixAndContain, // key word by the prefix & contain
YDBlueToothFilterTypeSuffixAndContrain, // key word by the suffix & contain
YDBlueToothFilterTypePrefixAndContrainAndSuffix, //key word by the prefix & contrain * suffix

第二个参数是对应的是过滤方式的字段：
@property (nonatomic, copy) NSString *matchField; // 匹配
@property (nonatomic, copy) NSString *prefixField; // 前缀
@property (nonatomic, copy) NSString *suffixField; // 后缀
@property (nonatomic, copy) NSString *containField; //包含

……
