//
//  GWClauseModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/23.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWClauseModel : NSObject

/** 文案ID */
@property (nonatomic, strong) NSNumber *clauseId;
/** 文案类型 */
@property (nonatomic, copy) NSString *clausetype;
/** 文案内容 */
@property (nonatomic, copy) NSString *content;
/** 创建时间 */
@property (nonatomic, copy) NSString *createtime;
/** 创建者 */
@property (nonatomic, copy) NSString *createuser;
/** 修改时间 */
@property (nonatomic, copy) NSString *modifytime;
/** 修改人 */
@property (nonatomic, copy) NSString *modifyuser;
/** 名称 */
@property (nonatomic, copy) NSString *name;

@end
