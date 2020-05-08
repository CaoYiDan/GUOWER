#import <UIKit/UIKit.h>

#import "UIImage+ImageWithColor.h"

#import "VAImagePicker.h"
/** 选择框 */
#import "JGActionSheet.h"

@implementation VAImagePickerController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

/**
 *    @brief    返回状态栏颜色
 *
 *    @return    风格
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
    
}

@end

@interface VAImagePicker()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) ImagePickerFinishAction finishAction;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, assign) BOOL isChoose;
@end


static VAImagePicker *ImagePickerInstance = nil;

@implementation VAImagePicker

+ (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerFinishAction)finishAction {
    if (ImagePickerInstance == nil) {
        ImagePickerInstance = [[VAImagePicker alloc] init];
    }
    
    [ImagePickerInstance showImagePickerFromViewController:viewController
                                               allowsEditing:allowsEditing
                                                finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(ImagePickerFinishAction)finishAction {
    _viewController = viewController;
    _finishAction = finishAction;
    _allowsEditing = allowsEditing;
    
    __weak typeof(self) weakSelf = self;
    
    JGActionSheetSection *s1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"手机拍照", @"相册选择"] buttonIcons:@[@"camera_icon",@"photo_icon"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonIcons:nil buttonStyle:JGActionSheetButtonStyleCancel]]];
    
    sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    sheet.outsidePressBlock = ^(JGActionSheet *sheet) {
        [sheet dismissAnimated:YES];
    };
    sheet.buttonPressedBlock = ^(JGActionSheet *actionSheet, NSIndexPath *indexPath) {
        
        [actionSheet dismissAnimated:YES];
        
        if (indexPath.section) return;
        
        switch (indexPath.row) {
            case 0:
            {
                VAImagePickerController *picker = [[VAImagePickerController alloc] init];
                picker.delegate = weakSelf;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
                picker.navigationBar.barTintColor = [UIColor whiteColor];
                [picker.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]}];
                picker.navigationBar.tintColor = [UIColor blackColor];
                picker.allowsEditing = weakSelf.allowsEditing;
                [weakSelf.viewController presentViewController:picker animated:YES completion:nil];
            }
                break;
            case 1:
            {
                VAImagePickerController *picker = [[VAImagePickerController alloc] init];
                picker.delegate = weakSelf;
                [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
                picker.navigationBar.barTintColor = [UIColor whiteColor];
                [picker.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]}];
                picker.navigationBar.tintColor = [UIColor blackColor];
                picker.allowsEditing = weakSelf.allowsEditing;
                [weakSelf.viewController presentViewController:picker animated:YES completion:nil];
            }
                break;
                
            default:
                ImagePickerInstance = nil;
                break;
        }
        
    };
    
    [sheet showInView:m_KeyWindow animated:YES];
    
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (_finishAction) {
        _finishAction(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    ImagePickerInstance = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_finishAction) {
        _finishAction(nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    ImagePickerInstance = nil;
}

@end
