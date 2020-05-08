//
//  GWCertificationSectionHeaderView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCertificationSectionHeaderView.h"

@interface GWCertificationSectionHeaderView ()

/** line */
@property (nonatomic, weak) UIView *gw_line;

/** title */
@property (nonatomic, weak) UILabel *gw_titleLabel;

@end

@implementation GWCertificationSectionHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = GW_OrangeColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(22);
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(13);
        }];
        self.gw_line = line;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = m_FontPF_Medium_WithSize(16);
        titleLabel.textColor = m_Color_gray(47);
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(line);
            make.right.mas_lessThanOrEqualTo(-15);
        }];
        self.gw_titleLabel = titleLabel;
        
    }
    return self;
    
}

- (void)setGw_title:(NSString *)gw_title{
    
    _gw_title = gw_title;
    
    self.gw_titleLabel.text = gw_title;
    
}

@end
