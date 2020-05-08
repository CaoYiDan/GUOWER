//
//  GWCertificationResultVC.m
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCertificationResultVC.h"
#import <SDAutoLayout.h>
//header
#import "GWCRHeaderView.h"
//model
#import "GWCertificationUIModel.h"
//cells
#import "GWCertificationImageCell.h"
//certification
#import "GWCertificationVC.h"
//certificationModel
#import "GWCertificationModel.h"

@interface GWCertificationResultVC ()

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
@property (nonatomic, strong) NSMutableArray <GWCertificationUIModel*> *array;

@end

@implementation GWCertificationResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请认证";
    
    [self setupTableView];
    
}

- (void)setupTableView{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:GWCRHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(GWCRHeaderView.class)];
    [self.tableView registerClass:GWCertificationImageCell.class forCellReuseIdentifier:NSStringFromClass(GWCertificationImageCell.class)];
    
}

/**
 *  行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.array.count;
}

/**
 *  单元格方法
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GWCertificationUIModel *model = self.array[indexPath.row];
    
    if ([model.cellClass isEqual:UITableViewCell.class]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(self.class)];
        }
        cell.accessoryView = model.cellHasArrow?[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_arrow"]]:nil;
        cell.textLabel.text = model.cellTitle;
        cell.detailTextLabel.text = model.cellSubTitle;
        cell.textLabel.font = m_FontPF_Regular_WithSize(15);
        cell.textLabel.textColor = m_Color_gray(47);
        cell.detailTextLabel.textColor = cell.textLabel.textColor;
        cell.detailTextLabel.font = cell.textLabel.font;
        [[cell.contentView viewWithTag:9] removeFromSuperview];
        UIView *line = [[UIView alloc]init];
        line.tag = 9;
        line.backgroundColor = m_Color_gray(229);
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-0.5);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
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
    
    GWCertificationUIModel *model = self.array[indexPath.row];
    
    if ([model.cellClass isEqual:UITableViewCell.class]) {
        return 49;
    }else{
        return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:GWCertificationImageCell.class contentViewWidth:m_ScreenW];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    GWCRHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(GWCRHeaderView.class)];
    view.state = self.resultModel.result.integerValue;
    @weakify(self);
    view.onceAgainClickBlock = ^{
        GWCertificationVC *vc = [[GWCertificationVC alloc]init];
        [self_weak_.navigationController pushViewController:vc animated:YES];
    };
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 129;
    
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
        
        switch (self.resultModel.userType.integerValue) {
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
    }
    
    return _certificationTypeModle;
    
}

/**
 *    @brief    姓名
 */
- (GWCertificationUIModel *)nameModel{
    
    if (!_nameModel) {
        _nameModel = [[GWCertificationUIModel alloc]init];
        _nameModel.cellClass = UITableViewCell.class;
        _nameModel.cellTitle = @"姓名";
        _nameModel.cellSubTitle = self.resultModel.userName;
    }
    return _nameModel;
    
}

/**
 *    @brief    身份证号
 */
- (GWCertificationUIModel *)IDCardModle{
    
    if (!_IDCardModle) {
        _IDCardModle = [[GWCertificationUIModel alloc]init];
        _IDCardModle.cellClass = UITableViewCell.class;
        _IDCardModle.cellTitle = @"身份证号";
        _IDCardModle.cellSubTitle = self.resultModel.userIdCard;
    }
    return _IDCardModle;
    
}

/**
 *    @brief    手机号码
 */
- (GWCertificationUIModel *)mobileModle{
    
    if (!_mobileModle) {
        _mobileModle = [[GWCertificationUIModel alloc]init];
        _mobileModle.cellClass = UITableViewCell.class;
        _mobileModle.cellTitle = @"手机号码";
        _mobileModle.cellSubTitle = self.resultModel.userTel;
    }
    return _mobileModle;
    
}

/**
 *    @brief    邮箱
 */
- (GWCertificationUIModel *)emailModle{
    
    if (!_emailModle) {
        _emailModle = [[GWCertificationUIModel alloc]init];
        _emailModle.cellClass = UITableViewCell.class;
        _emailModle.cellTitle = @"邮箱";
        _emailModle.cellSubTitle = self.resultModel.userEmail;
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
        [_pictureModle.cellImages addObject:self.resultModel.userCertificatesImage];
    }
    return _pictureModle;
    
}

/**
 *    @brief    企业名称
 */
- (GWCertificationUIModel *)enterpriseNameModle{
    
    if (!_enterpriseNameModle) {
        _enterpriseNameModle = [[GWCertificationUIModel alloc]init];
        _enterpriseNameModle.cellClass = UITableViewCell.class;
        _enterpriseNameModle.cellTitle = @"企业名称";
        _enterpriseNameModle.cellSubTitle = self.resultModel.enterpriseName;
    }
    return _enterpriseNameModle;
    
}

/**
 *    @brief    企业证件号码
 */
- (GWCertificationUIModel *)businessCertificateNumModle{
    
    if (!_businessCertificateNumModle) {
        _businessCertificateNumModle = [[GWCertificationUIModel alloc]init];
        _businessCertificateNumModle.cellClass = UITableViewCell.class;
        _businessCertificateNumModle.cellTitle = @"企业证件号";
        _businessCertificateNumModle.cellSubTitle = self.resultModel.enterpriseIdCard;
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
        [_businessCertificatepPictureModle.cellImages addObject:self.resultModel.enterpriseImage];
    }
    
    return _businessCertificatepPictureModle;
    
}

/**
 *    @brief    数据源
 */
- (NSMutableArray *)array{
    
    if (!_array) {
        
        _array = [NSMutableArray array];
        
        switch (self.resultModel.userType.integerValue) {
            case GWCertificationAuthor:
                [_array addObjectsFromArray:@[
                                              self.certificationTypeModle,
                                              self.nameModel,
                                              self.IDCardModle,
                                              self.mobileModle,
                                              self.emailModle,
                                              self.pictureModle,
                                              ]];
                break;
            case GWCertificationMedia:
                [_array addObjectsFromArray:@[
                                              self.certificationTypeModle,
                                              self.nameModel,
                                              self.IDCardModle,
                                              self.mobileModle,
                                              self.emailModle,
                                              self.pictureModle,
                                              ]];
                break;
            case GWCertificationEnterprise:
                [_array addObjectsFromArray:@[
                                              self.certificationTypeModle,
                                              self.nameModel,
                                              self.IDCardModle,
                                              self.mobileModle,
                                              self.emailModle,
                                              self.pictureModle,
                                              self.enterpriseNameModle,
                                              self.businessCertificateNumModle,
                                              self.businessCertificatepPictureModle
                                              ]];
                break;
            default:
                break;
        }
        
    }
    
    return _array;
    
}

@end
