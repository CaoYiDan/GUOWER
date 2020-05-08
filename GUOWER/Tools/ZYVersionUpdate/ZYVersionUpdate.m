//
//  ZYVersionUpdate.m
//  DeliverWater
//
//  Created by Vanne on 2017/6/20.
//  Copyright © 2017年 Vanne. All rights reserved.
//

#import "ZYVersionUpdate.h"
#import "AFNetworking.h"

@implementation ZYVersionUpdate

+(void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *, BOOL, NSString *))success failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSString *encodingUrl=[[@"https://itunes.apple.com/lookup?id=" stringByAppendingString:appID] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager GET:encodingUrl parameters:nil
        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",resultDic);
            NSArray *array = [resultDic objectForKey:@"results"];
            
            if (array.count) {
                
                NSString * versionStr =[[array objectAtIndex:0] valueForKey:@"version"] ;
                
                float version =[[versionStr stringByReplacingOccurrencesOfString:@"." withString:@""] floatValue];
                
                NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
                
                float currentVersion = [[[infoDic valueForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""] floatValue];
                
                if(version>currentVersion){
                    
                    success(resultDic, YES, versionStr);
                    
                }else{
                    
                    success(resultDic,NO ,versionStr);
                    
                }
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            failure(error);
            
        } ];
}

@end
