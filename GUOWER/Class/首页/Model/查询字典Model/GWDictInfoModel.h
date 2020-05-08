//
//  GWDictInfoModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/19.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWDictInfoModel : NSObject

/** 字典信息编码，字典信息编码使用之后不能修改 */
@property (nonatomic, copy) NSString *code;

/** <#Description#> */
@property (nonatomic, copy) NSString *createTime;

/** <#Description#> */
@property (nonatomic, copy) NSString *createUser;
/** <#Description#> */
@property (nonatomic, strong) NSNumber *ID;
/** 是否推送至首页 */
@property (nonatomic, strong) NSNumber *isHomePage;
/** 字典信息，字典信息名称使用之后不能修改 */
@property (nonatomic, copy) NSString *name;
/** 备注信息-字典取值 */
@property (nonatomic, copy) NSString *remarks;
/** 跳转链接取值 */
@property (nonatomic, copy) NSString *remarks1;
/** sort,排序字段 */
@property (nonatomic, strong) NSNumber *sort;
/** <#Description#> */
@property (nonatomic, strong) NSNumber *status;
/** 字典信息类型，关联XaDitcypeInfoEntity表的id */
@property (nonatomic, copy) NSString *type;
/** 字典信息类型，关联字典类型code */
@property (nonatomic, copy) NSString *typeCode;
/** 字典信息全部信息 */
@property (nonatomic, copy) NSString *typeId;
/** 字典信息类型，关联字典类型name */
@property (nonatomic, copy) NSString *typeName;

@end
