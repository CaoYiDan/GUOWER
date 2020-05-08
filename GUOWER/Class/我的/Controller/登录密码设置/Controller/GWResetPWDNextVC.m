//
//  GWResetPWDNextVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWResetPWDNextVC.h"

@interface GWResetPWDNextVC ()
@property (weak, nonatomic) IBOutlet UITextField *gw_pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *gw_pwd1;

@end

@implementation GWResetPWDNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录密码设置";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(gw_save)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(14),NSFontAttributeName,m_Color_gray(47),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(14),NSFontAttributeName,m_Color_gray(188),NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    item.enabled = NO;
    self.navigationItem.rightBarButtonItem = item;
    
    [self setupItemSignal];
    
}

- (void)gw_save {
    
    [self.view endEditing:YES];
    
    NSString *pwd = self.gw_pwdTF.text;
    if (pwd.length<6) {
        m_ToastCenter(@"请输入6-16位新密码");
        return;
    }
    NSString *pwd1 = self.gw_pwd1.text;
    if (pwd1.length<6) {
        m_ToastCenter(@"请再次输入6-16位新密码");
        return;
    }
    
    if (![pwd isEqualToString:pwd1]) {
        m_ToastCenter(@"密码输入不一致");
        return;
    }
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_p_pwdUpdateWithMobile:AccountMannger_userInfo.tel msgcode:self.msgCode password:pwd parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        m_ToastCenter(@"密码修改成功");
        [self_weak_.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        m_ToastCenter(message);
    } netWorkError:^(NSError *error) {
        m_ToastCenter(@"网络异常");
    }]];
    
    
}

- (void)setupItemSignal{
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[self.gw_pwdTF.rac_textSignal, self.gw_pwd1.rac_textSignal] reduce:^id _Nullable(NSString * pwd, NSString * pwd1){
        return @(pwd.length >= 6 && pwd1.length >= 6);
    }];
    
}

@end
