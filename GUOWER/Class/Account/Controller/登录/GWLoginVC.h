//
//  GWLoginVC.h
//  GUOWER
//
//  Created by ourslook on 2018/7/10.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWBaseVC.h"

@interface GWLoginVC : GWBaseVC

/**
 *    @brief    展示登录界面
 */
+(void)gw_showLoginVCWithCompletion:(void (^ __nullable)(void))completion;

@end
