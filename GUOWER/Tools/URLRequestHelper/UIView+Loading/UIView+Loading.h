//
//  UIView+Loading.h
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

/*
 以下属性优先级较高于直接调用这几个方法传值
 - (void)showHudWithHint:(NSString *)hint;
 - (void)showMaskWithHint:(NSString *)hint;
 - (void)showErrorMaskWithHint:(NSString*)hint clickBlock:(void(^)(void))clickBlock;
 方便在URLRequestHelper中设置单个请求的HUD属性
 */

/** 冗余字段 用户绑定一些特殊属性 */
@property (nonatomic, copy) NSString *other_field;

/** 冗余字段 用户绑定一些特殊属性 */
@property (nonatomic, assign) NSInteger other_tag;

/** HUD提示文字 */
@property (nonatomic, copy) NSString *hud_title;

/** MASK提示文字 */
@property (nonatomic, copy) NSString *mask_title;

/** MASK加载失败文字 */
@property (nonatomic, copy) NSString *mask_errorTitle;

/** MASK加载失败图片 */
@property (nonatomic, strong) UIImage *mask_errorImage;

/** MASK重载按钮文字 */
@property (nonatomic, copy) NSString *mask_refreshButtonTitle;

/** 是否缩进 缩进表示无文字 loading居中*/
@property (nonatomic, assign) BOOL mask_indicator;

/** HUD左右偏移量 */
@property (nonatomic, assign) CGFloat hud_offsetX;

/** HUD上下偏移量 */
@property (nonatomic, assign) CGFloat hud_offsetY;

/** 自身控制器 */
@property (nonatomic, weak) UIViewController *parentController;


/**
 *    @brief    显示loading
 *
 *    @param     hint     loading文字
 */
- (void)showHudWithHint:(NSString *)hint;


/**
 *    @brief    隐藏loading
 */
- (void)hideHud;

/**
 *    @brief    显示蒙板
 *
 *    @param     hint     提示信息
 */
- (void)showMaskWithHint:(NSString *)hint;

/**
 *    @brief    显示错误蒙板
 *
 *    @param     hint     错误信息
 */
- (void)showErrorMaskWithHint:(NSString*)hint clickBlock:(void(^)(void))clickBlock;

/**
 *    @brief    隐藏蒙板
 */
- (void)hideMask;

@end
