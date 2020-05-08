//
//  UIView+Extension.m
//  BMKitTest
//
//  Created by ourslook on 2017/11/16.
//  Copyright © 2017年 ourslook. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

//ol_x属性的get,set
-(void)setOl_x:(CGFloat)ol_x
{
    CGRect frame=self.frame;
    frame.origin.x=ol_x;
    self.frame=frame;
}
-(CGFloat)ol_x
{
    return self.frame.origin.x;
}
//ol_centerX属性的get,set
-(void)setOl_centerX:(CGFloat)ol_centerX
{
    CGPoint center=self.center;
    center.x=ol_centerX;
    self.center=center;
}
-(CGFloat)ol_centerX
{
    return self.center.x;
}
//ol_centerY属性的get,set
-(void)setOl_centerY:(CGFloat)ol_centerY
{
    CGPoint center=self.center;
    center.y=ol_centerY;
    self.center=center;
}
-(CGFloat)ol_centerY
{
    return self.center.y;
}
//ol_y属性的get,set
-(void)setOl_y:(CGFloat)ol_y
{
    CGRect frame=self.frame;
    frame.origin.y=ol_y;
    self.frame=frame;
}
-(CGFloat)ol_y
{
    return self.frame.origin.y;
}
//ol_width属性的get,set
-(void)setOl_width:(CGFloat)ol_width
{
    CGRect frame=self.frame;
    frame.size.width=ol_width;
    self.frame=frame;
}
-(CGFloat)ol_width
{
    return self.frame.size.width;
}
//ol_height属性的get,set
-(void)setOl_height:(CGFloat)ol_height
{
    CGRect frame = self.frame;
    frame.size.height=ol_height;
    self.frame=frame;
}
-(CGFloat)ol_height
{
    return self.frame.size.height;
}
//ol_size属性的get,set
-(void)setOl_size:(CGSize)ol_size
{
    CGRect frame=self.frame;
    frame.size.width=ol_size.width;
    frame.size.height=ol_size.height;
    self.frame=frame;
}
-(CGSize)ol_size
{
    return self.frame.size;
}
//ol_origin属性的get,set,用于设置坐标
-(void)setOl_origin:(CGPoint)ol_origin
{
    CGRect frame=self.frame;
    frame.origin.x=ol_origin.x;
    frame.origin.y=ol_origin.y;
    self.frame=frame;
}
-(CGPoint)ol_origin
{
    return self.frame.origin;
}

//xib设置圆角
-(void)setCornerRadius_ol:(CGFloat)cornerRadius_ol{
    
    self.layer.cornerRadius = cornerRadius_ol;
    
}

-(void)setMasksToBounol_ol:(BOOL)masksToBounol_ol{
    
    self.layer.masksToBounds = masksToBounol_ol;
    
}

-(CGFloat)cornerRadius_ol{
    
    return self.layer.cornerRadius;
    
}

-(BOOL)masksToBounol_ol{
    
    return self.layer.masksToBounds;
    
}

//xib设置边框

-(void)setBorderWidth_ol:(CGFloat)borderWidth_ol{
    
    self.layer.borderWidth = borderWidth_ol;
    
}

-(void)setBorderColor_ol:(UIColor *)borderColor_ol{
    
    self.layer.borderColor = borderColor_ol.CGColor;
    
}

-(CGFloat)borderWidth_ol{
    
    return self.layer.borderWidth;
    
}

-(UIColor *)borderColor_ol{
    
    return [UIColor colorWithCGColor:self.layer.borderColor];
    
}

//xib设置阴影

-(void)setShadowColor_ol:(UIColor *)shadowColor_ol{
    
    self.layer.shadowColor = shadowColor_ol.CGColor;
    
}

-(UIColor *)shadowColor_ol{
    
    return [UIColor colorWithCGColor:self.layer.shadowColor];
    
}

-(void)setShadowOpacity_ol:(CGFloat)shadowOpacity_ol{
    
    self.layer.shadowOpacity = shadowOpacity_ol;
    
}

-(CGFloat)shadowOpacity_ol{
    
    return self.layer.shadowOpacity;
    
}

-(void)setShadowOffset_ol:(CGSize)shadowOffset_ol{
    
    self.layer.shadowOffset = shadowOffset_ol;
    
}

-(CGSize)shadowOffset_ol{
    
    return self.layer.shadowOffset;
    
}

-(void)setShadowRadius_ol:(CGFloat)shadowRadius_ol{
    
    self.layer.shadowRadius = shadowRadius_ol;
    
}

-(CGFloat)shadowRadius_ol{
    
    return self.layer.shadowRadius;
    
}

-(void)ol_setShadowWithOpacity:(CGFloat)opacity color:(UIColor *)color radius:(CGFloat)radius offset:(CGSize)offset{

    self.shadowOpacity_ol = opacity;// 阴影透明度
    self.shadowColor_ol = color;// 阴影的颜色
    self.shadowRadius_ol = radius;// 阴影扩散的范围控制
    self.shadowOffset_ol = offset;// 阴影的范围
    
}

/**
 * lineView:       需要绘制成虚线的view
 * lineLength:     虚线的宽度
 * lineSpacing:    虚线的间距
 * lineColor:      虚线的颜色
 */
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
    
}

@end
