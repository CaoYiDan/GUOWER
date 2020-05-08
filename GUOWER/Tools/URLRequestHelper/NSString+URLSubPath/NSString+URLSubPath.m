//
//  NSString+URLSubPath.m
//  OURSLOOK_Network
//
//  Created by ourslook on 2018/4/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "NSString+URLSubPath.h"
#import <PPNetworkHelper.h>
#import "UIView+Loading.h"
#import <MJExtension.h>
#import "URLResponse.h"
#import <AFNetworking.h>

@implementation NSString (URLSubPath)

-(NSURLSessionTask *)post_parameters:(id)parameters hasCache:(BOOL)hasCache parentView:(UIView *)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError{
    
    return [self requestsWithUrl:self post:YES hasCache:hasCache parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
    
}

-(NSURLSessionTask *)get_parameters:(id)parameters hasCache:(BOOL)hasCache parentView:(UIView *)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError{
    
    return [self requestsWithUrl:self post:NO hasCache:hasCache parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
    
}

-(NSURLSessionTask*)put_parameters:(id)parameters parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError{
    
    return [self put_delete_requestsWithUrl:self put:YES parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
    
}


-(NSURLSessionTask*)delete_parameters:(id)parameters parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError{
    
    return [self put_delete_requestsWithUrl:self put:NO parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
    
}

/**
 *    @brief    总体格式化请求 ~ 所有GET POST请求必经的方法
 *
 *    @param     url     地址
 *    @param     post     是否是POST请求
 *    @param     hasCache     是否有缓存
 *    @param     parameters     参数
 *    @param     parentView     需要显示HUD或者Mask的View
 *    @param     hasHud     是否有HUD
 *    @param     hasMask     是否有全屏Mask
 *    @param     success     成功回调
 *    @param     failure     失败回调
 *    @param     netWorkError   网络异常
 *
 *    @return    会话
 */
-(NSURLSessionTask *)requestsWithUrl:(NSString*)url post:(BOOL)post hasCache:(BOOL)hasCache parameters:(id)parameters parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError{
    
    if (hasHud) {//拥有HUD
        [parentView showHudWithHint:nil];
    }
    if (hasMask) {//拥有全屏蒙板
        [parentView showMaskWithHint:nil];
    }
    
    if (![NSString ol_isNullOrNilWithObject:AccountMannger_userInfo.token]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dict setObject:AccountMannger_userInfo.token forKey:@"token"];
        parameters = dict;
    }
    
    __weak typeof(self) self_weak_ = self;
    
    return post?({
    
        //post
        hasCache?({//有缓存
            [PPNetworkHelper POST:url parameters:parameters responseCache:^(id responseCache) {
                
                [self_weak_ processingResultsWithData:responseCache parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                
            } success:^(id responseObject) {
                
                [self_weak_ processingResultsWithData:responseObject parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                
            } failure:^(NSError *error) {
                if (end) {//请求执行完毕
                    end(nil);
                }
                if (hasHud) {//隐藏HUD
                    [parentView hideHud];
                }
                if (hasMask) {//显示为错误界面
                    [parentView showErrorMaskWithHint:nil clickBlock:^{
                        [self_weak_ requestsWithUrl:url post:post hasCache:hasCache parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                    }];
                }
                if (netWorkError) {//网络异常
                    if (error.code != NSURLErrorCancelled){
                        netWorkError(error);
                    }
                }
                
            }];
        }):({//无缓存
            
            [PPNetworkHelper POST:url parameters:parameters success:^(id responseObject) {
                
                [self_weak_ processingResultsWithData:responseObject parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                
            } failure:^(NSError *error) {
                if (end) {//请求执行完毕
                    end(nil);
                }
                if (hasHud) {//隐藏HUD
                    [parentView hideHud];
                }
                if (hasMask) {//显示为错误界面
                    [parentView showErrorMaskWithHint:nil clickBlock:^{
                        [self_weak_ requestsWithUrl:url post:post hasCache:hasCache parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                    }];
                }
                if (netWorkError) {//网络异常
                    if (error.code != NSURLErrorCancelled){
                        netWorkError(error);
                    }
                }
                
            }];
            
        });
        
    }):({
        
        //GET
        hasCache?({//有缓存
            [PPNetworkHelper GET:url parameters:parameters responseCache:^(id responseCache) {
                
                [self_weak_ processingResultsWithData:responseCache parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                
            } success:^(id responseObject) {
                
                [self_weak_ processingResultsWithData:responseObject parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                
            } failure:^(NSError *error) {
                if (end) {//请求执行完毕
                    end(nil);
                }
                if (hasHud) {//隐藏HUD
                    [parentView hideHud];
                }
                if (hasMask) {//显示为错误界面
                    [parentView showErrorMaskWithHint:nil clickBlock:^{
                        [self_weak_ requestsWithUrl:url post:post hasCache:hasCache parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                    }];
                }
                if (netWorkError) {//网络异常
                    if (error.code != NSURLErrorCancelled){
                        netWorkError(error);
                    }
                }
                
            }];
        }):({//无缓存
            
            [PPNetworkHelper GET:url parameters:parameters success:^(id responseObject) {
                
                [self_weak_ processingResultsWithData:responseObject parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                
            } failure:^(NSError *error) {
                if (end) {//请求执行完毕
                    end(nil);
                }
                if (hasHud) {//隐藏HUD
                    [parentView hideHud];
                }
                if (hasMask) {//显示为错误界面
                    [parentView showErrorMaskWithHint:nil clickBlock:^{
                        [self_weak_ requestsWithUrl:url post:post hasCache:hasCache parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                    }];
                }
                
                if (netWorkError) {//网络异常
                    if (error.code != NSURLErrorCancelled){
                        netWorkError(error);
                    }
                }
                
            }];
            
        });
        
    });
    
}

/**
 *    @brief    总体格式化请求 ~ 所有PUT DELETE请求必经的方法
 *
 *    @param     url     地址
 *    @param     put     是否是PUT请求
 *    @param     parameters     参数
 *    @param     parentView     需要显示HUD或者Mask的View
 *    @param     hasHud     是否有HUD
 *    @param     hasMask     是否有全屏Mask
 *    @param     success     成功回调
 *    @param     failure     失败回调
 *    @param     netWorkError   网络异常
 *
 *    @return    会话
 */
-(NSURLSessionTask *)put_delete_requestsWithUrl:(NSString*)url put:(BOOL)put parameters:(id)parameters parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError{
    
    if (hasHud) {//拥有HUD
        [parentView showHudWithHint:nil];
    }
    if (hasMask) {//拥有全屏蒙板
        [parentView showMaskWithHint:nil];
    }
    
    if (![NSString ol_isNullOrNilWithObject:AccountMannger_userInfo.token]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dict setObject:AccountMannger_userInfo.token forKey:@"token"];
        parameters = dict;
    }
    
    __weak typeof(self) self_weak_ = self;
    
    return put?({
        
        [[AFHTTPSessionManager manager] PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"responseObject = %@",responseObject);
            
            [self_weak_ processingResultsWithData:responseObject parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error = %@",error);
            
            if (end) {//请求执行完毕
                end(nil);
            }
            if (hasHud) {//隐藏HUD
                [parentView hideHud];
            }
            if (hasMask) {//显示为错误界面
                [parentView showErrorMaskWithHint:nil clickBlock:^{
                    [self_weak_ put_delete_requestsWithUrl:url put:put parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                }];
            }
            if (netWorkError) {//网络异常
                if (error.code != NSURLErrorCancelled){
                    netWorkError(error);
                }
            }
            
        }];
        
    }):({
        
        //delete
        [[AFHTTPSessionManager manager] DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"responseObject = %@",responseObject);
            
            [self_weak_ processingResultsWithData:responseObject parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error = %@",error);
            
            if (end) {//请求执行完毕
                end(nil);
            }
            if (hasHud) {//隐藏HUD
                [parentView hideHud];
            }
            if (hasMask) {//显示为错误界面
                [parentView showErrorMaskWithHint:nil clickBlock:^{
                    [self_weak_ put_delete_requestsWithUrl:url put:put parameters:parameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError];
                }];
            }
            if (netWorkError) {//网络异常
                if (error.code != NSURLErrorCancelled){
                    netWorkError(error);
                }
            }
            
        }];
        
    });
    
}

/** 成功处理 */
-(void)processingResultsWithData:(id)data parentView:(UIView*)parentView hasHud:(BOOL)hasHud hasMask:(BOOL)hasMask end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure netWorkError:(kRequestNetWorkError)netWorkError{
    
    if (hasHud) {//隐藏HUD
        [parentView hideHud];
    }
    if (hasMask) {//隐藏全屏蒙板
        [parentView hideMask];
    }
    //检测请求结果
    [self requestResultWithObject:data end:end success:success failure:failure];
    
}

/**
 *    @brief    检测请求结果
 *
 *    @param     object     请求返回的responseObject
 *    @param     end     结束回调
 *    @param     success     code为0的回调
 *    @param     failure     code不为0的回调
 */
-(void)requestResultWithObject:(id)object end:(kRequestEnd)end success:(kRequestSuccess)success failure:(kRequestFailure)failure {
    
    //获取请求结果集
    URLResponse *responseObject = [URLResponse mj_objectWithKeyValues:object];

    //获取请求配置信息
    URLConfig *config = [URLConfig sharedConfig];
    
    //请求是否成功
    BOOL result = (responseObject.code == config.request_successCode);
    //token是否失效
    if (!result&&(responseObject.code == config.request_tokenFailureCode)) {
        
        //token失效的情况
        if (end) {
            end(responseObject);
        }
        
        if (config.request_tokenFailureBlock) {
            config.request_tokenFailureBlock(responseObject,responseObject.code);
        }
        
        return;
    }
    
    if (end) {
        end(responseObject);
    }
    
    //请求成功回调
    if (result) {
        
        if (success) {
            success(responseObject,responseObject.object);
        }
        
    }else{
        
        //请求失败回调
        if (failure) {
            failure(responseObject,responseObject.code,responseObject.msg);
        }
        
    }
    
    //获取错误码字符串
    NSString *codeString = [NSNumber numberWithInteger:responseObject.code].stringValue;
    
    //查看注册表中是否有相应的code
    if ([config.request_code_dict.allKeys containsObject:codeString]) {
        
        void(^block)(URLResponse *response, id request_obj) = config.request_code_dict[codeString];
        
        if (block) {
            block(responseObject,responseObject.object);
            return;
        }
        
    }
    
}

@end
