//
//  GWSafariViewController.m
//  GUOWER
//
//  Created by ourslook on 2018/7/26.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWSafariViewController.h"

@interface GWSafariViewController ()

@end

@implementation GWSafariViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 10.0, *)) {
        self.preferredControlTintColor = GW_ThemeColor;
    }
    
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:target action:action];
    
    return backItem;
    
}

@end
