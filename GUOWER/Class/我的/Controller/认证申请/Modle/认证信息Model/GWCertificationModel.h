//
//  GWCertificationModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWCertificationModel : NSObject

/** 创建时间 */
@property (nonatomic, copy) NSString *createDate;
/** 企业证件号 */
@property (nonatomic, copy) NSString *enterpriseIdCard;
/** 营业执照 */
@property (nonatomic, copy) NSString *enterpriseImage;
/** 企业名称 */
@property (nonatomic, copy) NSString *enterpriseName;
/** 审核时间 */
@property (nonatomic, copy) NSString *examineDate;
/** 编号 */
@property (nonatomic, strong) NSNumber *ID;
/** 备注 */
@property (nonatomic, copy) NSString *remarks;
/** 审核结果【1.通过 0.审核中 2.未通过】3.未认证 */
@property (nonatomic, strong) NSNumber *result;
/** 审核人 */
@property (nonatomic, strong) NSNumber *sysUserId;
/** 审核人名称 */
@property (nonatomic, copy) NSString *sysUserName;
/** 证件照 */
@property (nonatomic, copy) NSString *userCertificatesImage;
/** 邮箱 */
@property (nonatomic, copy) NSString *userEmail;
/** 用户id */
@property (nonatomic, strong) NSNumber *userId;
/** 身份证号 */
@property (nonatomic, copy) NSString *userIdCard;
/** 真实姓名 */
@property (nonatomic, copy) NSString *userName;
/** 用户昵称 */
@property (nonatomic, copy) NSString *userNickName;
/** 手机号码 */
@property (nonatomic, copy) NSString *userTel;
/** 认证类型 */
@property (nonatomic, strong) NSNumber *userType;

@end
