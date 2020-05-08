//
//  GWUserLoginCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/9.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWUserLoginCell.h"
#import <SDAutoLayout.h>
#import "UIImage+ImageWithColor.h"

@interface GWUserLoginCell ()

/** 头像 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *gw_userName;
/** 个性签名 */
@property (weak, nonatomic) IBOutlet UILabel *gw_signaLabel;
/** 认证信息 */
@property (weak, nonatomic) IBOutlet UIButton *gw_certification;
/** 认证信息宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gw_certificationWidth;//55
/** 认证信息左侧 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gw_certificationLeft;//15

@end

@implementation GWUserLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"cell_bg"];
    [self addSubview:bgImage];
    [self sendSubviewToBack:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self setupAutoHeightWithBottomView:self.gw_signaLabel bottomMargin:15];
    
}

- (void)setModel:(GWUserModel *)model{
    
    _model = model;
    
    self.gw_imageView.ol_placeholder = [UIImage imageNamed:@"user_header"];
    self.gw_imageView.ol_data = model.headPortrait;
    self.gw_userName.text = model.nickName;
    self.gw_signaLabel.text = [NSString ol_isNullOrNilWithObject:model.signature]?@"这个人有点忙，还没写个性签名":model.signature;
    self.gw_certification.hidden = NO;
    self.gw_certificationWidth.constant = 55;
    self.gw_certificationLeft.constant = 15;
    //1.企业认证 2.作者认证 3.媒体认证
    switch (model.userLevel.integerValue) {
        case GWCertificationEnterprise://企业
        {
            [self.gw_certification setTitle:@"企业认证" forState:UIControlStateNormal];
            [self.gw_certification setBackgroundImage:[UIImage imageWithColor:m_Color_RGB(57,123,255)] forState:UIControlStateNormal];
        }
            break;
        case GWCertificationAuthor://作者
        {
            [self.gw_certification setTitle:@"作者认证" forState:UIControlStateNormal];
            [self.gw_certification setBackgroundImage:[UIImage imageWithColor:GW_ThemeColor] forState:UIControlStateNormal];
        }
            break;
        case GWCertificationMedia://媒体
        {
            [self.gw_certification setTitle:@"媒体认证" forState:UIControlStateNormal];
            [self.gw_certification setBackgroundImage:[UIImage imageWithColor:m_Color_RGB(123,208,20)] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            self.gw_certification.hidden = YES;
            self.gw_certificationWidth.constant = CGFLOAT_MIN;
            self.gw_certificationLeft.constant = CGFLOAT_MIN;
        }
            break;
    }
    
}

@end
