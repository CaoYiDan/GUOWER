//
//  VAShareButton.m
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "VAShareButton.h"

@implementation VAShareButton
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = m_FontPF_Regular_WithSize(12);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {

    CGRect retValue = CGRectMake(0,self.frame.size.height-12,contentRect.size.width,12);
    return retValue;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect retValue = CGRectMake(0,0,45,45);
    return retValue;
}
@end
