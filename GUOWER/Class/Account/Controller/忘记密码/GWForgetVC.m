//
//  GWForgetVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWForgetVC.h"
#import "DSNumberButton.h"
#import "UIImage+ImageWithColor.h"
//next
#import "GWForgetNextVC.h"

@interface GWForgetVC ()<UITextFieldDelegate>

/** 手机号 */
@property (weak, nonatomic) IBOutlet UITextField *gw_phoneTF;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *gw_codeTF;
/** 验证码 */
@property (weak, nonatomic) IBOutlet DSNumberButton *gw_codeBtn;
/** 下一步 */
@property (weak, nonatomic) IBOutlet UIButton *gw_nextBtn;

@end

@implementation GWForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    
    [self setupButtonSignal];

}

- (void)setupButtonSignal{
    
    [self.gw_nextBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.9)] forState:UIControlStateNormal];
    [self.gw_nextBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.3)] forState:UIControlStateDisabled];
    
    RAC(self.gw_nextBtn, enabled) = [RACSignal combineLatest:@[self.gw_phoneTF.rac_textSignal, self.gw_codeTF.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * code){
        return @(username.length == 11 && code.length == 6);
    }];
    
}


- (IBAction)gw_codeBtnMethod:(DSNumberButton *)sender {
    
    NSString *username = self.gw_phoneTF.text;
    m_CheckMobileField(username, @"请输入正确的手机号");
    [sender ol_sendNumderCodeWithMobile:username type:@"2"];
    
}

- (IBAction)gw_nextBtnMethod:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *username = self.gw_phoneTF.text;
    m_CheckMobileField(username, @"请输入正确的手机号");
    NSString *code = self.gw_codeTF.text;
    m_CheckBlankField(code, @"请输入验证码");
    
    @weakify(self);
    
    //校验验证码
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_p_checkSmsCodeWithPhone:username code:code parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        GWForgetNextVC *vc = [[GWForgetNextVC alloc]init];
        vc.gw_mobile = username;
        [self_weak_.navigationController pushViewController:vc animated:YES];
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
    }
    return YES;
    
}

@end
