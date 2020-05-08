//
//  UITextView+XMExtension.h
//  XMTextView
//
//  Created by XM on 2018/6/30.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (XMExtension)

@property(nonatomic,readonly)  UILabel *placeholdLabel;

@property(nonatomic,strong) IBInspectable NSString *placeholder;

@property(nonatomic,strong) IBInspectable UIColor *placeholderColor;

@property(nonnull,strong) NSAttributedString *attributePlaceholder;

@property(nonatomic,assign) CGPoint location;

+ (UIColor *)defaultColor;

@end
