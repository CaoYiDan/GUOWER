//
//	GWWBRootClass.h
//
//	Create by ourslook on 24/7/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "GWWBStatuse.h"

@interface GWWBRootClass : NSObject

@property (nonatomic, strong) NSArray * ad;
@property (nonatomic, strong) NSArray * advertises;
@property (nonatomic, assign) NSInteger has_unread;
@property (nonatomic, assign) BOOL hasvisible;
@property (nonatomic, assign) NSInteger interval;
@property (nonatomic, assign) NSInteger maxId;
@property (nonatomic, assign) NSInteger next_cursor;
@property (nonatomic, assign) NSInteger previous_cursor;
@property (nonatomic, assign) NSInteger since_id;
@property (nonatomic, strong) NSArray * statuses;
@property (nonatomic, assign) NSInteger total_number;
@property (nonatomic, assign) NSInteger uve_blank;

@end
