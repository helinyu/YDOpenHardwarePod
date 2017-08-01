# YDOpenHardwarePod
YDOpenHardware library for hard ware to cache or store datas from bluetooth and so on

# YDOpenHardware
用于悦动圈跑步开放平台的简单demo
问题咨询： qq:295235985  邮箱：zhangminke@51yund.com

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






