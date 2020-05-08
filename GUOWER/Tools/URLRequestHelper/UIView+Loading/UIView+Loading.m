//
//  UIView+Loading.m
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "UIView+Loading.h"
#import "JHUD.h"
#import <MBProgressHUD.h>
#import <objc/runtime.h>

@implementation UIView (Loading)

-(void)setOther_field:(NSString *)other_field{
    
    objc_setAssociatedObject(self, @selector(setOther_field:), other_field, OBJC_ASSOCIATION_COPY);
    
}

-(NSString *)other_field{
    
    return objc_getAssociatedObject(self, @selector(setOther_field:));
    
}

-(void)setOther_tag:(NSInteger)other_tag{
    
    NSNumber *ol_other_tag = [NSNumber numberWithInteger:other_tag];
    objc_setAssociatedObject(self, @selector(setOther_tag:), ol_other_tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSInteger)other_tag{
    
    return [objc_getAssociatedObject(self, @selector(setOther_tag:)) integerValue];
    
}

-(void)setHud_title:(NSString *)hud_title{
    
    objc_setAssociatedObject(self, @selector(setHud_title:), hud_title, OBJC_ASSOCIATION_COPY);
    
}

-(NSString *)hud_title{
    
    return objc_getAssociatedObject(self, @selector(setHud_title:));
    
}

-(void)setMask_title:(NSString *)mask_title{
    
    objc_setAssociatedObject(self, @selector(setMask_title:), mask_title, OBJC_ASSOCIATION_COPY);
    
}

-(NSString *)mask_title{
    
    return objc_getAssociatedObject(self, @selector(setMask_title:));
    
}

-(void)setMask_errorTitle:(NSString *)mask_errorTitle{
    
    objc_setAssociatedObject(self, @selector(setMask_errorTitle:), mask_errorTitle, OBJC_ASSOCIATION_COPY);
    
}

-(NSString *)mask_errorTitle{
    
    return objc_getAssociatedObject(self, @selector(setMask_errorTitle:));
    
}

-(void)setMask_errorImage:(UIImage *)mask_errorImage{
    
    objc_setAssociatedObject(self, @selector(setMask_errorImage:), mask_errorImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(UIImage *)mask_errorImage{
    
    return objc_getAssociatedObject(self, @selector(setMask_errorImage:));
    
}

-(void)setMask_refreshButtonTitle:(NSString *)mask_refreshButtonTitle{
    
    objc_setAssociatedObject(self, @selector(setMask_refreshButtonTitle:), mask_refreshButtonTitle, OBJC_ASSOCIATION_COPY);
    
}

-(NSString *)mask_refreshButtonTitle{
    
    return objc_getAssociatedObject(self, @selector(setMask_refreshButtonTitle:));
    
}

-(void)setMask_indicator:(BOOL)mask_indicator{
    
    NSNumber *ol_mask_indicator = [NSNumber numberWithBool:mask_indicator];
    objc_setAssociatedObject(self, @selector(setMask_indicator:), ol_mask_indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(BOOL)mask_indicator{
    
    NSNumber *indicator = objc_getAssociatedObject(self, @selector(setMask_indicator:));
    
    if (!indicator) {
        return YES;
    }
    return [indicator boolValue];
    
}

-(void)setHud_offsetX:(CGFloat)hud_offsetX{
    
    NSNumber *ol_hud_offsetX = [NSNumber numberWithFloat:hud_offsetX];
    objc_setAssociatedObject(self, @selector(setHud_offsetX:), ol_hud_offsetX, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(CGFloat)hud_offsetX{
    
    return [objc_getAssociatedObject(self, @selector(setHud_offsetX:)) floatValue];
    
}

-(void)setHud_offsetY:(CGFloat)hud_offsetY{
    
    NSNumber *ol_hud_offsetY = [NSNumber numberWithFloat:hud_offsetY];
    objc_setAssociatedObject(self, @selector(setHud_offsetY:), ol_hud_offsetY, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(CGFloat)hud_offsetY{
    
    return [objc_getAssociatedObject(self, @selector(setHud_offsetY:)) floatValue];
    
}

-(UIViewController *)parentController{
    
    return objc_getAssociatedObject(self, @selector(setParentController:));
    
}

-(void)setParentController:(UIViewController *)parentController{
    
    objc_setAssociatedObject(self, @selector(setParentController:), parentController, OBJC_ASSOCIATION_ASSIGN);
    
}

#pragma mark --- HUD

- (MBProgressHUD *)HUD{
    
    return objc_getAssociatedObject(self, @selector(setHUD:));
    
}

- (void)setHUD:(MBProgressHUD *)HUD{
    
    objc_setAssociatedObject(self, @selector(setHUD:), HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)showHudWithHint:(NSString *)hint{
    
    __weak typeof(self) self_weak_ = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self_weak_];
        HUD.xOffset = self_weak_.hud_offsetX;
        HUD.yOffset = self_weak_.hud_offsetY;
        HUD.opacity = 0.6;
        HUD.cornerRadius = 5;
        HUD.detailsLabelFont = m_FontPF_Regular_WithSize(15);
        HUD.detailsLabelText = !self_weak_.hud_title?(!hint.length?@"正在加载...":hint):self_weak_.hud_title;
        HUD.minSize = CGSizeMake(110, 110);
        HUD.color = [m_Color_gray(51) colorWithAlphaComponent:0.7];
        HUD.removeFromSuperViewOnHide = YES;
        
        if (hint.length||self_weak_.hud_title.length) {
            //利用label添加间距
            HUD.labelText = @" ";
            HUD.labelFont = [UIFont systemFontOfSize:5];
        }
        
        [self_weak_ addSubview:HUD];
        [HUD show:YES];
        [self_weak_ setHUD:HUD];
        
    });
    
}

- (void)hideHud{
    
    __weak typeof(self) self_weak_ = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[self_weak_ HUD] hide:NO];
        
    });
    
}

#pragma mark --- Mask

- (JHUD *)MASK{
    
    return objc_getAssociatedObject(self, @selector(setMASK:));
    
}

- (void)setMASK:(JHUD *)MASK{

    objc_setAssociatedObject(self, @selector(setMASK:), MASK, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void)showMaskWithHint:(NSString *)hint{
    
    //隐藏之前的Mask
    [self hideMask];
    CGRect frame = self.bounds;
    if (self.parentController) {
        //计算是否被导航条遮盖
        CGRect rect = [self convertRect:self.frame toView:self.parentController.navigationController.navigationBar];
        CGFloat navigationBarH = self.parentController.navigationController.navigationBar.frame.size.height;
        if (rect.origin.y<=navigationBarH) {//如果相对于导航条的位置小于导航条的高度，那就被遮盖了
            frame.origin.y += (navigationBarH-rect.origin.y);//进行向下偏移
            frame.size.height -= (navigationBarH-rect.origin.y);//进行高度缩减
        }
    }
    JHUD *mask = [[JHUD alloc]initWithFrame:frame];
    mask.messageLabel.text = !self.mask_title.length?(!hint.length?@"数据加载中...":hint):self.mask_title;
    mask.indicator = self.mask_indicator;
    if (self.mask_indicator) {
        mask.messageLabel.text = nil;
    }
    [mask showAtView:self hudType:JHUDLoadingTypeActivityIndicator];
    mask.backgroundColor = UIColor.whiteColor;
    [self setMASK:mask];
    
}

-(void)showErrorMaskWithHint:(NSString *)hint clickBlock:(void (^)(void))clickBlock{
    
    //隐藏之前的Mask
    [self hideMask];
    CGRect frame = self.bounds;
    if (self.parentController) {
        //计算是否被导航条遮盖
        CGRect rect = [self convertRect:self.frame toView:self.parentController.navigationController.navigationBar];
        CGFloat navigationBarH = self.parentController.navigationController.navigationBar.frame.size.height;
        if (rect.origin.y<=navigationBarH) {//如果相对于导航条的位置小于导航条的高度，那就被遮盖了
            frame.origin.y += (navigationBarH-rect.origin.y);//进行向下偏移
            frame.size.height -= (navigationBarH-rect.origin.y);//进行高度缩减
        }
    }
    JHUD *mask = [[JHUD alloc]initWithFrame:frame];
    mask.indicatorViewSize = CGSizeMake(111, 76.5);
    mask.messageLabel.text = !self.mask_errorTitle?(!hint.length?@"加载数据错误，刷新试试！":hint):self.mask_errorTitle;
    [mask.refreshButton setTitle:!self.mask_refreshButtonTitle.length?@"刷新":self.mask_refreshButtonTitle forState:UIControlStateNormal];
    mask.customImage = self.mask_errorImage?self.mask_errorImage:[UIImage imageNamed:@"network_error"];
    [mask showAtView:self hudType:JHUDLoadingTypeFailure];
    mask.backgroundColor = UIColor.whiteColor;
    [mask setJHUDReloadButtonClickedBlock:^{
        if (clickBlock) {
            clickBlock();
        }
    }];
    
    mask.refreshButton.cornerRadius_ol = 20;
    mask.refreshButton.masksToBounol_ol = YES;
    
    [self setMASK:mask];
    
}

-(void)hideMask{
    
    [JHUD hideForView:self];
    
}

@end
