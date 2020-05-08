//
//  BMYScrollableNavigationBar.h
//  BMYScrollableNavigationBarDemo
//
//  Created by Alberto De Bortoli on 08/07/14.
//  Copyright (c) 2014 Beamly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMYScrollableNavigationBar : UINavigationBar

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat scrollTolerance;
@property (assign, nonatomic) BOOL viewControllerIsAboutToBePresented;

- (void)resetToDefaultPosition:(BOOL)animated;

/******** 果味附加属性 ********/

/** 标题Icon类型 */
@property (nonatomic, assign) GWNewsTitleIconType gw_iconType;
/** 富文本标题 */
@property (nonatomic, copy) NSString *gw_title;
/** 偏移属性 */
@property (nonatomic, assign) CGFloat gw_titleOffset;

@end
