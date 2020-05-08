//
//  URLCommonSubPathMode.m
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "URLCommonSubPathMode.h"
#import <objc/runtime.h>

//内涵简写及替换"_"为"/"的方法
#import "URLRequestHelper_Abbrev.h"

@implementation URLCommonSubPathMode

/**
 *  单例
 */
+ (instancetype)sharedCommon
{
    static URLCommonSubPathMode *selfClass = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selfClass = [[URLCommonSubPathMode alloc] init];
    });
    
    return selfClass;
}

+(void)load{
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(self, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];SEL original = NSSelectorFromString(name);
        Method originalM = class_getInstanceMethod([self class], original);
        IMP current = method_getImplementation(class_getInstanceMethod([self class], @selector(ol_subPath)));
        method_setImplementation(originalM, current);
        
    }
    
}

-(NSString*)ol_subPath{
    
    NSString *methodString = [@"_" stringByAppendingString:NSStringFromSelector(_cmd)];
    NSString *newString = [methodString stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    Ivar iVar =  class_getInstanceVariable(self.class, [methodString UTF8String]);
    object_setIvar(self, iVar, newString);
    return [(API_BASE_URL) stringByAppendingString:object_getIvar(self, iVar)];
    
}
//kStringURLSubPathCoding(API_BASE_URL)

@end
