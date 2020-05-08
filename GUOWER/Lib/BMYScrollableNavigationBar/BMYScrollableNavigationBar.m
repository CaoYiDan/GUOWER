//
//  BMYScrollableNavigationBar.m
//  BMYScrollableNavigationBarDemo
//
//  Created by Alberto De Bortoli on 08/07/14.
//  Copyright (c) 2014 Beamly. All rights reserved.
//

#import <objc/runtime.h>

#import "BMYScrollableNavigationBar.h"

typedef enum {
    BMYScrollableNavigationBarStateNone,
    BMYScrollableNavigationBarStateGesture,
    BMYScrollableNavigationBarStateFinishing,
} BMYScrollableNavigationBarState;

@interface BMYScrollableNavigationBar () <UIGestureRecognizerDelegate>

@property (assign, nonatomic) BOOL scrollable;
@property (assign, nonatomic) CGFloat scrollOffset;
@property (assign, nonatomic) CGFloat scrollOffsetStart;
@property (assign, nonatomic) CGFloat scrollOffsetRelative;
@property (assign, nonatomic) CGFloat barOffset;
@property (assign, nonatomic) CGFloat barOffsetStart;
@property (assign, nonatomic) CGFloat statusBarHeight;
@property (assign, nonatomic) BMYScrollableNavigationBarState scrollState;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

/******** 果味附加属性 ********/

/** 标题 */
@property (nonatomic, weak) UILabel *gw_label;

@end

@implementation BMYScrollableNavigationBar

/******** 果味附加方法 ********/

- (void)gw_setup{
    
    self.translucent = YES;
    
    UIView *superView = [[UIView alloc]init];
    superView.backgroundColor = UIColor.clearColor;
    superView.clipsToBounds = YES;
    [self addSubview:superView];
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(54);
        make.right.mas_equalTo(-54);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = m_FontPF_Medium_WithSize(18);
    self.gw_label = label;
    [superView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(0);
        make.right.mas_lessThanOrEqualTo(0);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(54);
    }];
    
}

- (void)setGw_titleOffset:(CGFloat)gw_titleOffset{
    
    if (_gw_titleOffset==gw_titleOffset) return;
    
    _gw_titleOffset = gw_titleOffset;
    
    [self.gw_label mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(54 * (1-gw_titleOffset));
        
    }];
    
}

- (void)setGw_title:(NSString *)gw_title{
    
    _gw_title = gw_title;
    
    //拿到整体的字符串
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:gw_title];
    
    //imageName
    NSString *imageName = nil;
    
    switch (self.gw_iconType) {
        case GWNewsTitleIconTypeHot:
        {
            imageName = @"hot_icon";
        }
            break;
        case GWNewsTitleIconTypeNew:
        {
            imageName = @"new_icon";
        }
            break;
        default:
            break;
    }
    
    if (![NSString ol_isNullOrNilWithObject:imageName]) {//需要设置图片
        
        string = [[NSMutableAttributedString alloc] initWithString:[@" " stringByAppendingString:gw_title]];
        
        // 创建图片图片附件
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        
        attach.image = [UIImage imageNamed:imageName];
        
        CGRect bounds = CGRectMake(0, -2, 25, 15);
        
        if (m_IS_IPHONE_5) {
            bounds = CGRectMake(0, -1.7, 22, 14);
        }
        
        attach.bounds = bounds;
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        //将图片插入到合适的位置
        [string insertAttributedString:attachString atIndex:0];
        
    }
    
    self.gw_label.attributedText = string;
    
}

/****** 分割线 *****/

const CGFloat DefaultScrollTolerance = 44.0f;
SEL scrollViewDidScrollOriginalSelector;
NSString *ScrollViewContentOffsetPropertyName = @"contentOffset";
NSString *NavigationBarAnimationName = @"BMYScrollableNavigationBar";

@synthesize scrollView = _scrollView;

+ (void)initialize {
    scrollViewDidScrollOriginalSelector = NSSelectorFromString(@"scrollViewDidScrollOriginal:");
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.scrollTolerance = DefaultScrollTolerance;

    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePan:)];
    self.panGesture.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationDidChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [self gw_setup];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification
                                                  object:nil];
    self.scrollView = nil;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    // old scrollView
    if (_scrollView) {
        [_scrollView removeGestureRecognizer:self.panGesture];

        [_scrollView removeObserver:self forKeyPath:ScrollViewContentOffsetPropertyName];
    }

    _scrollView = scrollView;

    // new scrollView
    if (_scrollView) {
        [_scrollView addGestureRecognizer:self.panGesture];

        [_scrollView addObserver:self
                      forKeyPath:ScrollViewContentOffsetPropertyName
                         options:0
                         context:NULL];
    }

    [self resetToDefaultPosition:NO];
}

- (void)resetToDefaultPosition:(BOOL)animated {
    [self setBarOffset:0.0f animated:animated];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:ScrollViewContentOffsetPropertyName] && object == self.scrollView) {
        [self scrollViewDidScroll];
    }
}

#pragma mark - Notifications

- (void)statusBarOrientationDidChange {
    [self resetToDefaultPosition:NO];
}

- (void)applicationDidBecomeActive {
    [self resetToDefaultPosition:NO];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Helpers

- (BOOL)scrollable {
    if (self.viewControllerIsAboutToBePresented) {
        return NO;
    }
    
    CGSize contentSize = self.scrollView.contentSize;
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    CGSize containerSize = self.scrollView.bounds.size;

    CGFloat containerHeight = containerSize.height - contentInset.top - contentInset.bottom;
    CGFloat contentHeight = contentSize.height;
    CGFloat barHeight = self.frame.size.height;
    
    return contentHeight - self.scrollTolerance - barHeight > containerHeight;
}

- (CGFloat)scrollOffset {
    return -(self.scrollView.contentOffset.y + self.scrollView.contentInset.top);
}

- (CGFloat)scrollOffsetRelative {
    return self.scrollOffset - self.scrollOffsetStart;
}

- (void)scrollViewDidScroll {
    if (!self.scrollable) {
        [self setBarOffset:0 animated:NO];
        self.viewControllerIsAboutToBePresented = NO;
        return;
    }

    CGFloat offset = self.scrollOffsetRelative;
    CGFloat tolerance = self.scrollTolerance;

    if (self.scrollOffsetRelative > 0) {
        CGFloat maxTolerance = self.barOffsetStart - self.scrollOffsetStart;
        if (tolerance > maxTolerance) {
            tolerance = maxTolerance;
        }
    }

    if (ABS(offset) < tolerance) {
        offset = 0.0f;
    }
    else {
        offset = offset + (offset < 0 ? tolerance : -tolerance);
    }

    CGFloat barOffset = self.barOffsetStart + offset;
    [self setBarOffset:barOffset animated:NO];

    [self scrollFinishing];
    self.viewControllerIsAboutToBePresented = NO;
}

- (void)scrollFinishing {
    if (self.scrollState != BMYScrollableNavigationBarStateFinishing) {
        return;
    }

    [self debounce:@selector(scrollFinishingActually) delay:0.1f];
}

- (void)scrollFinishingActually {
    self.scrollState = BMYScrollableNavigationBarStateNone;

    CGFloat barOffset = self.barOffset;
    CGFloat barHeight = self.frame.size.height;
    if (
        (ABS(barOffset) < barHeight / 2.0f) ||
        (-self.scrollOffset < barHeight)
    ) {
        // show bar
        barOffset = 0;
    }
    else {
        // hide bar
        barOffset = -barHeight;
    }
    

    [self setBarOffset:barOffset animated:YES];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (!self.scrollView || gesture.view != self.scrollView) {
        return;
    }

    UIGestureRecognizerState gestureState = gesture.state;

    switch (gestureState) {
        case UIGestureRecognizerStateBegan: {
            // Begin state
            self.scrollState = BMYScrollableNavigationBarStateGesture;
            self.scrollOffsetStart = self.scrollOffset;
            self.barOffsetStart = self.barOffset;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            // Changed state
            [self scrollViewDidScroll];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            // End state
            self.scrollState = BMYScrollableNavigationBarStateFinishing;
            [self scrollFinishing];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)statusBarHeight {
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return CGRectGetWidth([UIApplication sharedApplication].statusBarFrame);
        default:
            break;
    };
    return 0.0f;
}

- (CGFloat)barOffset {
    return self.frame.origin.y - self.statusBarHeight;
}

- (void)setBarOffset:(CGFloat)offset {
    [self setBarOffset:offset animated:NO];
}

- (void)setBarOffset:(CGFloat)offset animated:(BOOL)animated {
    if (offset > 0) {
        offset = 0;
    }

    const CGFloat nearZero = 0.001f;

    CGFloat barHeight = self.frame.size.height;
    CGFloat statusBarHeight = self.statusBarHeight;

    offset = MAX(offset, -barHeight);

    CGFloat alpha = MIN(1.0f - ABS(offset / barHeight) + nearZero, 1.0f);
//    CGFloat currentOffset = self.frame.origin.y;
    CGFloat targetOffset = statusBarHeight + offset;

//    if (ABS(currentOffset - targetOffset) < FLT_EPSILON) {
//
//        return;
//    }

    if (animated) {
    
        [UIView beginAnimations:NavigationBarAnimationName context:nil];
        
    }
    
    // apply alpha
    for (UIView *view in self.subviews) {
        BOOL isBackgroundView = (view == [self.subviews objectAtIndex:0]);
        BOOL isInvisible = view.hidden || view.alpha < (nearZero / 2);
        if (isBackgroundView || isInvisible) {
            continue;
        }
        view.alpha = alpha;
        
        
    }

    // apply offset
    CGRect frame = self.frame;
    frame.origin.y = targetOffset;
    self.frame = frame;

    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)debounce:(SEL)selector delay:(NSTimeInterval)delay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:nil afterDelay:delay];
}

@end
