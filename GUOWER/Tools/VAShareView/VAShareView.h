//
//  VAShareView.h
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VAShareModel.h"

typedef NS_ENUM(NSUInteger , VAShareContentType) {
    VAShareContentTypeText    = 1,               //文本分享
    VAShareContentTypeImage   = 2,               //图片分享
    VAShareContentTypeLink    = 3,               //链接分享
};

@interface VAShareView : UIView

/**
 分享视图弹窗

 @param shareModel 分享的数据
 @param shareContentType 分享类型
 */
-(void)showShareViewWithShareModel:(VAShareModel*)shareModel shareContentType:(VAShareContentType)shareContentType;

@end
