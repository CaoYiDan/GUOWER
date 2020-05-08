//
//  URLResponse.h
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLResponse : NSObject

/** 错误码 */
@property (nonatomic, assign) NSInteger code;

/** 异常信息补充 */
@property (nonatomic, strong) id exception;

/** 错误信息 */
@property (nonatomic, copy) NSString *msg;

/** 结果集 */
@property (nonatomic, strong) id object;

@end
