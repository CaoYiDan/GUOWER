//
//  GWMyArticleCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/13.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWMyArticleCell.h"
//model
#import "GWNewsModel.h"

@interface GWMyArticleCell ()

/** 新闻标题 */
@property (weak, nonatomic) IBOutlet UILabel *gw_titleLabel;
/** 新闻图片 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;
/** 新闻事件 */
@property (weak, nonatomic) IBOutlet UILabel *gw_timeLabel;
/** 浏览量 */
@property (weak, nonatomic) IBOutlet UIButton *gw_viewsNum;

@end

@implementation GWMyArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (m_IS_IPHONE_5) {
        self.gw_titleLabel.font = m_FontPF_Medium_WithSize(14);
    }
    
}

- (void)setModel:(GWNewsModel *)model{
    
    _model = model;
    
    self.gw_imageView.ol_data = model.isGw_bigImage?model.image:model.smallImage;
    self.gw_titleLabel.attributedText = [model titleWithLineSpacing:NO isBig:NO];
    self.gw_timeLabel.text = [[NSDate dateFromString:model.releaseDate] stringWithFormat:@"MM-dd HH:mm"];
    [self.gw_viewsNum setTitle:model.lookTimes.stringValue forState:UIControlStateNormal];
    
}

@end
