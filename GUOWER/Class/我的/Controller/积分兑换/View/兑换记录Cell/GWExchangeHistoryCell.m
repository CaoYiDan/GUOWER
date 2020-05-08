//
//  GWExchangeHistoryCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWExchangeHistoryCell.h"
//model
#import "GWExchangeModel.h"

@interface GWExchangeHistoryCell ()

/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *gw_name;
/** 兑换时间 */
@property (weak, nonatomic) IBOutlet UILabel *gw_time;
/** 所用积分 */
@property (weak, nonatomic) IBOutlet UILabel *gw_price;

@end

@implementation GWExchangeHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setModel:(GWExchangeModel *)model{
    
    _model = model;
    
    self.gw_name.text = model.currencyName;
    self.gw_time.text = model.createDate.ol_yMdHms_to_yMdHm;
    self.gw_price.text = m_NSStringFormat(@"-%@",model.score.stringValue);
    
}

@end
