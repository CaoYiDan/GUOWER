//
//  GWCertificationUIModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWCertificationUIModel : NSObject

/** cell类 */
@property (nonatomic, assign) Class cellClass;

/** 主题文字 */
@property (nonatomic, copy) NSString *cellTitle;

/** 箭头左侧的文字 */
@property (nonatomic, copy) NSString *cellSubTitle;

/** 是否有箭头 */
@property (nonatomic, assign) BOOL cellHasArrow;

/** 占位文字 */
@property (nonatomic, copy) NSString *cellPlaceholder;

/** 输入的文本 */
@property (nonatomic, copy) NSString *cellText;

/** 文本框键盘类型 */
@property (nonatomic, assign) UIKeyboardType cellKeyboardType;

/** 占位图片 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 证件照 */
@property (nonatomic, strong) NSMutableArray *cellImages;

/** 证件媒体资源 */
@property (nonatomic, strong) NSMutableArray *cellAssets;

@end
