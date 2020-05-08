//
//	GWWBStatuse.m
//
//	Create by ourslook on 24/7/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "GWWBStatuse.h"
#import "NSDate+InternetDateTime.h"

//列数
#define kColumnCount 3

@implementation GWWBStatuse

- (void)setCreated_at:(NSString *)created_at{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //Wed Jul 25 14:59:01 +0800 2018
    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en"];
    
    NSDate *date = [formatter dateFromString:created_at];
    
    NSString *dateString = [NSDate stringFromDate:date withFormat:[NSDate timestampFormatString]];

    _created_at = dateString;
    
}

- (void)setPic_urls:(NSArray *)pic_urls{
    
    _pic_urls = pic_urls;
    
    if (pic_urls.count) {
        
        //行数
        NSInteger line = ceilf(pic_urls.count/[NSNumber numberWithInt:kColumnCount].floatValue);
        
        CGFloat cellHeight = (m_ScreenW - (kColumnCount + 1)*15)/kColumnCount;
        
        CGFloat collectionViewHeight = line *  cellHeight + ((line - 1) * 15);
        
        self.cellHeight = cellHeight;
        
        self.collectionViewHeight = collectionViewHeight;
        
    }else{
        
        self.cellHeight = CGFLOAT_MIN;
        
        self.collectionViewHeight = CGFLOAT_MIN;
        
    }
    
}

@end
