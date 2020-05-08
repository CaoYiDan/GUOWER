//
//  DSNumberButton.h
//  DSProject
//
//  Created by ourslook on 2017/11/23.
//  Copyright © 2017年 ourslook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSNumberButton : UIButton

/** 给指定手机发送验证码 */
-(NSURLSessionTask*)ol_sendNumderCodeWithMobile:(NSString *)mobile type:(NSString *)type;

@end
