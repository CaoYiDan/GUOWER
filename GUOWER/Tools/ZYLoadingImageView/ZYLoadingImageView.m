//
//  ZYLoadingImageView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/4.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "ZYLoadingImageView.h"
#import <AFNetworkReachabilityManager.h>

@interface ZYLoadingImageView ()

/** loading */
@property (nonatomic, strong) UIActivityIndicatorView *ol_activity;

/** errorButton */
@property (nonatomic, strong) UIButton *ol_errorButton;

@end

@implementation ZYLoadingImageView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupView];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
        
    }
    return self;
    
}

- (void)setupView{
    
    //默认显示错误重载按钮
    self.ol_showErrorButton = YES;
    //开启交互
    self.userInteractionEnabled = YES;
    //设置默认背景颜色
    self.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    //初始化loading
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    activity.color = UIColor.lightGrayColor;
    self.ol_activity = activity;
    [self addSubview:activity];
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];
    
    //初始化错误按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"图片加载失败，点击重试" forState:UIControlStateNormal];
    [button.titleLabel setFont:m_FontPF_Regular_WithSize(14)];
    [button setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    self.ol_errorButton = button;
    button.hidden = YES;
    button.userInteractionEnabled = NO;
    [self addSubview:button];
    [button sizeToFit];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    @weakify(self);
    [self.base_disposableArray addObject:[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self_weak_ setOl_data:self_weak_.ol_data];
    }]];
    
//    [self.base_disposableArray addObject:[[[NSNotificationCenter defaultCenter] rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        [self_weak_ setOl_data:self_weak_.ol_data];
//    }]];
    
//    self.ol_data = [NSURL URLWithString:@"https://desk-fd.zol-img.com.cn/t_s1920x1200c5/g5/M00/00/00/ChMkJlZpOb2IHo0OABUHAP4IJlIAAF_OgOxYlcAFQcY937.jpg"];
    
}

/**
 *    @brief    设置图片数据
 *
 */
- (void)setOl_data:(id)ol_data{

    _ol_data = ol_data;
    
    if ([ol_data isKindOfClass:NSURL.class]) {
        
        NSURL *url = ol_data;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        self.contentMode = UIViewContentModeScaleToFill;
        self.ol_errorButton.hidden = YES;
        self.ol_errorButton.userInteractionEnabled = NO;
        
        @weakify(self);
        //查看缓存
        [manager cachedImageExistsForURL:url completion:^(BOOL isInCache) {
            
            if (isInCache) {
                
                super.image = [manager.imageCache imageFromCacheForKey:[manager cacheKeyForURL:url]];
                
            }else{
                //开启加载Loading
                [self_weak_.ol_activity startAnimating];
                [self_weak_ sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    [self_weak_.ol_activity stopAnimating];
                    
                    if (error) {//加载错误
                        
                        if (self_weak_.ol_showErrorButton&&[self_weak_.ol_errorButton.currentTitle va_calculatedTextMaxHeightWithMaxWidth:CGFLOAT_MAX font:self_weak_.ol_errorButton.titleLabel.font].width < self_weak_.ol_width) {//显示错误按钮
                            
                            self_weak_.ol_errorButton.hidden = NO;
                            self_weak_.ol_errorButton.userInteractionEnabled = YES;
                            
                        }else{
                            if (self_weak_.ol_placeholder) {
                                super.image = self_weak_.ol_placeholder;
                            }else{
                                self_weak_.contentMode = UIViewContentModeCenter;
                                super.image = [UIImage imageNamed:@"image_broken"];
                            }
                            
                            
                        }
                        
                    }
                    
                }];
            }
            
        }];
        
    }else if ([ol_data isKindOfClass:NSString.class]){
        self.ol_data = [NSURL URLWithString:ol_data];
    }else if ([ol_data isKindOfClass:UIImage.class]){
        self.ol_errorButton.hidden = YES;
        self.ol_errorButton.userInteractionEnabled = NO;
        self.contentMode = UIViewContentModeScaleToFill;
        super.image = ol_data;
    }else{
        if (self.ol_placeholder) {
            self.contentMode = UIViewContentModeScaleToFill;
            super.image = self.ol_placeholder;
        }else{
            self.contentMode = UIViewContentModeCenter;
            super.image = [UIImage imageNamed:@"image_broken"];
        }
    }
    
}

@end
