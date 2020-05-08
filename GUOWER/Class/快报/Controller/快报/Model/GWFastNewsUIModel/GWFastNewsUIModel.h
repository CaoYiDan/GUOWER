//
//  GWFastNewsUIModel.h
//  GUOWER
//
//  Created by ourslook on 2018/7/18.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWFastNewsUIModel : NSObject

/** 时间 */
@property (nonatomic, copy) NSString *gw_data;

/** 该时间对应的新闻数组 */
@property (nonatomic, strong) NSMutableArray *gw_array;

@end
