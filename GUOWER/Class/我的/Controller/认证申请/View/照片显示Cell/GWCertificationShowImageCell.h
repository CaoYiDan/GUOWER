//
//  GWCertificationShowImageCell.h
//  GUOWER
//
//  Created by ourslook on 2018/7/12.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWCertificationShowImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_imageView;

@property (weak, nonatomic) IBOutlet UIButton *gw_delBtn;

/** delBtnClick */
@property (nonatomic, copy) void(^delBtnClickBlock)(void);

@end
