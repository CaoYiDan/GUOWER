//
//  GWUserSignaVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWUserSignaVC.h"
#import "XMTextView.h"

@interface GWUserSignaVC ()

/** contentView */
@property (weak, nonatomic) IBOutlet UIView *gw_view;
/** topLayout */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gw_topLayout;
/** textView */
@property (nonatomic, weak) XMTextView *textView;

@end

@implementation GWUserSignaVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个性签名";
    
    if (!m_VERSION(11.0)) {
        self.gw_topLayout.constant = m_TopHeight;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(gw_nickname_save)];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(15),NSFontAttributeName,m_Color_gray(47),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:m_FontPF_Regular_WithSize(15),NSFontAttributeName,m_Color_gray(188),NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    item.enabled = NO;
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = [UITableView appearance].backgroundColor;
    
    XMTextView *textView = [[XMTextView alloc]initWithFrame:CGRectMake(0, 0, m_ScreenW, 165)];
    [self.gw_view addSubview:textView];
    textView.placeholder = @"添加个性签名…";
    textView.placeholderColor = m_Color_gray(188);
    textView.maxNumColor = m_Color_gray(188);
    textView.textMaxNum = 30;
    textView.tvColor = m_Color_gray(47);
    textView.isSetBorder = NO;
    self.textView = textView;
    
    
    textView.textViewListening = ^(NSString *textViewStr) {
        item.enabled = ![NSString ol_isNullOrNilWithObject:textViewStr];
    };
    
    //回显
    [textView setContentStr:AccountMannger_userInfo.signature];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UITextView *textView = [self.textView valueForKeyPath:@"textView"];
    [textView becomeFirstResponder];
}

-(void)gw_nickname_save{
    
    [self.view endEditing:YES];
    
    UITextView *textView = [self.textView valueForKeyPath:@"textView"];
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_user_updateSignatureWithSignature:textView.text parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        
        GWUserModel *model = [GWUserModel mj_objectWithKeyValues:object];
        AccountMannger_updateUserInfo(model.signature, @"signature");
        [self_weak_.navigationController popViewControllerAnimated:YES];
        
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        m_ToastCenter(message);
    } netWorkError:^(NSError *error) {
        m_ToastCenter(@"网络异常");
    }]];
    
}

@end
