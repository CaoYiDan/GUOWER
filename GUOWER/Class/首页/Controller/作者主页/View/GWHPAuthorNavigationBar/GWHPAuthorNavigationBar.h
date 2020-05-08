//
//  GWHPAuthorNavigationBar.h
//  GUOWER
//
//  Created by ourslook on 2018/7/3.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWHPAuthorNavigationBar : UINavigationBar

/** 偏移及透明属性 */
@property (nonatomic, assign) CGFloat gw_alpha;

/** 头像 */
@property (nonatomic, strong) id ol_data;

/** 昵称 */
@property (nonatomic, copy) NSString *gw_name;

@end
