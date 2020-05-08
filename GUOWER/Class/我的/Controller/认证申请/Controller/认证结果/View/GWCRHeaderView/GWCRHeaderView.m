//
//  GWCRHeaderView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCRHeaderView.h"
#import "UIButton+ImageTitleSpacing.h"

@interface GWCRHeaderView ()

/** imageView */
@property (nonatomic, strong) UIImageView *gw_imageView;

/** messageBtn */
@property (nonatomic, strong) UIButton *gw_messageBtn;

/** onceAgainBtn */
@property (nonatomic, strong) UIButton *gw_onceAgainBtn;

@end

@implementation GWCRHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.gw_imageView = [[UIImageView alloc]init];
        self.gw_imageView.image = [UIImage imageNamed:@"cr_background"];
        [self.gw_imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.gw_imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.gw_imageView];
        [self.gw_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        self.gw_messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.gw_messageBtn.userInteractionEnabled = NO;
        [self.gw_messageBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.gw_messageBtn.titleLabel setFont:m_FontPF_Regular_WithSize(18)];
        [self.gw_messageBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [self.contentView addSubview:self.gw_messageBtn];
        
        self.gw_onceAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.gw_onceAgainBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.gw_onceAgainBtn setTitle:@"重新申请" forState:UIControlStateNormal];
        [self.gw_onceAgainBtn.titleLabel setFont:m_FontPF_Regular_WithSize(15)];
        self.gw_onceAgainBtn.masksToBounol_ol = YES;
        self.gw_onceAgainBtn.cornerRadius_ol = 18;
        self.gw_onceAgainBtn.borderColor_ol = UIColor.whiteColor;
        self.gw_onceAgainBtn.borderWidth_ol = .5;
        [self.contentView addSubview:self.gw_onceAgainBtn];
        [self.gw_onceAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(36);
        }];
        
        @weakify(self);
        [self.base_disposableArray addObject:[[self.gw_onceAgainBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            if (self_weak_.onceAgainClickBlock) {
                self_weak_.onceAgainClickBlock();
            }
            
        }]];
        
    }
    return self;
    
}

- (void)setState:(GWCertificationResultState)state{
    
    _state = state;
    
    switch (state) {
        case GWCertificationResultOngoing://审核中
        {
            self.gw_onceAgainBtn.hidden = YES;
            [self.gw_messageBtn setImage:[UIImage imageNamed:@"cr_wait"] forState:UIControlStateNormal];
            [self.gw_messageBtn setTitle:@"认证中，请耐心等待审核" forState:UIControlStateNormal];
            [self.gw_messageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
        }
            break;
        case GWCertificationResultSuccess://审核通过
        {
            self.gw_onceAgainBtn.hidden = YES;
            [self.gw_messageBtn setImage:[UIImage imageNamed:@"cr_pass"] forState:UIControlStateNormal];
            [self.gw_messageBtn setTitle:@"审核通过，认证成功" forState:UIControlStateNormal];
            [self.gw_messageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
            }];
        }
            break;
        case GWCertificationResultFailure://审核失败
        {
            self.gw_onceAgainBtn.hidden = NO;
            [self.gw_messageBtn setImage:[UIImage imageNamed:@"cr_fail"] forState:UIControlStateNormal];
            [self.gw_messageBtn setTitle:@"审核未通过，请重新申请" forState:UIControlStateNormal];
            [self.gw_messageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(28);
            }];
            [self.gw_onceAgainBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.bottom.mas_equalTo(-20);
            }];
        }
            break;
            
        default:
            break;
    }
    
}

@end
