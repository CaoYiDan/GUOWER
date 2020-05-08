//
//  GWHPNavigationBar.m
//  GUOWER
//
//  Created by ourslook on 2018/6/29.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPNavigationBar.h"
#import "UIButton+ImageTitleSpacing.h"
#import "UIImage+ImageWithColor.h"
//搜索页
#import "GWHPSearchVC.h"

@implementation GWHPNavigationBar

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(96);
        
        }];
        
        //searchButton
        UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchButton setBackgroundImage:[UIImage imageWithColor:m_hexColor(0xf5f5f5)] forState:UIControlStateNormal];
        [searchButton setTitle:@"搜索关键词" forState:UIControlStateNormal];
        [searchButton setImage:[UIImage imageNamed:@"search0"] forState:UIControlStateNormal];
        [searchButton setTitleColor:m_hexColor(0xc2c2c2) forState:UIControlStateNormal];
        [searchButton.titleLabel setFont:m_FontPF_Regular_WithSize(13)];
        [searchButton setCornerRadius_ol:15];
        [searchButton setMasksToBounol_ol:YES];
        [searchButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [self addSubview:searchButton];

        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(imageView.mas_right).mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(30);
            
        }];
        
        [self.base_disposableArray addObject:[[searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            GWHPSearchVC *vc = [[GWHPSearchVC alloc]init];
            UIViewController *currentVC = UIViewController.currentViewController;
            if ([currentVC isKindOfClass:UINavigationController.class]) {
                [(UINavigationController*)currentVC pushViewController:vc animated:YES];
            }else if ([currentVC isKindOfClass:UIViewController.class]){
                [currentVC.navigationController pushViewController:vc animated:YES];
            }
            
        }]];
        
    }
    return self;
    
}

@end
