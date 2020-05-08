//
//  GWBaseVC.h
//  XueYouHui_User
//
//  Created by ourslook on 2018/4/24.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWBaseVC : UIViewController

/** 信号量数组 避免子控制器误删 ol__disposableArray 单独写 */
@property (nonatomic, strong) NSMutableArray <RACDisposable*> *base_disposableArray;

/** 导航是否是白色 默认:YES */
- (BOOL)base_navigationBarWhiteStyle;

/** 是否隐藏导航条黑线 默认:NO */
- (BOOL)base_hiddenNavigationBarLine;

/** 网络变更回调 */
- (void)base_networkingReachabilityDidChange:(GWNetworkReachabilityStatus)status NS_REQUIRES_SUPER;

/** 用户登录状态变更 */
- (void)base_loginStatusDidChange:(BOOL)isLogin NS_REQUIRES_SUPER;

/** 用户信息变更 */
- (void)base_userInfoDidChange:(GWUserModel*)userInfo NS_REQUIRES_SUPER;

/** 用户重复点击TabBarItem回调 */
- (void)base_userRepeatClickTabBarItem:(NSString*)title;

/** 视图显示后移除部分控制器 */
- (NSArray<NSString*>*)base_removeControllersOnViewDidAppear;

@end
