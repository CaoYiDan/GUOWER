//
//  GWHPBaseTableVC.h
//  GUOWER
//
//  Created by ourslook on 2018/7/19.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWBaseTableVC.h"
//统一导入
#import "GWDictInfoModel.h"

#import "GWNewsModel.h"

@interface GWHPBaseTableVC : GWBaseTableVC

/** 栏目信息 */
@property (nonatomic, strong) GWDictInfoModel *model;

/** 记载分页数据 */
-(void)loadDataWithHeader:(BOOL)header hud:(BOOL)hud page:(NSNumber *)page size:(NSNumber *)size;

/** 数据Array */
@property (nonatomic, strong) NSMutableArray *array;

@end
