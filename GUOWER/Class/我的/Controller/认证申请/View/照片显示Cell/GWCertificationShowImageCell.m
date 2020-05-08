//
//  GWCertificationShowImageCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCertificationShowImageCell.h"

@implementation GWCertificationShowImageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    @weakify(self);
    [self.base_disposableArray addObject:[[self.gw_delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
     
        if (self_weak_.delBtnClickBlock) {
            self_weak_.delBtnClickBlock();
        }
        
    }]];
    
    [self.base_disposableArray addObject:[[self.gw_imageView rac_signalForSelector:@selector(setOl_data:)] subscribeNext:^(RACTuple * _Nullable x) {
        
        NSArray *array = x.allObjects;
        if (array.firstObject) {
            self_weak_.gw_delBtn.hidden = [array.firstObject isKindOfClass:NSString.class];
        }
        
    }]];
    
}

@end
