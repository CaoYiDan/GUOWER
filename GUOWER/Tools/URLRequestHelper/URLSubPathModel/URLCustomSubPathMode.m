//
//  URLCustomSubPathMode.m
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "URLCustomSubPathMode.h"
#import <objc/runtime.h>
#import "NSString+URLSubPath.h"

//内涵简写及替换"_"为"/"的方法
#import "URLRequestHelper_Abbrev.h"

@implementation URLCustomSubPathMode

/**
 *  单例
 */
+ (instancetype)sharedCustom
{
    static URLCustomSubPathMode *selfClass = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selfClass = [[URLCustomSubPathMode alloc] init];
    });
    
    return selfClass;
}

kStringURLSubPathCoding(API_BASE_URL)

@end
