#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (K_Utils)
/**
Whether or not to set ModelPresentationStyle automatically for instance, Default is [Class K_automaticallySetModalPresentationStyle].
@return BOOL
*/
@property (nonatomic, assign) BOOL K_automaticallySetModalPresentationStyle;

/**
 Whether or not to set ModelPresentationStyle automatically, Default is YES, but UIImagePickerController/UIAlertController is NO.
 @return BOOL
 */
+ (BOOL)K_automaticallySetModalPresentationStyle;
@end

NS_ASSUME_NONNULL_END
