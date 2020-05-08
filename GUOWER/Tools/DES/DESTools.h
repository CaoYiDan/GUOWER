//
// Created by 段大志 on 15/11/11.
// Copyright (c) 2015 ourslook. All rights reserved.
//

#import <Foundation/Foundation.h>

//DES加密,DES解密;DES算法;  IOS、java支持DES加密
//详见地址博客地址:http://blog.csdn.net/mengxiangyue/article/details/40015727
// 世茂项目中用了

static NSString* const ol_MASSAGE_KEY = @"mdi1f84h60gj68e3hdkgt74gg13``》《《《《*&&*****./,..,y";

static NSString* const ol_PASSWORD_KEY = @"DES_KEY_PASSWORD";


@interface DESTools : NSObject

+(NSString*)decryptUseDES:(NSString*)cipherText key:(NSString*)key;

+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString*)key;

+ (NSString *)getSha256String:(NSString *)srcString;

@end
