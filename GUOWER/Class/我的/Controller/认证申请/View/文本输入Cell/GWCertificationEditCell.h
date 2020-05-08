//
//  GWCertificationEditCell.h
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWCertificationUIModel;

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end

@interface GWCertificationEditCell : UITableViewCell

/** model */
@property (nonatomic, strong) GWCertificationUIModel *model;

/** 文本回调 */
@property (nonatomic, copy) void(^textChangeBlcok)(NSString*text);

@end
