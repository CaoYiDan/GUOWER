//
//  GWCertificationImageCell.h
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWCertificationUIModel;

@interface GWCertificationImageCell : UITableViewCell

/** model */
@property (nonatomic, strong) GWCertificationUIModel *model;

/** cellNeedReloadData */
@property (nonatomic, copy) void(^cellNeedReloadData)(void);

@end
