//
//  GWUserInfoVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/9.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWUserInfoVC.h"
//imagePicker
#import "VAImagePicker.h"
//ModifyNickname
#import "GWModifyNicknameVC.h"
//Signa
#import "GWUserSignaVC.h"

@interface GWUserInfoVC ()

/** 数据 */
@property (nonatomic, strong) NSArray *gw_array;

@end

@implementation GWUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人资料";
    
    [self setupTableView];

}

- (void)setupTableView{
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = m_Color_gray(229.00);
    
}

#pragma mark - UITableViewDataSource

/**
 *  行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gw_array.count;
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //userModel
    GWUserModel *model = AccountMannger_userInfo;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self.class)];
    }
    
    NSString *string = [self.gw_array objectAtIndex:indexPath.row];
    
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow"]];
    cell.textLabel.textColor = m_Color_gray(47);
    cell.textLabel.font = m_FontPF_Regular_WithSize(15);
    cell.detailTextLabel.text = nil;
    cell.detailTextLabel.textColor = m_Color_gray(153);
    cell.detailTextLabel.font = m_FontPF_Regular_WithSize(14);
    cell.textLabel.text = string;
    [[cell.contentView viewWithTag:3] removeFromSuperview];
    
    if ([string isEqualToString:@"头像"]) {
        
        ZYLoadingImageView *headerImage = [[ZYLoadingImageView alloc]init];
        headerImage.ol_placeholder = [UIImage imageNamed:@"user_header"];
        headerImage.ol_data = model.headPortrait;
        headerImage.tag = 3;
        headerImage.cornerRadius_ol = 31;
        headerImage.masksToBounol_ol = YES;
        [cell.contentView addSubview:headerImage];
        [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(62);
        }];
        
    }else if ([string isEqualToString:@"昵称"]){
        cell.detailTextLabel.text = model.nickName;
    }else if ([string isEqualToString:@"个性签名"]){
        cell.detailTextLabel.text = [NSString ol_isNullOrNilWithObject:model.signature]?@"这个人有点忙，还没写个性签名":model.signature;
    }else if ([string isEqualToString:@"会员等级"]){
        cell.accessoryView = nil;
        //1.企业认证 2.作者认证 3.媒体认证
        switch (model.userLevel.integerValue) {
            case GWCertificationEnterprise://企业
                cell.detailTextLabel.text = @"企业认证";
                break;
            case GWCertificationAuthor://作者
                cell.detailTextLabel.text = @"作者认证";
                break;
            case GWCertificationMedia://媒体
                cell.detailTextLabel.text = @"媒体认证";
                break;
            default:
                cell.detailTextLabel.text = @"未认证";
                break;
        }
        
    }else if ([string isEqualToString:@"手机号码"]){
        cell.accessoryView = nil;
        cell.detailTextLabel.text = model.tel;
    }
    
    return cell;
}

/**
 *  行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 100;
    }
    return 50;
    
}


#pragma mark - UITableViewDelegate

/**
 *  单元格点击
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *string = self.gw_array[indexPath.row];
    if ([string isEqualToString:@"头像"]) {
        @weakify(self);
        [VAImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
            if (image) {
                [self_weak_.navigationController.view showHudWithHint:nil];
                [self_weak_.base_sessionTaskArray addObject:[URLRequestHelper api_fileUploadWithImage:image end:nil success:^(URLResponse *response, id object) {
                    NSString *url = object;
                    //更新用户信息
                    [self_weak_.base_sessionTaskArray addObject:[URLRequestHelper api_app_user_updateHeadWithHeadPortrait:url parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
                        [self_weak_.navigationController.view hideHud];
                    } success:^(URLResponse *response, id object) {
                        AccountMannger_updateUserInfo(url, @"headPortrait");
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
        }];
    }else if ([string isEqualToString:@"昵称"]){
        
        GWModifyNicknameVC *vc = [[GWModifyNicknameVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([string isEqualToString:@"个性签名"]){
        
        GWUserSignaVC *vc = [[GWUserSignaVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (NSArray *)gw_array{
    
    if (!_gw_array) {
        _gw_array = @[@"头像",@"昵称",@"个性签名",@"会员等级",@"手机号码"];
    }
    return _gw_array;
    
}

/** 用户信息变更 */
- (void)base_userInfoDidChange:(GWUserModel *)userInfo{
    
    [super base_userInfoDidChange:userInfo];
    
    [self.tableView reloadData];
    
}

@end
