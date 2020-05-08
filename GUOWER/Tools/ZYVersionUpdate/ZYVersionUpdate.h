//
//  ZYVersionUpdate.h
//  DeliverWater
//
//  Created by Vanne on 2017/6/20.
//  Copyright © 2017年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYVersionUpdate : NSObject

/**
 *  检测版本更新
 *
 *  @param appID   APPID
 *  @param success 成功的Block
 *  @param failure 失败的Block
 */
+ (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion , NSString * newVersion))success failure:(void (^)(NSError *error))failure;

@end
