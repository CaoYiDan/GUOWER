//
//  VAWebViewController.h
//  GUOWER
//
//  Created by ourslook on 2018/7/20.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWBaseVC.h"

typedef  NS_ENUM(NSInteger,VAWebViewContentType){
    /** 链接地址 */
    VAWebViewContentURL = 0,
    /** 富文本 */
    VAWebViewContentHTMLString
};

@interface VAWebViewController : GWBaseVC

- (instancetype)initWithType:(VAWebViewContentType)type content:(NSString*)content;

@end
