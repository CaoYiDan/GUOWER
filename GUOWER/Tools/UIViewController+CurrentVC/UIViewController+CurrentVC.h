//
//  UIViewController+CurrentVC.h
//  XueYouHui_User
//
//  Created by ourslook on 2018/4/24.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CurrentVC)

/**
 *    @brief    获取顶层控制器
 *
 *    @return    控制器
 */
+ (UIViewController *)currentViewController;

@end
