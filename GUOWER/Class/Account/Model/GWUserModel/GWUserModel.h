//
//  GWUserModel.h
//  GUOWER
//
//  Created by ourslook on 2018/6/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWUserModel : NSObject

/** 创建时间 */
@property (nonatomic, copy) NSString *createDate;
/** 用户头像 */
@property (nonatomic, copy) NSString *headPortrait;
/** ID */
@property (nonatomic, strong) NSNumber *ID;
/** 文章数 */
@property (nonatomic, strong) NSNumber *newsNumber;
/** 昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 专栏作者排序值 */
@property (nonatomic, strong) NSNumber *pushOneSort;
/** 推送位置【1.专栏作者 2.企业专栏 3.作者排行】 */
@property (nonatomic, copy) NSString *pushPosition;
/** 作者排行排序值 */
@property (nonatomic, strong) NSNumber *pushThreeSort;
/** 企业专栏排序值 */
@property (nonatomic, strong) NSNumber *pushTwoSort;
/** 积分 */
@property (nonatomic, strong) NSNumber *score;
/** 性别【0.未知 1,男 2.女】 */
@property (nonatomic, strong) NSNumber *sex;
/** 个性签名 */
@property (nonatomic, copy) NSString *signature;
/** 状态 */
@property (nonatomic, strong) NSNumber *state;
/** 手机号 */
@property (nonatomic, copy) NSString *tel;
/** token */
@property (nonatomic, copy) NSString *token;
/** 总浏览量 */
@property (nonatomic, strong) NSNumber *totalBrowsing;
/** 用户等级【1.企业认证 2.作者认证 3.媒体认证】 */
@property (nonatomic, strong) NSNumber *userLevel;
/** 用户名 */
@property (nonatomic, copy) NSString *userName;
/** 暂留 */
@property (nonatomic, copy) NSString *userRemarks2;
/** 暂留 */
@property (nonatomic, copy) NSString *userRemarks3;
/** 用户类型【1.app 2.web】 */
@property (nonatomic, strong) NSNumber *userType;

@end
