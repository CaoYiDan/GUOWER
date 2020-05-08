//
//  GWNewsDetailAdvertCell.h
//  GUOWER
//
//  Created by ourslook on 2018/7/5.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWAdvertModel;

@interface GWNewsDetailAdvertCell : UITableViewCell

/** 广告数组 */
@property (nonatomic, strong) NSArray <GWAdvertModel*>*gw_array;

/** 广告点击 */
@property (nonatomic, copy) void (^advertClickBlock)(NSInteger index);

@end
