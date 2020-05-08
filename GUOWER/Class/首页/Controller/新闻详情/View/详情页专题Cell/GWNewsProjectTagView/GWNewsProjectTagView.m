//
//  GWNewsProjectTagView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/5.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNewsProjectTagView.h"
#import "UIImage+ImageWithColor.h"

#define HORIZONTAL_PADDING 7.0f//水平间距
#define VERTICAL_PADDING   3.0f//纵向间距
#define LABEL_MARGIN       10.0f//标签内边距
#define BOTTOM_MARGIN      10.0f//底部间距

@interface GWNewsProjectTagView ()

/** 记录位置 */
@property (nonatomic, assign) CGRect previousFrame;

/** 记录高度 */
@property (nonatomic, assign) int totalHeight;

@end

@implementation GWNewsProjectTagView

-(void)setTagWithTagArray:(NSArray*)arr{
    
    self.previousFrame = CGRectZero;
    
    @weakify(self);
    
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        
        UIButton *tag = [UIButton buttonWithType:UIButtonTypeCustom];
        [tag setBackgroundImage:[UIImage imageWithColor:m_Color_gray(248.00)] forState:UIControlStateNormal];
        [tag setTitleColor:m_Color_gray(47.0) forState:UIControlStateNormal];
        [tag.titleLabel setFont:m_FontPF_Regular_WithSize(12)];
        [tag setTitle:str forState:UIControlStateNormal];
        tag.cornerRadius_ol = 13;
        tag.masksToBounol_ol = YES;
        NSDictionary *attrs = @{NSFontAttributeName : m_FontPF_Regular_WithSize(12)};
        CGSize string_size = [str sizeWithAttributes:attrs];
        
        [self_weak_.base_disposableArray addObject:[[tag rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (self_weak_.tagClickBlock) {
                self_weak_.tagClickBlock(idx);
            }
        }]];
        
        string_size.width += HORIZONTAL_PADDING*2;
        string_size.height = 26;
        CGRect newRect = CGRectZero;

        if (self_weak_.previousFrame.origin.x + self_weak_.previousFrame.size.width + string_size.width + LABEL_MARGIN > m_ScreenW) {
            newRect.origin = CGPointMake(10, self_weak_.previousFrame.origin.y + string_size.height + BOTTOM_MARGIN);
            self_weak_.totalHeight +=string_size.height + BOTTOM_MARGIN;
        }else {
            newRect.origin = CGPointMake(self_weak_.previousFrame.origin.x + self_weak_.previousFrame.size.width + LABEL_MARGIN, self_weak_.previousFrame.origin.y);
        }
        
        newRect.size = string_size;
        
        [self_weak_ addSubview:tag];
        
        [tag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(newRect.origin.x);
            make.top.mas_equalTo(newRect.origin.y);
            make.height.mas_equalTo(newRect.size.height);
            make.width.mas_equalTo(newRect.size.width);
        }];

        self_weak_.previousFrame = newRect;

        [self_weak_ mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self_weak_.totalHeight+string_size.height + BOTTOM_MARGIN);
        }];

    }];

}

@end
