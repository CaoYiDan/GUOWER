//
//  GWCRHeaderView.h
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWCRHeaderView : UITableViewHeaderFooterView

/** 申请状态 */
@property (nonatomic, assign) GWCertificationResultState state;

/** onceAgainClickBlock */
@property (nonatomic, copy) void(^onceAgainClickBlock)(void);

@end
