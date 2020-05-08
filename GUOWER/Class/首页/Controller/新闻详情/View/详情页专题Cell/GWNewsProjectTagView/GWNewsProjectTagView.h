//
//  GWNewsProjectTagView.h
//  GUOWER
//
//  Created by ourslook on 2018/7/5.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWNewsProjectTagView : UIView

/** tagClickBlock */
@property (nonatomic, copy) void(^tagClickBlock)(NSInteger index);

/**
 *    @brief    设置便签数组
 */
-(void)setTagWithTagArray:(NSArray*)arr;

@end
