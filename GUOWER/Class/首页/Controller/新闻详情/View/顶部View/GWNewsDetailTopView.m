//
//  GWNewsDetailTopView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/4.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNewsDetailTopView.h"
//model
#import "GWNewsModel.h"

@interface GWNewsDetailTopView ()

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *gw_title;
/** 作者 */
@property (weak, nonatomic) IBOutlet ZYLoadingImageView *gw_image;
/** 作者名称 */
@property (weak, nonatomic) IBOutlet UILabel *gw_name;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *gw_time;
/** 浏览量 */
@property (weak, nonatomic) IBOutlet UIButton *gw_viewsNum;
/** 摘要 */
@property (weak, nonatomic) IBOutlet UILabel *gw_abstract;

@end

@implementation GWNewsDetailTopView

- (void)setModel:(GWNewsModel *)model{
    
    _model = model;
    self.gw_title.attributedText = [GWNewsDetailTopView titleWithModel:model];
    self.gw_image.ol_placeholder = [UIImage imageNamed:@"user_header"];
    self.gw_image.ol_data = model.authorHeadPortrait;
    self.gw_name.text = model.authorName;
    [self.gw_viewsNum setTitle:model.lookTimes.stringValue forState:UIControlStateNormal];
    
    self.gw_abstract.attributedText = [GWNewsDetailTopView descTextWithModel:model];

}

+ (CGFloat)titleHeightWithModel:(GWNewsModel*)model{
    
    return [self sizeLabelWidth:m_ScreenW - 30 attributedText:[self titleWithModel:model]].height + [self sizeLabelWidth:m_ScreenW - 30 attributedText:[self descTextWithModel:model]].height;
    
}

/** 获取标题 */
+ (NSAttributedString*)titleWithModel:(GWNewsModel*)model{
    
    //拿到整体的字符串
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:model.title attributes:@{NSFontAttributeName:m_FontPF_Medium_WithSize(21)}];
    
    //imageName
    NSString *imageName = nil;
    
    switch (model.tag.integerValue) {
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
        
        string = [[NSMutableAttributedString alloc] initWithString:[@" " stringByAppendingString:model.title] attributes:@{NSFontAttributeName:m_FontPF_Medium_WithSize(21)}];
        
        // 创建图片图片附件
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        
        attach.image = [UIImage imageNamed:imageName];
        
        CGRect bounds = CGRectMake(0, -2, 30, 18);
        
        if (m_IS_IPHONE_5) {
            bounds = CGRectMake(0, -1.7, 28, 16);
        }
        
        attach.bounds = bounds;
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        //将图片插入到合适的位置
        [string insertAttributedString:attachString atIndex:0];
        
    }
    
    return string;
    
}

/** 获取摘要 */
+ (NSAttributedString*)descTextWithModel:(GWNewsModel*)model{
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"摘要：" attributes:@{NSFontAttributeName:m_FontPF_Medium_WithSize(15)}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:![NSString ol_isNullOrNilWithObject:model.smallTitle]?model.smallTitle:@"无摘要。" attributes:@{NSFontAttributeName:m_FontPF_Regular_WithSize(15)}]];
    return string;
    
}

/** 计算富文本高度 */
+ (CGSize)sizeLabelWidth:(CGFloat)width attributedText:(NSAttributedString *)attributted{
    if(width<=0){
        return CGSizeZero;
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0, width, CGFLOAT_MAX)];
    lab.font = m_FontPF_Medium_WithSize(21);
    lab.attributedText = attributted;
    lab.numberOfLines = 0;
    
    CGSize labSize = [lab sizeThatFits:lab.bounds.size];
    return labSize;
}

/** 作者名称点击 */
- (IBAction)gw_nameMethod:(UIButton *)sender {
    
    if (self.nameClickBlock) {
        self.nameClickBlock();
    }
    
}

@end
