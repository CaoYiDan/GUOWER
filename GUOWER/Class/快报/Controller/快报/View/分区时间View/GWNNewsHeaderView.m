//
//  GWNNewsHeaderView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/3.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNNewsHeaderView.h"

@interface GWNNewsHeaderView ()

/** <#Description#> */
@property (nonatomic, weak) UILabel *gw_timeLabel;

@end

@implementation GWNNewsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]init];
        label.font = m_FontPF_Regular_WithSize(15);
        label.textColor = m_Color_gray(47);
        self.gw_timeLabel = label;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = m_Color_gray(229.00);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
    
}

- (void)setGw_timeTitle:(NSString *)gw_timeTitle{
    
    _gw_timeTitle = gw_timeTitle;
    
    self.gw_timeLabel.text = gw_timeTitle;
    
}

@end
