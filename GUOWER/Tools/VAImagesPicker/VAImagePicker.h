#import <Foundation/Foundation.h>


/** 图片选择完成 */
typedef void (^ImagePickerFinishAction)(UIImage *image);

@interface VAImagePickerController : UIImagePickerController

@end

@interface VAImagePicker : NSObject

/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(ImagePickerFinishAction)finishAction;

@end
