//
//  GWHPHotNewsCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/2.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPHotNewsCell.h"
//model
#import "GWNewsModel.h"

@implementation GWHPHotNewsProjectButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
    
}

@end

@interface GWHPHotNewsCell ()

/** 新闻标题 */
@property (weak, nonatomic) IBOutlet UILabel *gw_titleLabel;
/** 新闻图片 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;
/** 专题按钮 */
@property (weak, nonatomic) IBOutlet GWHPHotNewsProjectButton *gw_projectBtn;
/** 新闻事件 */
@property (weak, nonatomic) IBOutlet UILabel *gw_timeLabel;
/** 浏览量 */
@property (weak, nonatomic) IBOutlet UIButton *gw_viewsNum;

@end

@implementation GWHPHotNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (m_IS_IPHONE_5) {
        self.gw_titleLabel.font = m_FontPF_Medium_WithSize(14);
    }


}

- (void)setModel:(GWNewsModel *)model{
    
    _model = model;
    self.gw_titleLabel.attributedText = [model titleWithLineSpacing:NO isBig:NO];
    self.gw_imageView.ol_data = model.smallImage;
    [self.gw_projectBtn setTitle:model.authorName forState:UIControlStateNormal];
    self.gw_timeLabel.text = [[NSDate dateFromString:model.releaseDate] stringWithFormat:@"MM-dd HH:mm"];
    [self.gw_viewsNum setTitle:model.lookTimes.stringValue forState:UIControlStateNormal];
    
}

- (IBAction)gw_projectMethod:(GWHPHotNewsProjectButton *)sender {
    
    
}


@end
