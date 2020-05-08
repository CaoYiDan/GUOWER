//
//  DSImagesPicker.m
//  DSProjectDriver
//
//  Created by ourslook on 2018/1/3.
//  Copyright © 2018年 vanne. All rights reserved.
//

#import "DSImagesPicker.h"

#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "JGActionSheet.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface DSImagesPicker ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/** 选中的资源数组 */
@property (nonatomic, strong) NSMutableArray *selectedAssets;

/** 相册回调 */
@property (nonatomic, copy) void(^imagesBlock)(NSArray<UIImage *> *photos, NSArray *assets);

/** 相机回调 */
@property (nonatomic, copy) void(^imageBlock)(id asset, UIImage *photo);

/** 最大选择数量 */
@property (nonatomic, assign) NSInteger maxCount;

/** 待展示的VC */
@property (nonatomic, weak) UIViewController *presentVC;

@end

@implementation DSImagesPicker

-(void)imageSelectorWithSelectedAssets:(NSArray*)selectedAssets vc:(UIViewController*)vc multipleImageBlock:(void(^)(NSArray<UIImage *> *photos, NSArray *assets))imagesBlock singleImageBlock:(void(^)(id asset, UIImage *photo))imageBlock maxCount:(NSInteger)maxCount{
    
    self.imagesBlock = imagesBlock;
    
    self.imageBlock = imageBlock;
    if (maxCount==1) {
        self.selectedAssets = nil;
    }else{
        self.selectedAssets = [selectedAssets copy];
    }
    self.maxCount = maxCount;
    
    self.presentVC = vc;
    
    JGActionSheetSection *s1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"手机拍照", @"相册选择"] buttonIcons:@[@"camera_icon",@"photo_icon"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonIcons:nil buttonStyle:JGActionSheetButtonStyleCancel]]];
    sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    sheet.outsidePressBlock = ^(JGActionSheet *sheet) {
        [sheet dismissAnimated:YES];
    };
    @weakify(self);
    sheet.buttonPressedBlock = ^(JGActionSheet *actionSheet, NSIndexPath *indexPath) {
        [actionSheet dismissAnimated:YES];
        if (indexPath.section) return;

        switch (indexPath.row) {
            case 0:
            {
                [self_weak_ showCameraImagePickerController];
            }
                break;
            case 1:
            {
                [self_weak_ showTZImagePickerController];
            }
                break;
        }
    };
    [sheet showInView:m_KeyWindow animated:YES];
    
}


/** 展示相册 */
-(void)showTZImagePickerController{

    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount delegate:self];
    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowPickingVideo = NO; //是否可以选择视频
    imagePickerVc.allowPickingOriginalPhoto = NO; //是否可以选择原图

    // 通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (self.imagesBlock) {
            self.imagesBlock(photos, assets);
        }
    }];
    
    [self.presentVC presentViewController:imagePickerVc animated:YES completion:nil];
}

/** 展示相机 */
-(void)showCameraImagePickerController{
    
    // 判断有摄像头，并且支持拍照功能
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]){
        // 初始化图片选择控制器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        
        [controller setMediaTypes:@[requiredMediaType]];
        
        controller.delegate = self;
        
        [self.presentVC presentViewController:controller animated:YES completion:nil];
        
    }else {
        NSLog(@"相机不可用");
    }
    
    
}

#pragma mark -- -- -- method

/** 是否有摄像头 */
-(BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/** 是否支持拍照 */
-(BOOL)doesCameraSupportTakingPhotos{
    
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

/** 判断是否支持某种多媒体类型 */
-(BOOL)cameraSupportsMedia:(NSString*)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    
    __block BOOL result=NO;
    
    if ([paramMediaType length]==0) {
        
        NSLog(@"相机不可用");
        
        return NO;
        
    }
    
    NSArray*availableMediaTypes=[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                      NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *mediaType = (NSString *)obj;
        
        if ([mediaType isEqualToString:paramMediaType]){
            
            result = YES;
            
            *stop= YES;
            
        }
        
    }];
    
    return result;
    
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {

    if (self.imageBlock) {
        self.imageBlock(asset, image);
    }
    
}


@end
