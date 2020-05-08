//
//  GWNewsModel.m
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNewsModel.h"

@implementation GWNewsModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
    
}

- (BOOL)isGw_bigImage{
    
    return ![NSString ol_isNullOrNilWithObject:self.image];
    
}

/**
 *    @brief    获取对应标题
 *
 *    @param     lineSpacing     是否有行间距
 *    @param     isBig     是否显示大图标
 */
- (NSMutableAttributedString*)titleWithLineSpacing:(BOOL)lineSpacing isBig:(BOOL)isBig{
 
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (lineSpacing) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 13;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    
    //拿到整体的字符串
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.title attributes:attributes];
    
    //imageName
    NSString *imageName = nil;

    switch (self.tag.integerValue) {
        case GWNewsTitleIconTypeHot:
        {
            imageName = @"hot_icon";
        }
            break;
        case GWNewsTitleIconTypeNew:
        {
            imageName = @"new_icon";
        }
            break;
        default:
            break;
    }

    if (![NSString ol_isNullOrNilWithObject:imageName]) {//需要设置图片

        string = [[NSMutableAttributedString alloc] initWithString:[@" " stringByAppendingString:self.title] attributes:attributes];

        // 创建图片图片附件
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:imageName];

        CGRect bounds = CGRectMake(0, -2, 25, 15);

        if (m_IS_IPHONE_5) {
            bounds = CGRectMake(0, -1.7, 22, 14);
        }

        if (isBig) {

            bounds = CGRectMake(0, -2, 30, 18);

            if (m_IS_IPHONE_5) {
                bounds = CGRectMake(0, -1.7, 28, 16);
            }

        }
        
        attach.bounds = bounds;
        
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];

        //将图片插入到合适的位置
        [string insertAttributedString:attachString atIndex:0];
    }
    
    return string;
    
}

@end
