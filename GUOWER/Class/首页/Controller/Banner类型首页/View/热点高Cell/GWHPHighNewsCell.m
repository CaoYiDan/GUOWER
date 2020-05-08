//
//  GWHPHighNewsCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/2.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPHighNewsCell.h"
#import <SDAutoLayout.h>
//model
#import "GWNewsModel.h"

@interface GWHPHighNewsCell ()

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *gw_titleLabel;
/** 图片 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;
/** 专题按钮 */
@property (weak, nonatomic) IBOutlet UIButton *gw_projectBtn;
/** 发文时间 */
@property (weak, nonatomic) IBOutlet UILabel *gw_timeLabel;
/** 浏览量 */
@property (weak, nonatomic) IBOutlet UIButton *gw_viewsNum;

@end

@implementation GWHPHighNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (m_IS_IPHONE_5) {
        self.gw_titleLabel.font = m_FontPF_Medium_WithSize(14);
    }
    
    [self setupAutoHeightWithBottomView:self.gw_projectBtn bottomMargin:19];
    
}

- (void)setModel:(GWNewsModel *)model{
    _model = model;
    self.gw_titleLabel.attributedText = [model titleWithLineSpacing:NO isBig:NO];
    self.gw_imageView.ol_data = model.image;
    self.gw_timeLabel.text = [[NSDate dateFromString:model.releaseDate] stringWithFormat:@"MM-dd HH:mm"];
    [self.gw_projectBtn setTitle:model.authorName forState:UIControlStateNormal];
    [self.gw_viewsNum setTitle:model.lookTimes.stringValue forState:UIControlStateNormal];
}

@end
