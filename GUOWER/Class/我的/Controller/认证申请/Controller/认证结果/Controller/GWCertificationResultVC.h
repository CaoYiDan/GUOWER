//
//  GWCertificationResultVC.h
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWBaseTableVC.h"

@class GWCertificationModel;

@interface GWCertificationResultVC : GWBaseTableVC

/** 认证信息 */
@property (nonatomic, strong) GWCertificationModel *resultModel;

@end
