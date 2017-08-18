//
//  YDBluetoothWebViewMgr+Tel.h
//  YDOpenHardwareSimple
//
//  Created by Aka on 2017/8/18.
//  Copyright © 2017年 YD. All rights reserved.
//

#import "YDBluetoothWebViewMgr.h"

@interface YDBluetoothWebViewMgr (Tel)
/*
 * method: this method mainly for init the call handle when the tel is comming ,it will be invoke when tel comming or it be downed
 * discussion : is init the base info of the tel call
 */
- (void)initTelCallHandle;

/*
 * method: this method is register the neccessory method for html web to invoke
 */
- (void)registerTelHandle;

@end
