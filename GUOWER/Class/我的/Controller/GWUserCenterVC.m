//
//  GWUserCenterVC.m
//  GUOWER
//
//  Created by ourslook on 2018/6/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import  "GWUserCenterVC.h"
#import <SDAutoLayout.h>
//cells
#import "GWUserLogoutCell.h"
#import "GWUserLoginCell.h"
//userinfo
#import "GWUserInfoVC.h"
//login
#import "GWLoginVC.h"
//certification
#import "GWCertificationVC.h"
//certificationResult
#import "GWCertificationResultVC.h"
//myArticle
#import "GWMyArticleVC.h"
//exchange
#import "GWExchangeVC.h"
//restPWD
#import "GWResetPasswordVC.h"
//certificationModel
#import "GWCertificationModel.h"
//shareView
#import "VAShareView.h"
//clauseModel
#import "GWClauseModel.h"
//web
#import "VAWebViewController.h"

@interface GWUserCenterVC ()<UIWebViewDelegate>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *gw_array;

/** 用户认证信息 */
@property (nonatomic, strong) GWCertificationModel *certificationModel;
/** 用户认证信息请求 */
@property (nonatomic, weak) NSURLSessionTask *certificationTask;

@property(nonatomic,assign)BOOL canShow;

@end

@implementation GWUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置表单
    [self setupTableView];

}

- (void)setupTableView{
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorColor = m_Color_gray(229.00);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWUserLogoutCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWUserLogoutCell.class)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWUserLoginCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWUserLoginCell.class)];
    
}

#pragma mark - UITableViewDataSource

/**
 *  行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.gw_array[section] count];
    
}

/**
 *  区数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.gw_array.count;
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        if (AccountMannger_isLogin) {//用户登录
            
            GWUserLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWUserLoginCell.class)];
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow"]];
            cell.model = AccountMannger_userInfo;
            return cell;
            
        }else{//用户未登录
            
            GWUserLogoutCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWUserLogoutCell.class)];
            return cell;
            
        }
        
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self.class)];
        }
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow"]];
        
        cell.textLabel.textColor = m_Color_gray(47);
        cell.textLabel.font = m_FontPF_Regular_WithSize(15);
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.textColor = m_Color_gray(91);
        cell.detailTextLabel.font = m_FontPF_Regular_WithSize(14);
        [[cell.contentView viewWithTag:3] removeFromSuperview];
        
        NSString *string = self.gw_array[indexPath.section][indexPath.row];
        
        cell.textLabel.text = string;
        
        if ([string isEqualToString:@"认证申请"]) {
            
            cell.detailTextLabel.textColor = m_Color_gray(153.00);
            if (AccountMannger_isLogin&&self.certificationModel) {
                switch (self.certificationModel.result.integerValue) {
                    case GWCertificationResultOngoing:
                        cell.detailTextLabel.text = @"等待审核";
                        break;
                    case GWCertificationResultSuccess:
                        cell.detailTextLabel.text = @"已认证";
                        break;
                    case GWCertificationResultFailure:
                        cell.detailTextLabel.text = @"认证失败";
                        break;
                    default:
                        break;
                }
            }else{
                cell.detailTextLabel.text = nil;
            }
            
        }else if ([string isEqualToString:@"积分兑换"]){
            
            if (AccountMannger_isLogin) {
                cell.detailTextLabel.textColor = m_Color_gray(153.00);
                cell.detailTextLabel.text = m_NSStringFormat(@"%@ 积分",AccountMannger_userInfo.score.stringValue);
            }
            
        }else if ([string isEqualToString:@"版本"]) {
            
            cell.textLabel.text = @"版本";
            NSString *version=[[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"];
            cell.accessoryView = nil;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@", version];
            
        }else if ([string isEqualToString:@"退出登录"]){
            
            UILabel *label = [[UILabel alloc]init];
            label.text = @"退出登录";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = m_FontPF_Regular_WithSize(15);
            label.textColor = m_Color_gray(91);
            label.tag = 3;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            
            cell.textLabel.text = nil;
            cell.accessoryView = nil;
            
        }
        
        return cell;
        
    }
    
    return UITableViewCell.alloc.init;
    
}

/**
 *  行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        CGFloat height = [tableView cellHeightForIndexPath:indexPath model:AccountMannger_userInfo keyPath:@"model" cellClass:GWUserLoginCell.class contentViewWidth:m_ScreenW];
        return AccountMannger_isLogin?MAX(height, 113) :113;
    }
    return 44;
    
}

/**
 *  区尾高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

#pragma mark - UITableViewDelegate

/**
 *  单元格点击
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        if (AccountMannger_isLogin) {//用户详情
            
            GWUserInfoVC *vc = [[GWUserInfoVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{//前往登录
            
            [GWLoginVC gw_showLoginVCWithCompletion:nil];
            
        }
    }else if (indexPath.section!=4){
        
       
        
        NSString *string = self.gw_array[indexPath.section][indexPath.row];
        
        if ([string isEqualToString:@"推荐果味财经给好友"]) {
            
            VAShareView *view = [[VAShareView alloc]init];
            VAShareModel *model = [[VAShareModel alloc]init];
            model.title = @"果味财经，数字经济×流行主义信息媒体,90×00正在流行使用果味财经,为中国数字经济爱好者提供最新的流行新闻资讯";
            model.descr = @"果味财经创建于2018年，是是数字经济×流行主义信息媒体,90×00正在流行使用果味财经,为中国数字经济爱好者提供最新的流行新闻资讯。，以专业、权威为报道标准，为用户提供有价值的信息服务。果味财经现已形成集文字、图片、视频于一体的报道形式。内容板块包括：快讯、头条、新闻、政策、区块链、创业+，涵盖新闻资讯、通俗科普、深度报道、视频专题、人物访问、舆论动态观察等多形态栏目，以行业视角关注新经济与创新领域的创新探索，为金融科技行业输出有价值的创新活力。果味财经目前拥有数以百计的专栏作者汇聚于此，形成了国内最富有创新活力的新经济与创新平台。目前已经有200余名专栏作者在此创作，累计发表100多篇文章。果味财经正以专业、严肃的态度输出有价值的金融科技思想，抢新经济与创新行业内容制高点。";
            model.thumbImage = [UIImage imageNamed:@"app_icon"];
            model.url = @"http://www.iguower.com/Download";
            [view showShareViewWithShareModel:model shareContentType:VAShareContentTypeText];
            
        }else if ([string isEqualToString:@"关于果味财经"]){
            
            @weakify(self);
            [self.base_sessionTaskArray addObject:[URLRequestHelper api_cfg_clauseWithClauseType:@"CLAUSE_ABOUT" parentView:self.navigationController.view hasHud:YES hasMask:NO end:^(URLResponse *response) {
                
            } success:^(URLResponse *response, id object) {
                
                GWClauseModel *model = [GWClauseModel mj_objectWithKeyValues:object];
                VAWebViewController *vc = [[VAWebViewController alloc]initWithType:VAWebViewContentHTMLString content:model.content];
                vc.title = @"关于果味财经";
                [self_weak_.navigationController pushViewController:vc animated:YES];
                
            } failure:^(URLResponse *response, NSInteger code, NSString *message) {
                m_ToastCenter(message);
            } netWorkError:^(NSError *error) {
                m_ToastCenter(@"网络异常");
            }]];
            
        }else{
            
            if ([string isEqualToString:@"版本"]) return;
            
            m_CheckUserLogin;
            
            if ([string isEqualToString:@"认证申请"]) {
                
                //查看认证状态
                if ([self.certificationModel.result isEqualToNumber:@3]) {//未认证
                    GWCertificationVC *vc = [[GWCertificationVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }else if(self.certificationModel){//认证过
                    GWCertificationResultVC *vc = [[GWCertificationResultVC alloc]init];
                    vc.resultModel = self.certificationModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else if ([string isEqualToString:@"我的文章"]){
                
                GWMyArticleVC *vc = [[GWMyArticleVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([string isEqualToString:@"积分兑换"]){
                
                GWExchangeVC *vc = [[GWExchangeVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([string isEqualToString:@"登录密码设置"]){
                
                GWResetPasswordVC *vc = [[GWResetPasswordVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
        
    }else{//退出登录
        
        MMAlertView *alert = [[MMAlertView alloc]initWithTitle:@"提示" detail:@"确认要退出登录吗？" items:@[MMItemMake(@"确认", MMItemTypeNormal, ^(NSInteger index) {
            AccountMannger_removeUserInfo;
        }),MMItemMake(@"取消", MMItemTypeNormal, nil)]];
        
        [alert show];
        
    }
    
}

/**
 *  获取用户最新认证信息
 */
- (void)gw_getExamineType{
    
    if (AccountMannger_isLogin) {
        
        //如果用户已认证并且认证成功 不请求
        if (self.certificationModel&&[self.certificationModel.result isEqualToNumber:@1]) return;
        //取消之前的请求
        [self.certificationTask cancel];
        //发起请求
        @weakify(self);
        self.certificationTask = [URLRequestHelper api_app_user_getExamineTypeWithToken:nil parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
            
        } success:^(URLResponse *response, id object) {
            
            GWCertificationModel *model = [GWCertificationModel mj_objectWithKeyValues:object];
            if (model&&[model.result isEqualToNumber:@1]) {//认证通过  更新用户model
                AccountMannger_updateUserInfoNoNotice(model.userType, @"userLevel");
            }else if([NSString ol_isNullOrNilWithObject:model]){//未认证 添加未认证标识符
                model = [[GWCertificationModel alloc]init];
                model.result = @3;
            }
            self_weak_.certificationModel = model;
            [self_weak_.tableView reloadData];
            
        } failure:^(URLResponse *response, NSInteger code, NSString *message) {
            
        } netWorkError:^(NSError *error) {
            
        }];
        
    }
    
}

- (NSMutableArray *)gw_array{
    
    if (!_gw_array) {
        _gw_array = [NSMutableArray array];
        
        [_gw_array addObject:@[@""]];
        [_gw_array addObject:@[@"认证申请"]];
        if (AccountMannger_isLogin){
            GWUserModel *model = AccountMannger_userInfo;
            if ([model.tel isEqualToString:@"17610240017"]) {
                
                [_gw_array addObject:@[@"我的文章"]];
            }else{
                [_gw_array addObject:@[@"我的文章",@"积分兑换"]];
            }
        }else{
            [_gw_array addObject:@[@"我的文章"]];
        }
        
        [_gw_array addObject:@[@"登录密码设置",@"推荐果味财经给好友",@"关于果味财经",@"版本"]];
        
        if (AccountMannger_isLogin) {
            [_gw_array addObject:@[@"退出登录"]];
        }
        
    }
    return _gw_array;
    
}

#pragma mark -- VC配置信息

/**
 *    @brief    用户信息变更回调
 */
- (void)base_userInfoDidChange:(GWUserModel *)userInfo{
    [super base_userInfoDidChange:userInfo];
    
    //需要重新拉取Cell显示信息
    self.gw_array = nil;
    [self.tableView reloadData];
    
}

/**
 *    @brief    用户登录状态变更回调
 */
- (void)base_loginStatusDidChange:(BOOL)isLogin{
    [super base_loginStatusDidChange:isLogin];
    
    //需要重新拉取Cell显示信息
    self.gw_array = nil;
    [self.tableView reloadData];
    //用户登录状态变更 无论认证与否 重新拉取认证信息
    self.certificationModel = nil;
    //获取用户最新认证信息
    [self gw_getExamineType];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取用户最新认证信息
    [self gw_getExamineType];
}

@end
