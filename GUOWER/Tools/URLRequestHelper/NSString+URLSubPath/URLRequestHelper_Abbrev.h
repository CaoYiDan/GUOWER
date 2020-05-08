//
//  URLRequestHelper_Abbrev.h
//  XueYouHui_User
//
//  Created by ourslook on 2018/5/12.
//  Copyright © 2018年 Ourslook. All rights reserved.
//

#ifndef URLRequestHelper_Abbrev_h
#define URLRequestHelper_Abbrev_h

#import "URLConfig.h"


#define kPostWith(parameters,...) __VA_ARGS__##_parameters:(parameters) hasCache:hasCache parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError

/** 替换模型中属性的GetterIMP */
#define kStringURLSubPathCoding(BASE_URL) +(void)load{unsigned int count;objc_property_t *properties = class_copyPropertyList(self, &count);for (int i = 0; i < count; i++) {objc_property_t property = properties[i];const char *cName = property_getName(property);NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];SEL original = NSSelectorFromString(name);Method originalM = class_getInstanceMethod([self class], original);IMP current = method_getImplementation(class_getInstanceMethod([self class], @selector(ol_subPath)));method_setImplementation(originalM, current);}}-(NSString*)ol_subPath{NSString *methodString = [@"_" stringByAppendingString:NSStringFromSelector(_cmd)];NSString *newString = [methodString stringByReplacingOccurrencesOfString:@"_" withString:@"/"];Ivar iVar =  class_getInstanceVariable(self.class, [methodString UTF8String]);object_setIvar(self, iVar, newString);return [(BASE_URL) stringByAppendingString:object_getIvar(self, iVar)];}

/** 方法缩写 */

/** post */
#define kURLFormatRequests_POST(kSubUrl,kParameters,kHasCache) [kSubUrl post_parameters:kParameters hasCache:kHasCache parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError]

/** get */
#define kURLFormatRequests_GET(kSubUrl,kParameters,kHasCache) [kSubUrl get_parameters:kParameters hasCache:kHasCache parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError]

/** put */
#define kURLFormatRequests_PUT(kSubUrl,kParameters,kHasCache) [kSubUrl put_parameters:kParameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError]

/** delete */
#define kURLFormatRequests_DELETE(kSubUrl,kParameters,kHasCache) [kSubUrl delete_parameters:kParameters parentView:parentView hasHud:hasHud hasMask:hasMask end:end success:success failure:failure netWorkError:netWorkError]

/** 创建dict */
#define kDictInit NSMutableDictionary *dict = [NSMutableDictionary dictionary];
/** 给dict添加非空数据 */
#define kFormatParameters(KEY,VALUE)\
if (![NSString ol_isNullOrNilWithObject:(VALUE)]) {\
[dict setObject:(VALUE) forKey:(KEY)];\
}\

#endif /* URLRequestHelper_Abbrev_h */
