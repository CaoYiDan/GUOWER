//
//  GWUserModel.m
//  GUOWER
//
//  Created by ourslook on 2018/6/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWUserModel.h"

@implementation GWUserModel

+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    
    return @{@"ID":@"id"};
    
}

- (NSString *)nickName{
    
    if (!_nickName) {
        _nickName = self.tel;
    }
    
    if ([_nickName va_valiMobile]) {
        _nickName = [_nickName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    return _nickName;
    
}

MJCodingImplementation

@end
