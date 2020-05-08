//
//  GWSubmitSuccessVC.h
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWBaseVC.h"

@interface GWSubmitSuccessVC : GWBaseVC

/** 提交结果类型 */
@property (nonatomic, assign) GWSubmitResultType type;

/** 错误Message */
@property (nonatomic, copy) NSString *message;

@end
