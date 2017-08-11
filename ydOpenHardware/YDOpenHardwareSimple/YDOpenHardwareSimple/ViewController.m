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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toThirdPartVC:(id)sender {
    
    YDBridgeWebViewController *vc = [YDBridgeWebViewController new];
    vc.urlString = @"S3.html";
    vc.type = YDWebViewTypeS3;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
