//
//  UIView+Extension.h
//  BMKitTest
//
//  Created by ourslook on 2017/11/16.
//  Copyright © 2017年 ourslook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)


//x坐标属性
@property (nonatomic,assign)CGFloat ol_x;
//y坐标
@property (nonatomic,assign)CGFloat ol_y;
//宽度
@property (nonatomic,assign)CGFloat ol_width;
//高度
@property (nonatomic,assign)CGFloat ol_height;
//大小
@property (nonatomic,assign)CGSize ol_size;
//位置
@property (nonatomic,assign)CGPoint ol_origin;
//中心点x
@property (nonatomic,assign)CGFloat ol_centerX;
//中心点y
@property (nonatomic,assign)CGFloat ol_centerY;


//xib设置圆角
@property (nonatomic,assign) IBInspectable CGFloat   cornerRadius_ol;
@property (nonatomic,assign) IBInspectable BOOL  masksToBounol_ol;

//xib设置边框
@property (nonatomic,assign) IBInspectable CGFloat   borderWidth_ol;
@property (nonatomic,assign) IBInspectable UIColor  *borderColor_ol;

//xib设置阴影
@property (nonatomic,assign) IBInspectable CGFloat   shadowOpacity_ol;
@property (nonatomic,assign) IBInspectable UIColor  *shadowColor_ol;
@property (nonatomic,assign) IBInspectable CGFloat   shadowRadius_ol;
@property (nonatomic,assign) IBInspectable CGSize   shadowOffset_ol;

//设置阴影
-(void)ol_setShadowWithOpacity:(CGFloat)opacity color:(UIColor*)color radius:(CGFloat)radius offset:(CGSize)offset;

/**
 * lineView:       需要绘制成虚线的view
 * lineLength:     虚线的宽度
 * lineSpacing:    虚线的间距
 * lineColor:      虚线的颜色
 */
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
