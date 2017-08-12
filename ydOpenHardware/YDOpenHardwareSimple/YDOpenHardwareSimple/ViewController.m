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

@interface ViewController ()

- (IBAction)toThirdPartVC:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoadHtmlNotify:) name:@"yd.ntf.load.outside.bundle.html" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toThirdPartVC:(id)sender {

//   load html string
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"S3.html" ofType:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    YDBridgeWebViewController *vc = [YDBridgeWebViewController new];
    vc.urlString = htmlString;
    vc.type = YDWebViewTypeS3;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)onLoadHtmlNotify:(NSNotification *)noti {
    NSString *urlString = noti.object;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlString ofType:nil];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"yd.readload.html" object:htmlString];
}

@end
