//
//  YDWebNoNetworkView.m
//  SportsBar
//
//  Created by 张旻可 on 2017/4/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YDWebNoNetworkView.h"
#import <YDHardWareWeb/YDDefine.h>
#import "Masonry.h"

@interface YDWebNoNetworkView ()

@property (nonatomic, strong) UIControl *control;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation YDWebNoNetworkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self comInit];
    }
    return self;
}

- (void)comInit {
    self.backgroundColor = YD_WHITE(1);
    self.control = [[UIControl alloc] init];
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_alert"]];
    self.tipLabel = [[UILabel alloc] init];
    [self addSubview:self.control];
    [self.control addSubview:self.imgView];
    [self.control addSubview:self.tipLabel];
    
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.control);
        make.centerY.equalTo(self.control).offset(-40);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.control);
        make.top.equalTo(self.imgView.mas_bottom).offset(17);
    }];
    self.tipLabel.textColor = YD_GRAY(102);
    self.tipLabel.font = YDF_SYS(12);
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.text = @"网络不给力，请检查网络设置。\n点击屏幕刷新";
    
    [self.control addTarget:self action:@selector(toRefresh:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toRefresh:(UIControl *)sender {
    !self.actionRefresh?:self.actionRefresh();
}

@end
