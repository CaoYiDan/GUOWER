//
//  VASharePlatform.h
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface VASharePlatform : NSObject

/** buttonNormalIcon */
@property (nonatomic,copy) NSString *iconStateNormal;
/** buttonHighlightedIcon */
@property (nonatomic,copy) NSString *iconStateHighlighted;
/** buttonName */
@property (nonatomic,copy) NSString *name;
/** shareType */
@property (nonatomic,assign) SSDKPlatformType sharePlatform;

@end
