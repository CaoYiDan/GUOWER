//
//  GWSubmitSuccessVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWSubmitSuccessVC.h"

@interface GWSubmitSuccessVC ()

/** 顶部约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gw_topLayout;
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *gw_imageView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *gw_titleLabel;
/** 消息 */
@property (weak, nonatomic) IBOutlet UILabel *gw_messageLabel;
/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *gw_backButton;

@end

@implementation GWSubmitSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!m_VERSION(11.00)) {
        self.gw_topLayout.constant = m_TopHeight + 55;
    }
    
    switch (self.type) {
        case GWSubmitResultCertificationSuccess:
        {
            self.title = @"提交成功";
            self.gw_imageView.image = [UIImage imageNamed:@"submit_success"];
            self.gw_titleLabel.text = @"提交成功";
            self.gw_messageLabel.text = @"请耐心等待审核";
        }
            break;
        case GWSubmitResultExchangeSuccess:
        {
            self.title = @"提交成功";
            self.gw_imageView.image = [UIImage imageNamed:@"submit_yes"];
            self.gw_titleLabel.text = @"提交成功";
            self.gw_messageLabel.text = @"24小时内会有工作人员与你联系";
        }
            break;
        case GWSubmitResultExchangeFailure:
        {
            self.title = @"提交失败";
            self.gw_imageView.image = [UIImage imageNamed:@"submit_no"];
            self.gw_titleLabel.text = @"提交失败";
            self.gw_messageLabel.text = self.message?self.message:@"重新提交一次试试";
        }
            break;
        default:
            break;
    }
    
}

/**
 *    @brief    从导航中移除部分VC
 */
- (NSArray<NSString *> *)base_removeControllersOnViewDidAppear{

    if (self.type==GWSubmitResultExchangeFailure) {
        return @[@"GWCertificationVC",@"GWCertificationResultVC"];
    }
    return @[@"GWCertificationVC",@"GWCertificationResultVC",@"GWImmediatelyVC"];
    
}

- (IBAction)gw_backMethod:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
