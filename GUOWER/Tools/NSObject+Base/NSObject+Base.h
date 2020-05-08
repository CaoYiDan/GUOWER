//
//  NSObject+Disposable.h
//  DSProjectDriver
//
//  Created by ourslook on 2018/3/15.
//  Copyright © 2018年 vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Base)

/** 订阅者数组 该对象销毁时会取消数组内所有的订阅者 */
@property (nonatomic, strong) NSMutableArray <RACDisposable*> *base_disposableArray;

/** 存请求数组 该对象销毁时会取消数组内所有的请求 */
@property (nonatomic, strong) NSMutableArray <NSURLSessionTask*> *base_sessionTaskArray;

/** 获取类名 方便使用谓词而存在 */
@property (nonatomic, readonly) NSString *base_className;

@end
