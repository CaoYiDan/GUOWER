//
//  GWHPAuthorNavigationBar.m
//  GUOWER
//
//  Created by ourslook on 2018/7/3.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPAuthorNavigationBar.h"
#import "UIImage+ImageWithColor.h"

@interface GWHPAuthorNavigationBar ()

/** ContentView */
@property (nonatomic, weak) UIView *gw_contentView;

/** 头像 */
@property (nonatomic, weak) ZYLoadingImageView *gw_headerImage;

/** 昵称 */
@property (nonatomic, weak) UILabel *gw_label;

/** 分割线 */
@property (nonatomic, strong) UIView *gw_lineView;

@end

@implementation GWHPAuthorNavigationBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.translucent = YES;
        
        UIView *superView = [[UIView alloc]init];
        superView.backgroundColor = UIColor.clearColor;
        superView.clipsToBounds = YES;
        [self addSubview:superView];
        [superView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(54);
            make.right.mas_equalTo(-54);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UIView *contentView = [[UIView alloc]init];
        self.gw_contentView = contentView;
        [superView addSubview:contentView];
        
        ZYLoadingImageView *headerImage = [[ZYLoadingImageView alloc]init];
        headerImage.masksToBounol_ol = YES;
        headerImage.cornerRadius_ol = 16;
        self.gw_headerImage = headerImage;
        [contentView addSubview:headerImage];
        
        UILabel *label = [[UILabel alloc]init];
        label.font = m_FontPF_Medium_WithSize(18);
        self.gw_label = label;
        [contentView addSubview:label];
        
        [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.mas_equalTo(0);
            make.height.width.mas_equalTo(32);
            
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(headerImage.mas_right).offset(10);
            make.top.right.bottom.mas_equalTo(0);
            
        }];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(0);
            make.right.mas_lessThanOrEqualTo(0);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(54);
        }];
        
    }
    return self;
    
}

- (void)setOl_data:(id)ol_data{
    
    _ol_data = ol_data;
    
    self.gw_headerImage.ol_data = ol_data;
    
}

- (void)setGw_name:(NSString *)gw_name{
    
    _gw_name = gw_name;
    
    self.gw_label.text = gw_name;
    
}

-(void)setGw_alpha:(CGFloat)gw_alpha{
    
    if (_gw_alpha==gw_alpha) return;
    
    _gw_alpha = gw_alpha;

    [self setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(255, 255, 255, gw_alpha)] forBarMetrics:UIBarMetricsDefault];

    self.gw_lineView.alpha = gw_alpha;
    
    [self.gw_contentView mas_updateConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(54 * (1-gw_alpha));

    }];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.gw_lineView.alpha = self.gw_alpha;
    
}

- (UIView *)gw_lineView{
    
    if (!_gw_lineView) {
        
        _gw_lineView = [self findHairlineImageViewUnder:self];
        
    }
    
    return _gw_lineView;
    
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
