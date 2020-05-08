//
//  DSImagesPicker.h
//  DSProjectDriver
//
//  Created by ourslook on 2018/1/3.
//  Copyright © 2018年 vanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSImagesPicker : NSObject

-(void)imageSelectorWithSelectedAssets:(NSArray*)selectedAssets vc:(UIViewController*)vc multipleImageBlock:(void(^)(NSArray<UIImage *> *photos, NSArray *assets))imagesBlock singleImageBlock:(void(^)(id asset, UIImage *photo))imageBlock maxCount:(NSInteger)maxCount;

@end
