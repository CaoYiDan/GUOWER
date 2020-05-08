//
//  VAShareModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VAShareModel : NSObject
//分享标题 只分享文本是也用这个字段
@property (nonatomic,copy) NSString *title;
//描述内容
@property (nonatomic,copy) NSString *descr;
//分享数据 Image Url Model
@property (nonatomic,strong) id thumbImage;
//链接
@property (nonatomic,copy) NSString *url;

@end
