//
//  VAShareView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/17.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "VAShareView.h"
#import "VAShareButton.h"
#import "VASharePlatform.h"
//shareSDK
#import <ShareSDK/ShareSDK.h>
//check
#import <ShareSDKExtension/ShareSDK+Extension.h>
//shareNewsView
#import "GWShareNewsView.h"

static CGFloat const DXShreButtonHeight = 67.f;
static CGFloat const DXShreButtonWith = 45.f;
static CGFloat const DXShreHeightSpace = 26.f;//竖间距
static CGFloat const DXShreCancelHeight = 44.f;

//屏幕宽度与高度
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface VAShareView()<UIGestureRecognizerDelegate>

//底部view
@property (nonatomic,strong) UIView *bottomPopView;

@property (nonatomic,strong) NSMutableArray *platformArray;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) VAShareModel *shareModel;
@property (nonatomic,assign) VAShareContentType shareConentType;
@property (nonatomic,assign) CGFloat shreViewHeight;//分享视图的高度

@end

@implementation VAShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.platformArray = [NSMutableArray array];
        self.buttonArray = [NSMutableArray array];

        //初始化分享平台
        [self setUpPlatformsItems];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.delegate = self;
        [tapGestureRecognizer addTarget:self action:@selector(closeShareView)];
        
        [self addGestureRecognizer:tapGestureRecognizer];
        
        //列数
        int columnCount = 4;
        
        //行数
        NSInteger line = ceilf(self.platformArray.count/[NSNumber numberWithInt:columnCount].floatValue);
        
        //总高度
        CGFloat collectionViewH = line * DXShreButtonHeight + (line + 1) * DXShreHeightSpace + DXShreCancelHeight;
        
        //计算分享视图的总高度
        self.shreViewHeight = collectionViewH;
        
        //计算间隙
        CGFloat appMargin=(SCREEN_WIDTH-columnCount*DXShreButtonWith)/(columnCount+1);
        
        for (int i = 0; i<self.platformArray.count; i++) {
            VASharePlatform *platform = self.platformArray[i];
            //计算列号和行号
            int colX=i%columnCount;
            int rowY=i/columnCount;
            //计算坐标
            CGFloat buttonX = appMargin+colX*(DXShreButtonWith+appMargin);
            CGFloat buttonY = DXShreHeightSpace+rowY*(DXShreButtonHeight+DXShreHeightSpace);
            VAShareButton *shareBut = [[VAShareButton alloc] init];
            [shareBut setTitle:platform.name forState:UIControlStateNormal];
            [shareBut setImage:[UIImage imageNamed:platform.iconStateNormal] forState:UIControlStateNormal];
            [shareBut setImage:[UIImage imageNamed:platform.iconStateHighlighted] forState:UIControlStateHighlighted];
            shareBut.frame = CGRectMake(10, 10, 76, 90);
            [shareBut addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
            shareBut.tag = platform.sharePlatform;
            [self.bottomPopView addSubview:shareBut];
            shareBut.frame = CGRectMake(buttonX, buttonY, DXShreButtonWith, DXShreButtonHeight);
            [self.bottomPopView addSubview:shareBut];
            [self.buttonArray addObject:shareBut];
            
        }
        
//        //按钮动画
//        for (VAShareButton *button in self.buttonArray) {
//            NSInteger idx = [self.buttonArray indexOfObject:button];
//
//            CGAffineTransform fromTransform = CGAffineTransformMakeTranslation(0, 50);
//            button.transform = fromTransform;
//            button.alpha = 0.3;
//
//            [UIView animateWithDuration:0.8+idx*0.1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//
//                button.transform = CGAffineTransformIdentity;
//                button.alpha = 1;
//            } completion:^(BOOL finished) {
//
//            }];
//
//        }
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, self.shreViewHeight - DXShreCancelHeight, SCREEN_WIDTH, DXShreCancelHeight)];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = m_FontPF_Regular_WithSize(16);
        [cancelButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomPopView addSubview:cancelButton];
        
        [self addSubview:self.bottomPopView];

    }
    return self;
}

#pragma mark - 点击了分享按钮
-(void)clickShare:(UIButton *)sender
{

    switch (sender.tag) {
        case SSDKPlatformTypeWechat://微信好友
        {
            [self shareLinkToPlatform:SSDKPlatformTypeWechat shareConentType:self.shareConentType];
        }
            break;
        case SSDKPlatformSubTypeWechatTimeline://微信朋友圈
        {
            [self shareLinkToPlatform:SSDKPlatformSubTypeWechatTimeline shareConentType:self.shareConentType];
        }
            break;
        case SSDKPlatformTypeQQ://QQ好友
        {
            [self shareLinkToPlatform:SSDKPlatformTypeQQ shareConentType:self.shareConentType];
        }
            break;
        case SSDKPlatformTypeSinaWeibo://QQ朋友圈
        {
            [self shareLinkToPlatform:SSDKPlatformTypeSinaWeibo shareConentType:self.shareConentType];
        }
            break;
        default:
            break;
    }
    [self closeShareView];
}

#pragma mark - 分享链接到三方平台
-(void)shareLinkToPlatform:(SSDKPlatformType)shareToPlatform shareConentType:(VAShareContentType)shareConentType{
    
    switch (self.shareConentType) {
        case VAShareContentTypeText://文本分享
        {
            //构建分享参数
            NSArray* imageArray = @[];
            
            id data = self.shareModel.thumbImage;
            if ([data isKindOfClass:NSArray.class]) {
                imageArray = data;
            }else if (![NSString ol_isNullOrNilWithObject:data]){
                imageArray = @[data];
            }
            
            if (imageArray) {
                
                NSString *descr = self.shareModel.descr;
                if (shareToPlatform==SSDKPlatformTypeSinaWeibo) {
                    descr = [descr stringByAppendingString:self.shareModel.url];
                }

                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:descr
                                                 images:imageArray
                                                    url:self.shareModel.url.mj_url
                                                  title:self.shareModel.title
                                                   type:SSDKContentTypeAuto];
                //有的平台要客户端分享需要加此方法，例如微博
                [shareParams SSDKEnableUseClientShare];
                
                [ShareSDK share:shareToPlatform parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    
                    if (error) {
                        NSLog(@"%@",error);
                    }
                    
                    switch (state) {
                            
                        case SSDKResponseStateBegin://开始
                        {
                            
                        }
                            break;
                        case SSDKResponseStateSuccess://成功
                        {
                            m_ToastCenter(@"分享成功");
                        }
                            break;
                        case SSDKResponseStateFail://失败
                        {
                            m_ToastCenter(@"分享失败");
                        }
                            break;
                        case SSDKResponseStateCancel://取消
                        {
                            m_ToastCenter(@"取消分享");
                        }
                            break;
                        default:
                            break;
                    }
                    
                }];
                
            }
        }
            break;
        case VAShareContentTypeImage://图片分享
        {
            //生成分享图
            UIImage *shareNewsImage = [GWShareNewsView gw_shareImageWith:self.shareModel.thumbImage];
            
            //构建分享参数
            NSArray* imageArray = @[shareNewsImage];
            
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:nil
                                                 images:imageArray
                                                    url:nil
                                                  title:nil
                                                   type:SSDKContentTypeAuto];
                //有的平台要客户端分享需要加此方法，例如微博
                [shareParams SSDKEnableUseClientShare];
                
                [ShareSDK share:shareToPlatform parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    
                    if (error) {
                        NSLog(@"%@",error);
                    }
                    
                    switch (state) {
                            
                        case SSDKResponseStateBegin://开始
                        {
                            
                        }
                            break;
                        case SSDKResponseStateSuccess://成功
                        {
                            m_ToastCenter(@"分享成功");
                        }
                            break;
                        case SSDKResponseStateFail://失败
                        {
                            m_ToastCenter(@"分享失败");
                        }
                            break;
                        case SSDKResponseStateCancel://取消
                        {
                            m_ToastCenter(@"取消分享");
                        }
                            break;
                        default:
                            break;
                    }
                    
                }];
                
            }
        }
            break;
        case VAShareContentTypeLink://链接分享
        {
            
        }
            break;
        default:
            break;
    }
}

-(UIView *)bottomPopView
{
    if (_bottomPopView == nil) {
        _bottomPopView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, self.shreViewHeight)];
        _bottomPopView.backgroundColor = m_Color_gray(245);
    }
    return _bottomPopView;
}

-(void)showShareViewWithShareModel:(VAShareModel*)shareModel shareContentType:(VAShareContentType)shareContentType
{
    if (!self.platformArray.count) {
        m_ToastCenter(@"未检测到分享途径");
        return;
    }
    self.shareModel = shareModel;
    self.shareConentType = shareContentType;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2f];
        self.bottomPopView.frame = CGRectMake(0, SCREENH_HEIGHT - self.shreViewHeight, SCREEN_WIDTH, self.shreViewHeight);
    }];
}

#pragma mark - 点击背景关闭视图
-(void)closeShareView
{
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.bottomPopView.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, self.shreViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.bottomPopView]) {
        return NO;
    }
    return YES;
}

#pragma mark 设置平台
-(void)setUpPlatformsItems
{
    
    //检测微信是否安装
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
        
        VASharePlatform *wechatSessionModel = [[VASharePlatform alloc] init];
        wechatSessionModel.iconStateNormal = @"WeChat";
        wechatSessionModel.iconStateHighlighted = @"WeChat";
        wechatSessionModel.sharePlatform = SSDKPlatformTypeWechat;
        wechatSessionModel.name = @"微信";
        [self.platformArray addObject:wechatSessionModel];
        
        VASharePlatform *wechatTimeLineModel = [[VASharePlatform alloc] init];
        wechatTimeLineModel.iconStateNormal = @"cricle";
        wechatTimeLineModel.iconStateHighlighted = @"cricle";
        wechatTimeLineModel.sharePlatform = SSDKPlatformSubTypeWechatTimeline;
        wechatTimeLineModel.name = @"朋友圈";
        [self.platformArray addObject:wechatTimeLineModel];
        
    }
    
    //检测QQ是否安装
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        
        VASharePlatform *qqModel = [[VASharePlatform alloc] init];
        qqModel.iconStateNormal = @"QQ";
        qqModel.iconStateHighlighted = @"QQ";
        qqModel.sharePlatform = SSDKPlatformTypeQQ;
        qqModel.name = @"QQ";
        [self.platformArray addObject:qqModel];

    }
    
    //是否安装微博 并可以通过微博进行分享
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeSinaWeibo]) {
        
        VASharePlatform *qqModel = [[VASharePlatform alloc] init];
        qqModel.iconStateNormal = @"weibo";
        qqModel.iconStateHighlighted = @"weibo";
        qqModel.sharePlatform = SSDKPlatformTypeSinaWeibo;
        qqModel.name = @"微博";
        [self.platformArray addObject:qqModel];
        
    }
    
}

@end
