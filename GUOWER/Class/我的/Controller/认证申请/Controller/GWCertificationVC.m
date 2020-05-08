//
//  GWCertificationVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCertificationVC.h"
#import <SDAutoLayout.h>
#import "JGActionSheet.h"
#import "UIImage+ImageWithColor.h"
//model
#import "GWCertificationUIModel.h"
//cells
#import "GWCertificationEditCell.h"
#import "GWCertificationImageCell.h"
#import "GWCertificationSectionHeaderView.h"
//submitSuccess
#import "GWSubmitSuccessVC.h"

@interface GWCertificationVC ()

/** 认证类型 */
@property (nonatomic, assign) GWCertificationType type;
/** 认证类型Cell */
@property (nonatomic, strong) GWCertificationUIModel *certificationTypeModle;
/** 姓名Cell */
@property (nonatomic, strong) GWCertificationUIModel *nameModel;
/** 身份证号Cell */
@property (nonatomic, strong) GWCertificationUIModel *IDCardModle;
/** 手机号码Cell */
@property (nonatomic, strong) GWCertificationUIModel *mobileModle;
/** 邮箱Cell */
@property (nonatomic, strong) GWCertificationUIModel *emailModle;
/** 证件照Cell */
@property (nonatomic, strong) GWCertificationUIModel *pictureModle;
/** 企业名称Cell */
@property (nonatomic, strong) GWCertificationUIModel *enterpriseNameModle;
/** 企业证件号Cell */
@property (nonatomic, strong) GWCertificationUIModel *businessCertificateNumModle;
/** 营业执照Cell */
@property (nonatomic, strong) GWCertificationUIModel *businessCertificatepPictureModle;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray <NSArray*> *array;

@end

@implementation GWCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请认证";
    
    [self setupTableView];
    
}

- (void)setupTableView{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:GWCertificationSectionHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(GWCertificationSectionHeaderView.class)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(GWCertificationEditCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(GWCertificationEditCell.class)];
    [self.tableView registerClass:GWCertificationImageCell.class forCellReuseIdentifier:NSStringFromClass(GWCertificationImageCell.class)];
    
    //footer
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, m_ScreenW, 150)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:GW_OrangeColor] forState:UIControlStateNormal];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button.titleLabel setFont:m_FontPF_Regular_WithSize(16)];
    button.cornerRadius_ol = 20;
    button.masksToBounol_ol = YES;
    [footer addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    
    @weakify(self);
    [self.base_disposableArray addObject:[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

        //提交审核
        [self_weak_ gw_submitAudit];
        
    }]];

    
    self.tableView.tableFooterView = footer;
    
}

#pragma mark - UITableViewDataSource

/**
 *  行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array[section] count];
}

/**
 *  区数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GWCertificationUIModel *model = self.array[indexPath.section][indexPath.row];
    
    if ([model.cellClass isEqual:UITableViewCell.class]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self.class)];
        }
        cell.accessoryView = model.cellHasArrow?[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow"]]:nil;
        cell.textLabel.text = model.cellTitle;
        BOOL hasSubTitle = ![NSString ol_isNullOrNilWithObject:model.cellSubTitle];
        cell.detailTextLabel.text = hasSubTitle?model.cellSubTitle:@"请选择认证类型";
        cell.textLabel.font = m_FontPF_Regular_WithSize(15);
        cell.textLabel.textColor = m_Color_gray(47);
        cell.detailTextLabel.textColor = hasSubTitle?cell.textLabel.textColor:m_Color_gray(153);
        cell.detailTextLabel.font = cell.textLabel.font;
        return cell;
        
    }else if ([model.cellClass isEqual:GWCertificationEditCell.class]){
        
        GWCertificationEditCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWCertificationEditCell.class)];
        cell.model = model;
        cell.textChangeBlcok = ^(NSString *text) {
            model.cellText = text;
        };
        return cell;
        
    }else if ([model.cellClass isEqual:GWCertificationImageCell.class]){
        
        GWCertificationImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(GWCertificationImageCell.class)];
        cell.model = model;
        cell.cellNeedReloadData = ^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
    
}

/**
 *  行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    GWCertificationUIModel *model = self.array[indexPath.section][indexPath.row];
    
    if ([model.cellClass isEqual:UITableViewCell.class]||[model.cellClass isEqual:GWCertificationEditCell.class]) {
        return 49;
    }else{
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:GWCertificationImageCell.class contentViewWidth:m_ScreenW];
    }
    
}

/**
 *  区头高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 11;
    }else if (section==1&&self.array.count>2){
        return 42;
    }else if (section==2){
        return 42;
    }
    
    return CGFLOAT_MIN;
    
}


/**
 *  区头View
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==1&&self.array.count>2) {
        
        GWCertificationSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(GWCertificationSectionHeaderView.class)];
        view.gw_title = @"个人信息";
        return view;
        
    }else if (section==2){
        
        GWCertificationSectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(GWCertificationSectionHeaderView.class)];
        view.gw_title = @"企业信息";
        return view;
        
    }
    
    return nil;
    
}

/**
 *  区尾高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 11;
    
}

#pragma mark - UITableViewDelegate

/**
 *  单元格点击
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    if (indexPath.section==0) {
        JGActionSheetSection *s1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"作者认证", @"媒体认证",@"企业认证"] buttonIcons:nil buttonStyle:JGActionSheetButtonStyleDefault];
        JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonIcons:nil buttonStyle:JGActionSheetButtonStyleCancel]]];
        sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
        sheet.outsidePressBlock = ^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        };
        @weakify(self);
        sheet.buttonPressedBlock = ^(JGActionSheet *actionSheet, NSIndexPath *indexPath) {
            [actionSheet dismissAnimated:YES];
            if (indexPath.section) return;
            [self_weak_.array removeAllObjects];
            switch (indexPath.row) {
                case 0:
                {
                    self_weak_.type = GWCertificationAuthor;
                }
                    break;
                case 1:
                {
                    self_weak_.type = GWCertificationMedia;
                }
                    break;
                case 2:
                {
                    self_weak_.type = GWCertificationEnterprise;
                }
                    break;
                    
                default:
                    break;
            }
            [self_weak_.tableView reloadData];
        };
        [sheet showInView:m_KeyWindow animated:YES];
    }
    

    
}

#pragma mark -- 懒加载

/**
 *    @brief    认证类型
 */
- (GWCertificationUIModel *)certificationTypeModle{

    if (!_certificationTypeModle) {
        _certificationTypeModle = [[GWCertificationUIModel alloc]init];
        _certificationTypeModle.cellClass = UITableViewCell.class;
        _certificationTypeModle.cellTitle = @"认证类型";
        _certificationTypeModle.cellHasArrow = YES;
        
    }
    switch (self.type) {
        case GWCertificationAuthor:
            _certificationTypeModle.cellSubTitle = @"作者认证";
            break;
        case GWCertificationMedia:
            _certificationTypeModle.cellSubTitle = @"媒体认证";
            break;
        case GWCertificationEnterprise:
            _certificationTypeModle.cellSubTitle = @"企业认证";
            break;
        default:
            break;
    }
    
    return _certificationTypeModle;
    
}

/**
 *    @brief    姓名
 */
- (GWCertificationUIModel *)nameModel{
    
    if (!_nameModel) {
        _nameModel = [[GWCertificationUIModel alloc]init];
        _nameModel.cellClass = GWCertificationEditCell.class;
        _nameModel.cellTitle = @"姓名";
        _nameModel.cellPlaceholder = @"请输入姓名";
    }
    return _nameModel;
    
}

/**
 *    @brief    身份证号
 */
- (GWCertificationUIModel *)IDCardModle{
    
    if (!_IDCardModle) {
        _IDCardModle = [[GWCertificationUIModel alloc]init];
        _IDCardModle.cellClass = GWCertificationEditCell.class;
        _IDCardModle.cellTitle = @"身份证号";
        _IDCardModle.cellPlaceholder = @"请输入身份证号";
        _IDCardModle.cellKeyboardType = UIKeyboardTypeASCIICapable;
    }
    return _IDCardModle;
    
}

/**
 *    @brief    手机号码
 */
- (GWCertificationUIModel *)mobileModle{
    
    if (!_mobileModle) {
        _mobileModle = [[GWCertificationUIModel alloc]init];
        _mobileModle.cellClass = GWCertificationEditCell.class;
        _mobileModle.cellTitle = @"手机号码";
        _mobileModle.cellPlaceholder = @"请输入手机号";
        _mobileModle.cellKeyboardType = UIKeyboardTypeNumberPad;
    }
    return _mobileModle;
    
}

/**
 *    @brief    邮箱
 */
- (GWCertificationUIModel *)emailModle{
    
    if (!_emailModle) {
        _emailModle = [[GWCertificationUIModel alloc]init];
        _emailModle.cellClass = GWCertificationEditCell.class;
        _emailModle.cellTitle = @"邮箱";
        _emailModle.cellPlaceholder = @"请输入邮箱";
        _emailModle.cellKeyboardType = UIKeyboardTypeEmailAddress;
    }
    return _emailModle;
    
}

/**
 *    @brief    证件照
 */
- (GWCertificationUIModel *)pictureModle{
    
    if (!_pictureModle) {
        _pictureModle = [[GWCertificationUIModel alloc]init];
        _pictureModle.cellClass = GWCertificationImageCell.class;
        _pictureModle.cellTitle = @"证件照";
        _pictureModle.placeholderImage = [UIImage imageNamed:@"camera_cell_icon"];
    }
    return _pictureModle;
    
}

/**
 *    @brief    企业名称
 */
- (GWCertificationUIModel *)enterpriseNameModle{
    
    if (!_enterpriseNameModle) {
        _enterpriseNameModle = [[GWCertificationUIModel alloc]init];
        _enterpriseNameModle.cellClass = GWCertificationEditCell.class;
        _enterpriseNameModle.cellTitle = @"企业名称";
        _enterpriseNameModle.cellPlaceholder = @"请输入企业名称";
    }
    return _enterpriseNameModle;
    
}

/**
 *    @brief    企业证件号码
 */
- (GWCertificationUIModel *)businessCertificateNumModle{
    
    if (!_businessCertificateNumModle) {
        _businessCertificateNumModle = [[GWCertificationUIModel alloc]init];
        _businessCertificateNumModle.cellClass = GWCertificationEditCell.class;
        _businessCertificateNumModle.cellTitle = @"企业证件号";
        _businessCertificateNumModle.cellPlaceholder = @"请输入企业证件号码";
        _businessCertificateNumModle.cellKeyboardType = UIKeyboardTypeASCIICapable;
    }
    return _businessCertificateNumModle;
    
}

/**
 *    @brief    营业执照
 */
- (GWCertificationUIModel *)businessCertificatepPictureModle{
    
    if (!_businessCertificatepPictureModle) {
        _businessCertificatepPictureModle = [[GWCertificationUIModel alloc]init];
        _businessCertificatepPictureModle.cellClass = GWCertificationImageCell.class;
        _businessCertificatepPictureModle.cellTitle = @"营业执照";
        _businessCertificatepPictureModle.placeholderImage = [UIImage imageNamed:@"camera_cell_icon"];
    }
    return _businessCertificatepPictureModle;
    
}

/**
 *    @brief    数据源
 */
- (NSMutableArray *)array{
    
    if (!_array) {
        
        _array = [NSMutableArray array];
        [_array addObject:@[
                            self.certificationTypeModle
                            ]];
        [_array addObject:@[
                            self.nameModel,
                            self.IDCardModle,
                            self.mobileModle,
                            self.emailModle,
                            self.pictureModle
                            ]];
        
    }
    
    if (!_array.count) {
        
        switch (self.type) {
            case GWCertificationAuthor://作者
            {
                [_array addObject:@[
                                    self.certificationTypeModle
                                    ]];
                [_array addObject:@[
                                    self.nameModel,
                                    self.IDCardModle,
                                    self.mobileModle,
                                    self.emailModle,
                                    self.pictureModle
                                    ]];

            }
                break;
            case GWCertificationMedia://媒体
            {
                [_array addObject:@[
                                    self.certificationTypeModle
                                    ]];
                [_array addObject:@[
                                    self.nameModel,
                                    self.IDCardModle,
                                    self.mobileModle,
                                    self.emailModle,
                                    self.pictureModle
                                    ]];

            }
                break;
            case GWCertificationEnterprise://企业
            {
                [_array addObject:@[
                                    self.certificationTypeModle
                                    ]];
                [_array addObject:@[
                                    self.nameModel,
                                    self.IDCardModle,
                                    self.mobileModle,
                                    self.emailModle,
                                    self.pictureModle
                                    ]];

                [_array addObject:@[
                                    self.enterpriseNameModle,
                                    self.businessCertificateNumModle,
                                    self.businessCertificatepPictureModle
                                    ]];

            }
                break;
                
            default:
                break;
        }
        
    }
    
    return _array;
    
}

- (void)gw_submitAudit{
    
    //获取信息集合
    if (!self.type) {
        m_ToastCenter(@"请选择认证类型")
        return;
    }
    
    //姓名
    NSString *userName = self.nameModel.cellText;
    m_CheckBlankField(userName, @"请填写姓名")
    //身份证号
    NSString *userIdCard = self.IDCardModle.cellText;
    m_CheckBlankField(userIdCard, @"请填写身份证号")
    m_CheckIdCodeField([userIdCard uppercaseString], @"请填写正确的身份证号")
    //手机号码
    NSString *userTel = self.mobileModle.cellText;
    m_CheckBlankField(userTel, @"请填写手机号")
    m_CheckMobileField(userTel, @"请填写正确的手机号")
    //邮箱
    NSString *userEmail = self.emailModle.cellText;
    m_CheckBlankField(userEmail, @"请填写邮箱")
    m_CheckEmailField(userEmail, @"请填写正确的邮箱")
    //证件照Url
    __block NSString *userCertificatesImage = nil;
    if (!self.pictureModle.cellImages.count) {
        m_ToastCenter(@"请选择证件照")
        return;
    }
    
    //企业名称
    NSString *enterpriseName = nil;
    
    //企业证件号
    NSString *enterpriseIdCard = nil;
    
    //营业执照Url
    __block NSString *enterpriseImage = nil;
    
    if (self.type==GWCertificationEnterprise) {
        
        //校验企业名称
        enterpriseName = self.enterpriseNameModle.cellText;
        m_CheckBlankField(enterpriseName, @"请填写企业名称")
        //校验企业证件号
        enterpriseIdCard = self.businessCertificateNumModle.cellText;
        m_CheckBlankField(enterpriseIdCard, @"请填写企业证件号");
        //校验营业执照
        if (!self.businessCertificatepPictureModle.cellImages.count) {
            m_ToastCenter(@"请选择营业执照")
            return;
        }
        
    }
    
    [self.navigationController.view showHudWithHint:nil];
    
    __block BOOL hasFailure = NO;

    dispatch_group_t serviceGroup = dispatch_group_create();
    
    //上传证件照
    dispatch_group_enter(serviceGroup);
    
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_fileUploadWithImage:self.pictureModle.cellImages.firstObject end:^(URLResponse *response) {
        dispatch_group_leave(serviceGroup);
    } success:^(URLResponse *response, id object) {
        userCertificatesImage = object;
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        hasFailure = YES;
    } netWorkError:^(NSError *error) {
        hasFailure = YES;
    }]];
    
    if (self.type==GWCertificationEnterprise) {
        //上传营业执照
        dispatch_group_enter(serviceGroup);
        
        [self.base_sessionTaskArray addObject:[URLRequestHelper api_fileUploadWithImage:self.businessCertificatepPictureModle.cellImages.firstObject end:^(URLResponse *response) {
            dispatch_group_leave(serviceGroup);
        } success:^(URLResponse *response, id object) {
            enterpriseImage = object;
        } failure:^(URLResponse *response, NSInteger code, NSString *message) {
            hasFailure = YES;
        } netWorkError:^(NSError *error) {
            hasFailure = YES;
        }]];
    }
    
    
    @weakify(self);
    
    /** 全部完成 */
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        if (hasFailure) {
            
            [self_weak_.navigationController.view hideHud];
            m_ToastCenter(@"上传图片信息失败")
            
        }else{
            
            //全部上传成功
            [self_weak_.base_sessionTaskArray addObject:[URLRequestHelper api_app_user_applyExamineWithUserType:self_weak_.type userName:userName userIdCard:[userIdCard uppercaseString] userTel:userTel userEmail:userEmail userCertificatesImage:userCertificatesImage enterpriseName:enterpriseName enterpriseIdCard:enterpriseIdCard enterpriseImage:enterpriseImage parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
                [self_weak_.navigationController.view hideHud];
            } success:^(URLResponse *response, id object) {
                GWSubmitSuccessVC *vc = [[GWSubmitSuccessVC alloc]init];
                vc.type = GWSubmitResultCertificationSuccess;
                [self_weak_.navigationController pushViewController:vc animated:YES];
            } failure:^(URLResponse *response, NSInteger code, NSString *message) {
                m_ToastCenter(message);
            } netWorkError:^(NSError *error) {
                m_ToastCenter(@"网络异常");
            }]];
            
        }
        
        NSLog(@"全部完成");
        NSLog(@"%@",@(hasFailure));
        
    });
    
}

@end
