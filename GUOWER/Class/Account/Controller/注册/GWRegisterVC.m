//
//  GWRegisterVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWRegisterVC.h"
#import "DSNumberButton.h"
#import "UIImage+ImageWithColor.h"

@interface GWRegisterVC ()<UITextFieldDelegate>

/** 电话 */
@property (weak, nonatomic) IBOutlet UITextField *gw_phoneTF;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *gw_pwdTF;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *gw_codeTF;
/** 注册按钮 */
@property (weak, nonatomic) IBOutlet UIButton *gw_registerBtn;
/** 获取验证码按钮 */
@property (weak, nonatomic) IBOutlet DSNumberButton *gw_codeBtn;

@end

@implementation GWRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    [self setupButtonSignal];

}

- (void)setupButtonSignal{
    
    [self.gw_registerBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.9)] forState:UIControlStateNormal];
    [self.gw_registerBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.3)] forState:UIControlStateDisabled];
    
    RAC(self.gw_registerBtn, enabled) = [RACSignal combineLatest:@[self.gw_phoneTF.rac_textSignal, self.gw_pwdTF.rac_textSignal, self.gw_codeTF.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password, NSString * code){
        return @(username.length == 11 && password.length >= 6 && code.length == 6);
    }];
    
}

- (IBAction)ge_codeBtnMethod:(DSNumberButton *)sender {
    
    NSString *username = self.gw_phoneTF.text;
    m_CheckMobileField(username, @"请输入正确的手机号");
    [sender ol_sendNumderCodeWithMobile:username type:@"1"];
    
}

- (IBAction)gw_registerBtnMethod:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *phone = self.gw_phoneTF.text;
    NSString *pwd = self.gw_pwdTF.text;
    NSString *code = self.gw_codeTF.text;
    
    m_CheckMobileField(phone, @"请输入正确的手机号");
    m_CheckBlankField(pwd, @"请填写密码");
    m_CheckBlankField(code, @"请填写验证码");
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_p_registerWithMobile:phone password:pwd msgcode:code parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        m_ToastCenter(@"注册成功");
        [self_weak_.navigationController popViewControllerAnimated:YES];
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        m_ToastCenter(message);
    } netWorkError:^(NSError *error) {
        m_ToastCenter(@"网络异常");
    }]];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.gw_phoneTF]) {
        return [textField.text va_isPureNumberInRange:range replacementString:string maxLength:11 textField:textField];
    }else if ([textField isEqual:self.gw_codeTF]){
        return [textField.text va_isPureNumberInRange:range replacementString:string maxLength:6 textField:textField];
    }else if ([textField isEqual:self.gw_pwdTF]){
        return [textField.text va_isOverflowInRange:range hasSpace:YES replacementString:string MaxLength:16 textField:textField];
    }
    return YES;
    
}

@end
