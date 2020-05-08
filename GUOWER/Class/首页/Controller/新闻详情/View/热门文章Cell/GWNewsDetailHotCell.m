//
//  GWNewsDetailHotCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/5.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNewsDetailHotCell.h"
//model
#import "GWNewsModel.h"

@interface GWNewsDetailHotCell ()

/** 新闻标题 */
@property (weak, nonatomic) IBOutlet UILabel *gw_titleLabel;

/** 新闻图片 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;

@end

@implementation GWNewsDetailHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setModel:(GWNewsModel *)model{
    
    _model = model;
    
    self.gw_titleLabel.attributedText = [model titleWithLineSpacing:YES isBig:NO];
    
    self.gw_imageView.ol_data = model.isGw_bigImage?model.image:model.smallImage;
    
}

@end
