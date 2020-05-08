//
//  GWBaseVC.m
//  XueYouHui_User
//
//  Created by ourslook on 2018/4/24.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#import "GWBaseVC.h"
#import "UIImage+ImageWithColor.h"

#import <AFNetworkReachabilityManager.h>

@interface GWBaseVC ()

/** VC已经完全显示一次了 */
@property (nonatomic, assign , getter=isBase_appeared) BOOL base_appeared;

@end

@implementation GWBaseVC

+(void)load{
    
    //统一设置导航栏字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:m_FontPF_Semibold_WithSize(18), NSForegroundColorAttributeName:m_Color_gray(47)}];
    
    //默认无点击效果
    [UITableViewCell appearance].selectionStyle = UITableViewCellSelectionStyleNone;
    
    //统一设置表单背景
    [[UITableView appearance] setBackgroundColor:m_Color_RGB(240.0, 242.0, 247.0)];
    
    [UITableView appearance].separatorColor = m_Color_gray(229.0);
    
    [[UITextView appearance] setTintColor:UIColor.lightGrayColor];
    [[UITextField appearance] setTintColor:UIColor.lightGrayColor];
    
    if (@available(iOS 11.0, *)) {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.base_disposableArray = [NSMutableArray array];
    
    [self base_setupNotification];
    
    /** 给自身View记录父控制器 */
//    self.view.parentController = self;
    
}

- (void)base_setupNotification{
    
    //网络变更
    @weakify(self);

    [self.base_disposableArray addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        NSInteger status = [[x.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem] integerValue];
        [self_weak_ base_networkingReachabilityDidChange:status];
        
    }]];
    
    //用户信息变更通知
    [self.base_disposableArray addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AccountUserInfoDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        GWUserModel *model = x.object;
        [self_weak_ base_userInfoDidChange:model];
        
    }]];
    
    //用户登录状态变更通知
    [self.base_disposableArray addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AccountUserLoginStatusDidChangeDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        NSNumber *number = x.object;
        BOOL isLogon = number.boolValue;
        [self_weak_ base_loginStatusDidChange:isLogon];
        
    }]];
    
}

#pragma mark -- -- -- 返回按钮

-(UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{


    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:target action:action];
    
    return backItem;

}


/** 关闭键盘 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];

}

/** 调整按钮 */
-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    NSArray *leftItems = self.navigationItem.leftBarButtonItems;
    
    for (UIBarButtonItem *item in leftItems) {
        UIView *view = item.customView;
        if ([view isKindOfClass:UIButton.class]) {
            UIButton *button = (UIButton*)view;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
    }
    
    NSArray *rightItems = self.navigationItem.rightBarButtonItems;
    
    for (UIBarButtonItem *item in rightItems) {
        UIView *view = item.customView;
        if ([view isKindOfClass:UIButton.class]) {
            UIButton *button = (UIButton*)view;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    /** 去除导航分割线 */
    if ([self base_hiddenNavigationBarLine]) {
        //去除导航分割线
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        for (UIView *view in backgroundView.subviews) {
            if (CGRectGetHeight([view frame]) <= 1) {
                view.hidden = YES;
            }
        }
    }
    
    /** 设置导航是否是白色 */
    if ([self base_navigationBarWhiteStyle]) {

//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColor.whiteColor] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isBase_appeared) return;
    
    //获取要移除的VC
    NSArray<NSString*> *array = [self base_removeControllersOnViewDidAppear];
    if (array.count) {
        
        //记录获取到的需要移除的全部VC
        NSMutableArray *delArray = [NSMutableArray array];
        NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"base_className == %@",obj];
            NSArray *findVCs = [vcArray filteredArrayUsingPredicate:predicate];
            [delArray addObjectsFromArray:findVCs];
            
        }];
        [vcArray removeObjectsInArray:delArray];
        self.navigationController.viewControllers = vcArray;
        
    }
    
    self.base_appeared = YES;
    
}

/** 导航是否是白色 默认:YES */
-(BOOL)base_navigationBarWhiteStyle{
    
    return YES;
    
}

/** 是否隐藏导航条黑线 默认:NO */
-(BOOL)base_hiddenNavigationBarLine{
    
    return NO;

}

/** 网络变更回调 */
- (void)base_networkingReachabilityDidChange:(GWNetworkReachabilityStatus)status{
    
}

/** 用户登录状态变更 */
- (void)base_loginStatusDidChange:(BOOL)isLogin{
    
}

/** 用户信息变更 */
- (void)base_userInfoDidChange:(GWUserModel*)userInfo{
    

}

/** 用户重复点击TabBarItem回调 */
- (void)base_userRepeatClickTabBarItem:(NSString*)title{}

/** 视图显示后移除部分控制器 */
- (NSArray<NSString*>*)base_removeControllersOnViewDidAppear{
    return nil;
}

-(void)dealloc{
    
    [self.base_disposableArray makeObjectsPerformSelector:@selector(dispose)];
    
    NSLog(@"%@ 销毁了",self.class);
    
}

@end
