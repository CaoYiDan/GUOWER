//
//  GWCertificationUIModel.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCertificationUIModel.h"

@implementation GWCertificationUIModel

- (NSMutableArray<UIImage *> *)cellImages{
    
    if (!_cellImages) {
        _cellImages = [NSMutableArray array];
    }
    return _cellImages;
    
}

- (NSMutableArray *)cellAssets{
    
    if (!_cellAssets) {
        _cellAssets = [NSMutableArray array];
    }
    return _cellAssets;
    
}

@end
