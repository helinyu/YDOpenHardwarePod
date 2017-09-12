//
//  ViewController.m
//  YDOpenHardwareSimple
//
//  Created by 张旻可 on 16/2/2.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "ViewController.h"

#import <YDOpenHardwareCore/YDOpenHardwareMgr.h>
#import "YDBridgeWebViewController.h"
#import "YDConstants.h"

@interface ViewController ()

- (IBAction)toThirdPartVC:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadHtmlNotify:) name:YDNtfLoadOutsideBundleHtml object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toThirdPartVC:(id)sender {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"YDPeripheralList.html" ofType:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    YDBridgeWebViewController *vc = [YDBridgeWebViewController new];
//    vc.urlString = @"http://192.168.11.127:8000/bluetoothhtml/YDPeripheralList.html";
    vc.urlString = htmlString;
    vc.type = YDWebViewTypeBluetooth;
    vc.bluetoothBusinessType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onLoadHtmlNotify:(NSNotification *)noti {
    NSString *urlString = noti.object;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlString ofType:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:YDNtfLoadHtml object:htmlString];
}

@end
