//
//  DSNumberButton.m
//  DSProject
//
//  Created by ourslook on 2017/11/23.
//  Copyright © 2017年 ourslook. All rights reserved.
//

#import "DSNumberButton.h"

#define kTime 59

@interface DSNumberButton ()

/** 菊花转 */
@property (nonatomic, strong) UIActivityIndicatorView *activity;

/** 开始倒计时的时间戳 */
@property (nonatomic, assign) NSInteger ol_start;

@end

@implementation DSNumberButton

-(NSURLSessionTask*)ol_sendNumderCodeWithMobile:(NSString *)mobile type:(NSString *)type{
    
    [[UIViewController currentViewController].view endEditing:YES];

    [self show];

    @weakify(self);

    return [URLRequestHelper api_p_getMobileCodeWithType:type mobile:mobile parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        [self_weak_ dismiss];
    } success:^(URLResponse *response, id object) {
        m_ToastCenter(@"发送验证码成功");
        [self_weak_ openCountdown];
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        m_ToastCenter(message);
    } netWorkError:^(NSError *error) {
        m_ToastCenter(@"网络异常");
    }];

    return nil;
    
}

/** 显示菊花 */
-(void)show{

    [self.titleLabel removeFromSuperview];
    
    [self.activity startAnimating];
    
    [self addSubview:self.activity];

}

/** 隐藏菊花 */
-(void)dismiss{
    
    [self.activity stopAnimating];
    
    [self.activity removeFromSuperview];
    
    [self addSubview:self.titleLabel];
    
}

/** 开启倒计时 */
-(void)openCountdown{
    
    //记录开始的时间
    self.ol_start = [[NSDate date] utcTimeStamp];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        //获取当前的时间戳
        NSInteger nowTime = [[NSDate date] utcTimeStamp];
        
        
        
        NSInteger time = nowTime - self.ol_start;
        
        if(time >= kTime){ //倒计时结束，关闭
    
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self setTitle:@"重新获取" forState:UIControlStateNormal];
                [self setTitleColor:m_Color_RGB(242,105,62) forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = (kTime - time) % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self setTitle:[NSString stringWithFormat:@"(%.2d)重新获取", seconds] forState:UIControlStateNormal];
                [self setTitleColor:m_Color_gray(91) forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });

        }
    });
    dispatch_resume(_timer);
}

#pragma mark -- -- -- 懒加载
-(UIActivityIndicatorView *)activity{
    
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center = CGPointMake(self.ol_width/2, self.ol_height/2);
    }
    return _activity;
    
}

@end
