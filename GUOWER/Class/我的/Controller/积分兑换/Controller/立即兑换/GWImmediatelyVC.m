//
//  GWImmediatelyVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/16.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWImmediatelyVC.h"
//success
#import "GWSubmitSuccessVC.h"
//modle
#import "GWExchangeGoodsModel.h"
#import "GWExchangeModel.h"

@interface GWImmediatelyVC ()

/** imageview */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;
/** 商品名 */
@property (weak, nonatomic) IBOutlet UILabel *gw_nameLabel;
/** 所需积分 */
@property (weak, nonatomic) IBOutlet UILabel *gw_price;
/** 钱包地址 */
@property (weak, nonatomic) IBOutlet UITextField *gw_addressTF;
/** 提交 */
@property (weak, nonatomic) IBOutlet UIButton *gw_submitBtn;

@end

@implementation GWImmediatelyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"立即兑换";

    self.gw_imageView.ol_data = self.model.image;
    self.gw_nameLabel.text = self.model.currencyName;
    self.gw_price.text = self.model.score.stringValue;

}

- (IBAction)gw_submitBtnMethod:(id)sender {
    
    NSString *address = self.gw_addressTF.text;
    
    m_CheckBlankField(address, @"请填写钱包地址");
    
    
    
    @weakify(self);
    
    MMAlertView *alert = [[MMAlertView alloc]initWithTitle:@"提示" detail:@"确认兑换操作？" items:@[MMItemMake(@"确认", MMItemTypeNormal, ^(NSInteger index) {
        
        [self_weak_.base_sessionTaskArray addObject:[URLRequestHelper api_app_currency_exchangeWithCurrencyId:self_weak_.model.ID.stringValue purseAddress:address parentView:self_weak_.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
            
        } success:^(URLResponse *response, id object) {
            
            //计算用户最新积分
            GWExchangeModel *model = [GWExchangeModel mj_objectWithKeyValues:object];
            NSInteger newScore = AccountMannger_userInfo.score.integerValue - model.score.integerValue;
            AccountMannger_updateUserInfo([NSNumber numberWithInteger:MAX(0, newScore)], @"score");
            
            //修改库存
            NSInteger newCount = self_weak_.model.count.integerValue - 1;
            self_weak_.model.count = [NSNumber numberWithInteger:MAX(0, newCount)];
            if (self_weak_.modelChangeBlock) {
                self_weak_.modelChangeBlock();
            }
            
            GWSubmitSuccessVC *vc = [[GWSubmitSuccessVC alloc]init];
            vc.type = GWSubmitResultExchangeSuccess;
            [self_weak_.navigationController pushViewController:vc animated:YES];
            
        } failure:^(URLResponse *response, NSInteger code, NSString *message) {
            
//            m_ToastCenter(message);
            
            if ([message isEqualToString:@"库存不足"]) {
                self_weak_.model.count = @0;
                if (self_weak_.modelChangeBlock) {
                    self_weak_.modelChangeBlock();
                }
            }
            
            GWSubmitSuccessVC *vc = [[GWSubmitSuccessVC alloc]init];
            vc.type = GWSubmitResultExchangeFailure;
            vc.message = message;
            [self_weak_.navigationController pushViewController:vc animated:YES];
            
        } netWorkError:^(NSError *error) {
            
            m_ToastCenter(@"网络异常");
            
        }]];
        
    }),MMItemMake(@"取消", MMItemTypeNormal, nil)]];
    
    [alert show];
    
}


@end
