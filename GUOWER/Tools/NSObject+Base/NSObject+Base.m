//
//  NSObject+Disposable.m
//  DSProjectDriver
//
//  Created by ourslook on 2018/3/15.
//  Copyright © 2018年 vanne. All rights reserved.
//

#import "NSObject+Base.h"
#import <objc/runtime.h>

static NSMutableArray *_array = nil;

@implementation NSObject (Base)

+(void)load{
    
    _array = [NSMutableArray array];
    
    //销毁方法
    SEL dealloc = NSSelectorFromString(@"dealloc");
    SEL base_dealloc = @selector(base_dealloc);
    Method deallocMethod = class_getInstanceMethod(self, dealloc);
    Method base_deallocMethod = class_getInstanceMethod(self, base_dealloc);
    method_exchangeImplementations(deallocMethod, base_deallocMethod);
    
    //初始化方法
    SEL init = @selector(init);
    SEL base_init = @selector(base_init);
    Method initMethod = class_getInstanceMethod(self, init);
    Method base_initMethod = class_getInstanceMethod(self, base_init);
    method_exchangeImplementations(initMethod, base_initMethod);
    
}

-(NSMutableArray<RACDisposable *> *)base_disposableArray{
    
    return objc_getAssociatedObject(self, @selector(setBase_disposableArray:));
    
}

-(void)setBase_disposableArray:(NSMutableArray<RACDisposable *> *)base_disposableArray{
    
    objc_setAssociatedObject(self, @selector(setBase_disposableArray:), base_disposableArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSMutableArray<NSURLSessionTask *> *)base_sessionTaskArray{
    
    return objc_getAssociatedObject(self, @selector(setBase_sessionTaskArray:));
    
}

-(void)setBase_sessionTaskArray:(NSMutableArray<NSURLSessionTask *> *)base_sessionTaskArray{
    
    objc_setAssociatedObject(self, @selector(setBase_sessionTaskArray:), base_sessionTaskArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (instancetype)base_init{

    self.base_disposableArray = [NSMutableArray arrayWithArray:_array];

    self.base_sessionTaskArray = [NSMutableArray arrayWithArray:_array];
    
   return [self base_init];
    
}

-(void)base_dealloc{
    
    [self.base_disposableArray makeObjectsPerformSelector:@selector(dispose)];
    
    [self.base_sessionTaskArray makeObjectsPerformSelector:@selector(cancel)];
    
    [self base_dealloc];
    
    
    
}

- (NSString *)base_className{

    return NSStringFromClass(self.class);

}

@end
