//
//  ZYLoadingImageView.h
//  GUOWER
//
//  Created by ourslook on 2018/7/4.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYLoadingImageView : UIImageView


/**
 *    @brief    设置图片数据
 *    NSString NSURL UIImage
 */
@property (nonatomic, strong) id ol_data;

/** 占位图 */
@property (nonatomic, strong) UIImage *ol_placeholder;
/**
 *    @brief    是否显示加载失败按钮
 */
@property (nonatomic, assign) BOOL ol_showErrorButton;

- (void)setImage:(UIImage *)image NS_UNAVAILABLE;

@end
