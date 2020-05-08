//
//  GWNavigationController.m
//  XueYouHui_User
//
//  Created by ourslook on 2018/4/24.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import "GWNavigationController.h"
#import "GWBaseVC.h"

@interface GWNavigationController ()

@end

@implementation GWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    [self.base_disposableArray addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:GWUserRepeatClickTabBarItemNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        NSString *title = x.object;
        if ([title isEqualToString:self_weak_.tabBarItem.title]) {
            
            GWBaseVC *topViewController = (GWBaseVC*)self_weak_.rt_topViewController;
            if (topViewController&&[topViewController respondsToSelector:@selector(base_userRepeatClickTabBarItem:)]) {
                [topViewController base_userRepeatClickTabBarItem:title];
            }
            
        }
        
    }]];
    
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    if (self.childViewControllers.count>0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
