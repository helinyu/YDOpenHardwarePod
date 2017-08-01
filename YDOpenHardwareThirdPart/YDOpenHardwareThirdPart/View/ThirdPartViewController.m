//
//  ThirdPartViewController.m
//  YDOpenHardwareThirdPart
//
//  Created by 张旻可 on 16/2/14.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "ThirdPartViewController.h"

#import <YDOpenHardwareSDK/YDOpenHardwareManager.h>
#import <YDOpenHardwareSDK/YDOpenHardwareDataProvider.h>
#import <YDOpenHardwareSDK/YDOpenHardwareIntelligentScale.h>
#import <YDOpenHardwareSDK/YDOpenHardwareHeartRate.h>

#import "Masonry.h"

static NSString *cellId = @"cellId";

@interface ThirdPartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation ThirdPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self msInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self msStyleInit];
}

- (void)msInit {
    [self msComInit];
    [self msStyleInit];
    [self msDataInit];
    [self msBind];
}

- (void)msComInit {
    if (self.tableView == nil) {
        UITableView *t = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style: UITableViewStyleGrouped];
        [t registerClass: [UITableViewCell class] forCellReuseIdentifier: cellId];
        [self.view addSubview: t];
        self.tableView = t;
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView mas_makeConstraints: ^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(padding);
        }];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];
    }
}

- (void)msStyleInit {
    if (self.tableView) {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)msDataInit {
    if (self.data == nil) {
        self.data = @[@"是否绑定设备",
                      @"绑定设备",
                     @"写入数据",
                     @"读取数据",
                     @"解绑设备",
                     @"获取当前用户"];
    }
}

- (void)msBind {
    if (self.tableView) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
}

- (void)back {
    if (self.navigationController) {
        if (self.navigationController.childViewControllers.count <= 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.data) {
        return self.data.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId forIndexPath: indexPath];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
    switch (indexPath.row) {
        case 0: {
            [[YDOpenHardwareManager sharedManager] isRegistered: @"test" plug: @"test" user: @133 block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity) {
                BOOL flag = operateState == YDOpenHardwareOperateStateHasRegistered;
                NSString *msg = @"";
                if (flag) {
                    msg = @"已经注册";
                } else {
                    msg = @"没有注册";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil message: msg delegate: nil cancelButtonTitle: @"确认" otherButtonTitles: nil];
                [alert show];
            }];
            break;
        }
        case 1: {
            [[YDOpenHardwareManager sharedManager] registerDevice: @"test" plug: @"test" user: @133 block:^(YDOpenHardwareOperateState operateState, NSString *deviceIdentity, NSNumber *userId) {
                
            }];
            break;
        }
        case 2: {
            YDOpenHardwareIntelligentScale *is = [[YDOpenHardwareIntelligentScale alloc] init];
            [is constructByOhiId: nil DeviceId: @"133-test-test" TimeSec: [NSDate date] WeightG: @60000 HeightCm: @170 BodyFatPer: @0 BodyMusclePer: @0 BodyMassIndex: @0 BasalMetabolismRate: @0 BodyWaterPercentage: @0 UserId: @133 Extra: @"" ServerId:nil Status:nil];
            [[YDOpenHardwareManager dataProvider] insertIntelligentScale: is completion: ^(BOOL success) {
                
            }];
            YDOpenHardwareHeartRate *hr = [[YDOpenHardwareHeartRate alloc] init];
            [hr constructByOhhId: nil DeviceId: @"133-test-test" HeartRate: @100 StartTime: [NSDate date] EndTime: [NSDate date] UserId: @133 Extra: @"" ServerId:nil Status:nil];
            [[YDOpenHardwareManager dataProvider] insertHeartRate: hr completion:^(BOOL success) {
                NSLog(@"%@", hr.ohhId);
            }];
            break;
        }
        case 3: {
            [[YDOpenHardwareManager dataProvider] selectNewIntelligentScaleByDeviceIdentity: @"133-test-test" userId: @133 completion: ^(BOOL success, YDOpenHardwareIntelligentScale *is) {
                
            }];
            [[YDOpenHardwareManager dataProvider] selectIntelligentScaleByDeviceIdentity: @"133-test-test" timeSec: nil userId: @133 betweenStart: nil end: nil pageNo: @1 pageSize: @10 completion: ^(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *data) {
                
            }];
            [[YDOpenHardwareManager dataProvider] selectIntelligentScaleByDeviceIdentity: @"133-test-test" timeSec: nil userId: @133 betweenStart: nil end: nil completion:^(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *data) {
                
            }];
            break;
        }
        case 4: {
            [[YDOpenHardwareManager sharedManager] unRegisterDevice: @"133-test-test" plug: @"test" user: @133 block:^(YDOpenHardwareOperateState operateState) {
                
            }];
            break;
        }
        case 5: {
            [[YDOpenHardwareManager sharedManager] getCurrentUser];
            break;
        }
            
        default:
            break;
    }
}




@end
