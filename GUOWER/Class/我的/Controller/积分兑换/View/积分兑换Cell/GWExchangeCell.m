//
//  GWExchangeCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWExchangeCell.h"
#import "UIImage+ImageWithColor.h"
//model
#import "GWExchangeGoodsModel.h"

@interface GWExchangeCell ()

/** 图片 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_image;
/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *gw_name;
/** 所需积分 */
@property (weak, nonatomic) IBOutlet UILabel *gw_price;
/** 库存 */
@property (weak, nonatomic) IBOutlet UILabel *gw_num;
/** 立即兑换 */
@property (weak, nonatomic) IBOutlet UIButton *gw_exchangeBtn;

@end

@implementation GWExchangeCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.gw_exchangeBtn setTitleColor:m_Color_gray(47) forState:UIControlStateNormal];
    [self.gw_exchangeBtn setTitleColor:m_Color_gray(153) forState:UIControlStateDisabled];
    [self.gw_exchangeBtn setBackgroundImage:[UIImage imageWithColor:m_Color_gray(240)] forState:UIControlStateDisabled];
    [self.gw_exchangeBtn setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forState:UIControlStateNormal];
    
    
    
}

-(void)setModel:(GWExchangeGoodsModel *)model{
    
    _model = model;
    
    self.gw_image.ol_data = model.image;
    self.gw_name.text = model.currencyName;
    self.gw_price.text = model.score.stringValue;
    self.gw_num.text = m_NSStringFormat(@"库存:%@",model.count.stringValue) ;
    [self setBtnEnabled:![model.count isEqualToNumber:@0]];
    
}

- (IBAction)gw_exchangeBtnMethod:(id)sender {
    
    if (self.immediatelyChangeBlock) {
        self.immediatelyChangeBlock();
    }
    
}

- (void)setBtnEnabled:(BOOL)enabled{
    
    self.gw_exchangeBtn.enabled = enabled;
    
    self.gw_exchangeBtn.borderColor_ol = enabled?m_Color_gray(47):UIColor.clearColor;
    self.gw_exchangeBtn.borderWidth_ol = .5;
    
}

@end
