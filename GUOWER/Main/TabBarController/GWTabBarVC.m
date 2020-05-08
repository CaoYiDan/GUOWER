//
//  GWTabBarVC.m
//  XueYouHui_User
//
//  Created by ourslook on 2018/4/24.
//  Copyright © 2018年 Ourslook. All rights reserved.

#import "GWTabBarVC.h"
#import "UIImage+ImageWithColor.h"
#import "GWNavigationController.h"

@interface GWTabBarVC ()<UITabBarControllerDelegate>

/** UITabBarItem重复响应时间间隔 */
@property (nonatomic, assign) CFAbsoluteTime gw_lastClickTime;

@end

@implementation GWTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:m_hexColor(0x666666),NSFontAttributeName:m_FontPF_Regular_WithSize(10)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:GW_ThemeColor,NSFontAttributeName:m_FontPF_Regular_WithSize(10)} forState:UIControlStateSelected];

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    CGFloat now = CFAbsoluteTimeGetCurrent();
    //响应重复点击的时间间隔为0.5秒
    double jetLag = now - self.gw_lastClickTime;
    if (jetLag < 0.5) {
        self.gw_lastClickTime = now;
        return;
    }
    if ([self.selectedViewController.tabBarItem.title isEqualToString:item.title]) {
        self.gw_lastClickTime = now;
        //重复点击某一个item
        [[NSNotificationCenter defaultCenter] postNotificationName:GWUserRepeatClickTabBarItemNotification object:item.title];

    }

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
