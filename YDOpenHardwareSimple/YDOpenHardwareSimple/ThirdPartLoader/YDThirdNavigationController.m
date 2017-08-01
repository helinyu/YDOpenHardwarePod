//
//  YDThirdNavigationController.m
//  SportsBar
//
//  Created by 张旻可 on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YDThirdNavigationController.h"

@implementation YDThirdNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed: 28/255.0 green: 192/255.0 blue: 25/255.0 alpha: 1]];
//    [self.navigationBar setBackgroundImage:[UIImage imageFromColor:YD_GREEN1 withSize:CGSizeMake(1, 1) radius:0] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark orientation
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [self.topViewController shouldAutorotateToInterfaceOrientation: toInterfaceOrientation];
}

@end
