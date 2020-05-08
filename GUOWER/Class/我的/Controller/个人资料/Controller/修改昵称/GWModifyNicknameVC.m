//
//  GWModifyNicknameVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/10.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWModifyNicknameVC.h"

@interface GWModifyNicknameVC () <UITextFieldDelegate>

/**  */
@property (weak, nonatomic) IBOutlet UITextField *gw_textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gw_topLayout;

@end

@implementation GWModifyNicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"昵称";
    
    self.view.backgroundColor = [UITableView appearance].backgroundColor;
    
    if (!m_VERSION(11.0)) {
        self.gw_topLayout.constant = m_TopHeight + 10;
    }
    
    self.gw_textField.text = AccountMannger_userInfo.nickName;
    
    [self setupNav];
    
}

- (void)setupNav{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(gw_nickname_save)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(15),NSFontAttributeName,m_Color_gray(47),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(15),NSFontAttributeName,m_Color_gray(188),NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    
    self.navigationItem.rightBarButtonItem = item;
    
    RAC(item, enabled) = [RACSignal combineLatest:@[self.gw_textField.rac_textSignal] reduce:^id _Nullable(NSString * nickname){
        return @(![NSString ol_isNullOrNilWithObject:nickname]&&![nickname isEqualToString:AccountMannger_userInfo.nickName]);
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.gw_textField becomeFirstResponder];
}

/**
 *    @brief    保存昵称
 */
- (void)gw_nickname_save{

    [self.view endEditing:YES];
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_user_updateNickNameWithNickName:self.gw_textField.text parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        GWUserModel *model = [GWUserModel mj_objectWithKeyValues:object];
        AccountMannger_updateUserInfo(model.nickName, @"nickName");
        [self_weak_.navigationController popViewControllerAnimated:YES];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        m_ToastCenter(message);
    } netWorkError:^(NSError *error) {
        m_ToastCenter(@"网络异常");
    }]];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.gw_textField]) {
        return [textField.text va_isOverflowInRange:range hasSpace:YES replacementString:string MaxLength:20 textField:textField];
    }
    return YES;
    
}

@end
