#import "UIViewController+K_Utils.h"
#import <objc/runtime.h>

static const char *K_automaticallySetModalPresentationStyleKey;

@implementation UIViewController (K_Utils)

+ (void)load {
    
    Method originAddObserverMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, @selector(K_presentViewController:animated:completion:));
    method_exchangeImplementations(originAddObserverMethod, swizzledAddObserverMethod);
}

-(void)setK_automaticallySetModalPresentationStyle:(BOOL)K_automaticallySetModalPresentationStyle {
    objc_setAssociatedObject(self, K_automaticallySetModalPresentationStyleKey, @(K_automaticallySetModalPresentationStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)K_automaticallySetModalPresentationStyle {
    id obj = objc_getAssociatedObject(self, K_automaticallySetModalPresentationStyleKey);
    if (obj) {
        return [obj boolValue];
    }
    return [self.class K_automaticallySetModalPresentationStyle];
}

+ (BOOL)K_automaticallySetModalPresentationStyle {
    if ([self isKindOfClass:[UIImagePickerController class]] || [self isKindOfClass:[UIAlertController class]]) {
        return NO;
    }
    return YES;
}

- (void)K_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.K_automaticallySetModalPresentationStyle) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [self K_presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        // Fallback on earlier versions
        [self K_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end
