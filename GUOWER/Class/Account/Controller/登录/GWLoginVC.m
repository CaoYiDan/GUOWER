//
//  GWLoginVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/10.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWLoginVC.h"
#import "UIImage+ImageWithColor.h"
//register
#import "GWRegisterVC.h"
//forget
#import "GWForgetVC.h"
//jpush
#import <JPUSHService.h>

@interface GWLoginVC () <UITextFieldDelegate>

/** 手机 */
@property (weak, nonatomic) IBOutlet UITextField *gw_phoneTF;
/** 密码 */
@property (weak, nonatomic) IBOutlet UITextField *gw_pwdTF;
/** 登录 */
@property (weak, nonatomic) IBOutlet UIButton *gw_loginBtn;

@end

@implementation GWLoginVC

/**
 *    @brief    展示登录界面
 */
+(void)gw_showLoginVCWithCompletion:(void (^ __nullable)(void))completion{
    
    GWLoginVC *loginVC = [[GWLoginVC alloc]init];
    GWNavigationController *nav = [[GWNavigationController alloc]initWithRootViewController:loginVC];
    [[self currentViewController] presentViewController:nav animated:YES completion:completion];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupButtonSignal];

}

- (void)setupNav{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(gw_register)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(15),NSFontAttributeName,m_Color_gray(91),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(gw_back)];
    
}

- (void)gw_back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setupButtonSignal{
    
    [self.gw_loginBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.9)] forState:UIControlStateNormal];
    [self.gw_loginBtn setBackgroundImage:[UIImage imageWithColor:m_Color_RGBA(241,89,41,0.3)] forState:UIControlStateDisabled];
    
    RAC(self.gw_loginBtn, enabled) = [RACSignal combineLatest:@[self.gw_phoneTF.rac_textSignal, self.gw_pwdTF.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password){
        return @(username.length == 11 && password.length);
    }];
    
}

- (void)gw_register{
    
    [self.view endEditing:YES];
    GWRegisterVC *vc = [[GWRegisterVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)gw_forgetMethod:(UIButton *)sender {
    
    [self.view endEditing:YES];
    GWForgetVC *vc = [[GWForgetVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)gw_loginMethod:(id)sender {
    
    [self.view endEditing:YES];
    NSString *mobile = self.gw_phoneTF.text;
    NSString *pwd = self.gw_pwdTF.text;
    if (pwd.length<6) {
        m_ToastCenter(@"密码不能小于6位");
        return;
    }
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_p_loginWithMobile:mobile password:pwd parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
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
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.gw_phoneTF]) {
        return [textField.text va_isPureNumberInRange:range replacementString:string maxLength:11 textField:textField];
    }else if ([textField isEqual:self.gw_pwdTF]){
        return [textField.text va_isOverflowInRange:range hasSpace:YES replacementString:string MaxLength:16 textField:textField];
    }
    
    return YES;
    
}

- (BOOL)base_hiddenNavigationBarLine{
    
    return YES;
    
}

@end
