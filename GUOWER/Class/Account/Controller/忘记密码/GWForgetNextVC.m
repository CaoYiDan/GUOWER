//
//  GWForgetNextVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWForgetNextVC.h"
#import "UIImage+ImageWithColor.h"
//Jpush
#import <JPUSHService.h>

@interface GWForgetNextVC ()<UITextFieldDelegate>

/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *gw_pwdTF;
/** 再次密码 */
@property (weak, nonatomic) IBOutlet UITextField *gw_pwdTF1;
/** 登录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *gw_loginBtn;

@end

@implementation GWForgetNextVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"忘记密码";
    
    [self setupButtonSignal];
    
}

- (void)setupButtonSignal{
    
    [self.gw_loginBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.9)] forState:UIControlStateNormal];
    [self.gw_loginBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.3)] forState:UIControlStateDisabled];
    
    RAC(self.gw_loginBtn, enabled) = [RACSignal combineLatest:@[self.gw_pwdTF.rac_textSignal, self.gw_pwdTF1.rac_textSignal] reduce:^id _Nullable(NSString * password, NSString * password1){
        return @(password.length >=6 && password1.length >=6);
    }];
    
}

- (IBAction)gw_loginBtnMethod:(UIButton *)sender {
    
    NSString *pwd = self.gw_pwdTF.text;
    NSString *pwd1 = self.gw_pwdTF1.text;
    
    if (![pwd isEqualToString:pwd1]) {
        m_ToastCenter(@"密码输入不一致");
        return;
    }
    
    [self.navigationController.view showHudWithHint:nil];

    NSString *mobile = self.gw_mobile;
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_p_pwdForgetWithMobile:mobile newPassword:pwd parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        [self_weak_.base_sessionTaskArray addObject:[URLRequestHelper api_p_loginWithMobile:mobile password:pwd parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
            
            [self_weak_.navigationController.view hideHud];
            
        } success:^(URLResponse *response, id object) {
            
            GWUserModel *model = [GWUserModel mj_objectWithKeyValues:object];
            AccountMannger_setUserInfo(model);
            [JPUSHService setAlias:model.ID.stringValue completion:nil seq:0];
            [self_weak_ dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(URLResponse *response, NSInteger code, NSString *message) {
            
            m_ToastCenter(message);
            
        } netWorkError:^(NSError *error) {
            
            m_ToastCenter(@"网络异常");
            
        }]];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        
        [self_weak_.navigationController.view hideHud];
        m_ToastCenter(message);
        
    } netWorkError:^(NSError *error) {
        
        [self_weak_.navigationController.view hideHud];
        m_ToastCenter(@"网络异常");
        
    }]];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return [textField.text va_isOverflowInRange:range hasSpace:YES replacementString:string MaxLength:16 textField:textField];
    
}

@end
