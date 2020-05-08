//
//  GWUserLogoutCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/9.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWUserLogoutCell.h"

@implementation GWUserLogoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"cell_bg"];
    [self addSubview:bgImage];
    [self sendSubviewToBack:bgImage];
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
