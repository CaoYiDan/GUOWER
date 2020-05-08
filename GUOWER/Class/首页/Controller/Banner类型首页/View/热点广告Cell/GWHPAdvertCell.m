//
//  GWHPAdvertCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/2.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWHPAdvertCell.h"
//model
#import "GWNewsModel.h"

@interface GWHPAdvertCell ()

/** 广告图 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;
/** 广告Icon */
@property (weak, nonatomic) IBOutlet UIImageView *gw_iconView;

@end

@implementation GWHPAdvertCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

-(void)setModel:(GWNewsModel *)model{
    
    _model = model;
    
    self.gw_imageView.ol_data = model.isGw_bigImage?model.image:model.smallImage;
    
}



@end
