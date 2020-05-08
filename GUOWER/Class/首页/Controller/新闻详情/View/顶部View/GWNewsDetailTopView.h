//
//  GWNewsDetailTopView.h
//  GUOWER
//
//  Created by ourslook on 2018/7/4.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWNewsModel;

@interface GWNewsDetailTopView : UIView

/** model */
@property (nonatomic, strong) GWNewsModel *model;

/** 作者点击回调 */
@property (nonatomic, copy) void(^nameClickBlock)(void);

//计算Title高度
+ (CGFloat)titleHeightWithModel:(GWNewsModel*)model;

@end
