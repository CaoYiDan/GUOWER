//
//  GWResetPasswordVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWResetPasswordVC.h"
//codeButton
#import "DSNumberButton.h"
//next
#import "GWResetPWDNextVC.h"

@interface GWResetPasswordVC ()<UITextFieldDelegate>

/** 手机号 */
@property (weak, nonatomic) IBOutlet UILabel *gw_phoneLabel;
/** 验证码 */
@property (weak, nonatomic) IBOutlet UITextField *gw_codeTF;
/** 验证码 */
@property (weak, nonatomic) IBOutlet DSNumberButton *gw_codeBtn;

@end

@implementation GWResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录密码设置";
    
    self.gw_phoneLabel.text = AccountMannger_userInfo.tel;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(gw_next)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(14),NSFontAttributeName,m_Color_gray(47),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(14),NSFontAttributeName,m_Color_gray(188),NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    item.enabled = NO;
    self.navigationItem.rightBarButtonItem = item;
    
    [self setupItemSignal];

}

- (void)gw_next{
    
    [self.view endEditing:YES];
    
    NSString *phone = self.gw_phoneLabel.text;
    m_CheckMobileField(phone, @"请输入正确的手机号")
    NSString *code = self.gw_codeTF.text;
    m_CheckBlankField(code, @"请输入验证码")
    
    @weakify(self);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_p_checkSmsCodeWithPhone:phone code:code parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        GWResetPWDNextVC *next = [[GWResetPWDNextVC alloc]init];
        next.msgCode = code;
        [self_weak_.navigationController pushViewController:next animated:YES];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        m_ToastCenter(message);
    } netWorkError:^(NSError *error) {
        m_ToastCenter(@"网络异常");
    }]];
    
    
    
}

- (IBAction)gw_getCodeMethod:(DSNumberButton *)sender {
    
    NSString *username = AccountMannger_userInfo.tel;
    m_CheckMobileField(username, @"请输入正确的手机号");
    [sender ol_sendNumderCodeWithMobile:username type:@"3"];
    
}

- (void)setupItemSignal{
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[self.gw_codeTF.rac_textSignal] reduce:^id _Nullable(NSString * code){
        return @(code.length == 6);
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.gw_codeTF]){
        return [textField.text va_isPureNumberInRange:range replacementString:string maxLength:6 textField:textField];
    }
    
    return YES;
    
}

@end
