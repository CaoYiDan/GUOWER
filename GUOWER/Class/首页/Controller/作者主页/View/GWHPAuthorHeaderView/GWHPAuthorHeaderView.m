//
//  GWHPAuthorHeaderView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/3.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPAuthorHeaderView.h"

@interface GWHPAuthorHeaderView ()

/** 头像 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *gw_nameLabel;
/** 文章数 */
@property (weak, nonatomic) IBOutlet UILabel *gw_articleNum;
/** 浏览量 */
@property (weak, nonatomic) IBOutlet UILabel *gw_viewsNum;
/** 个性签名 */
@property (weak, nonatomic) IBOutlet UILabel *gw_signaLabel;

@end

@implementation GWHPAuthorHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)setModel:(GWUserModel *)model{
    
    _model = model;
    
    self.gw_imageView.ol_data = model.headPortrait;
    self.gw_nameLabel.text = model.nickName;
    self.gw_articleNum.text = model.newsNumber.stringValue;
    self.gw_viewsNum.text = model.totalBrowsing.stringValue;
    self.gw_signaLabel.text = model.signature;
    
}

@end
