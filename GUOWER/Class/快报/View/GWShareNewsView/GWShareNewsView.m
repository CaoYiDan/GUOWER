//
//  GWShareNewsView.m
//  GUOWER
//
//  Created by ourslook on 2018/7/13.
//  Copyright © 2018年 Vanne. All rights reserved.
//
#import "UIColor+PYSearchExtension.h"
#import "GWShareNewsView.h"
#import "UIButton+ImageTitleSpacing.h"
//model
#import "GWFastNewsModel.h"
//starView
#import "HCSStarRatingView.h"

@implementation GWShareNewsView

+ (UIImage*)gw_shareImageWith:(GWFastNewsModel*)news
{
    GWShareNewsView *shareView = [[GWShareNewsView alloc]initWithNews:news];
    return [self snapshotViewFromRect:shareView.frame withCapInsets:UIEdgeInsetsZero view:shareView];
}

+ (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets view:(UIView*)view{
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(currentContext, - CGRectGetMinX(rect), - CGRectGetMinY(rect));
    [view.layer renderInContext:currentContext];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *snapshotView = [[UIImageView alloc] initWithFrame:rect];
    snapshotView.image = [snapshotImage resizableImageWithCapInsets:capInsets];
    
//    [self saveImage:snapshotView.image];
    return snapshotView.image;
    
}

+ (void)saveImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (instancetype)initWithNews:(GWFastNewsModel*)news
{
    self = [super init];
    if (self) {
        
        //使用固定宽度
        CGFloat screenW = 375;
        
        self.backgroundColor = UIColor.whiteColor;
        
        CGFloat bgH = 764.0/1081.0*screenW;
        
        //顶部背景
        UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_bg_top2"]];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.clipsToBounds = YES;
        [self addSubview:bgImageView];
        self.clipsToBounds = YES;
        bgImageView.ol_width = screenW+2;
        bgImageView.ol_height = bgH+2;
        bgImageView.ol_x = -1;
        bgImageView.ol_y = -1;
        
        //logo
        CGFloat logoW = 315.0/1.4;
        CGFloat logoH = 111.0/1.4;
        
        //logo
        UIImageView *logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_logo"]];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:logoImageView];
        logoImageView.ol_x = (screenW-logoW)/2.0;
        logoImageView.ol_y = 35;
        logoImageView.clipsToBounds = YES;
        logoImageView.ol_width = logoW;
        logoImageView.ol_height = logoH;
        
        
        //日期
        UIImageView *rqImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_date"]];
        [self addSubview:rqImage];
        
        rqImage.ol_x = 31;
        rqImage.ol_y = 160+4.5+15;
        rqImage.ol_width = 19;
        rqImage.ol_height = 19;
        
        //时间
        UILabel *time = [[UILabel alloc]init];
        time.font = m_FontPF_Regular_WithSize(14);
        time.textColor = m_Color_gray(128);
        NSDate *date = [NSDate dateFromString:news.releaseDate];
        time.text = m_NSStringFormat(@"%@ %@ %@",@"",[self weekdayStringFromDate:date],[NSDate stringFromDate:date withFormat:@"yyyy-MM-dd HH:mm"]);
        [time sizeToFit];
        [self addSubview:time];
        
        time.ol_x = CGRectGetMaxX(rqImage.frame) + 7;
        time.ol_centerY = rqImage.ol_centerY;
        
        //指数
//        UILabel *numLabel = [[UILabel alloc]init];
//        numLabel.font = m_FontPF_Regular_WithSize(11);
//        numLabel.textColor = m_Color_gray(102);
//        numLabel.text = @"果味指数：";
//        [numLabel sizeToFit];
//        [self addSubview:numLabel];
//
//        numLabel.ol_x = 203;
//        numLabel.ol_centerY = rqImage.ol_centerY;
//
        //star
//        HCSStarRatingView *star = [[HCSStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 85, 12)];
//        star.filledStarImage = [UIImage imageNamed:@"fill"];
//        star.emptyStarImage = [UIImage imageNamed:@"empty"];
//        star.tintColor = GW_OrangeColor;
//        star.value = news.guowerIndex.floatValue;
//        star.maximumValue = 5;
//        [self addSubview:star];
        
//        star.ol_x = CGRectGetMaxX(numLabel.frame);
//        star.ol_centerY = numLabel.ol_centerY;
//
        //newsTitle
        UILabel *newsTitle = [[UILabel alloc]init];
        newsTitle.font = m_FontPF_Medium_WithSize(18);
        newsTitle.textColor = UIColor.blackColor;
        newsTitle.text = news.title;
        newsTitle.numberOfLines = 0;
        [self addSubview:newsTitle];
        
        newsTitle.ol_x = 31;
        newsTitle.ol_y = CGRectGetMaxY(rqImage.frame) + 15;
        newsTitle.ol_width = screenW - newsTitle.ol_x*2;
        newsTitle.ol_height = [newsTitle.text va_calculatedTextMaxHeightWithMaxWidth:newsTitle.ol_width font:newsTitle.font].height;
        
        //newsContent
        UILabel *newsContent = [[UILabel alloc]init];
        newsContent.font = m_FontPF_Regular_WithSize(16);
        newsContent.textColor = m_Color_gray(0);
        newsContent.text = news.mainText;
        newsContent.numberOfLines = 0;
        [self addSubview:newsContent];
      
       newsContent.attributedText = [self getAttributeWithString:newsContent.text];

        newsContent.ol_x = 31;
        newsContent.ol_y = CGRectGetMaxY(newsTitle.frame) + 20;
        newsContent.ol_width = newsTitle.ol_width;
        CGFloat contentH2 = [self p_getSizeWithTextSize:CGSizeMake(newsContent.ol_width, MAXFLOAT) fontSize:m_FontPF_Medium_WithSize(16) withStr:newsContent.text].height;
       
        newsContent.ol_height = contentH2;
        
       
        //分享自
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [button setTitle:@"" forState:UIControlStateNormal];
//        [button setTitleColor:m_Color_gray(102) forState:UIControlStateNormal];
//        [button.titleLabel setFont:m_FontPF_Regular_WithSize(11)];
//        button.userInteractionEnabled = NO;
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
//        [button sizeToFit];
//        [self addSubview:button];
//
//        button.ol_x = 29;
//        button.ol_y = CGRectGetMaxY(newsContent.frame) + 28;
        
//        UIView *progress = [self createProcessViewByView:button model:news];
//        //添加进度条
//        [self addSubview:progress];
        

        //下载地址
        UILabel *urlLabel = [[UILabel alloc]init];
        urlLabel.numberOfLines = 0;
        urlLabel.textColor = m_Color_RGB(126, 126, 126);
        urlLabel.font = m_FontPF_Semibold_WithSize(12.5);
        urlLabel.text = @"90×00后正流行用果味财经APP\n数字经济 × 流行主义的信息媒体";
        [urlLabel sizeToFit];
        [self addSubview:urlLabel];
        NSMutableParagraphStyle *paragraphStyle1 = [NSMutableParagraphStyle new];

        paragraphStyle1.lineSpacing = 5;

        NSMutableDictionary *attributes2 = [NSMutableDictionary dictionary];

        [attributes2 setObject:paragraphStyle1 forKey:NSParagraphStyleAttributeName];

        urlLabel.attributedText = [[NSAttributedString alloc] initWithString:urlLabel.text attributes:attributes2];
        urlLabel.ol_x = 31;
        urlLabel.ol_y = CGRectGetMaxY(newsContent.frame)+128;
        urlLabel.ol_width = 200;
        urlLabel.ol_height = 50;
        
//        //投资有风险，入市需警慎，本资讯不构成投资建议
        UILabel *urlLabel2 = [[UILabel alloc]init];
        urlLabel2.numberOfLines = 0;
        urlLabel2.textColor = m_Color_gray(102);
        urlLabel2.font = m_FontPF_Regular_WithSize(14);
        urlLabel2.text = @"快速·专业·权威｜扫码下载果味财经";
        [urlLabel2 sizeToFit];
        [self addSubview:urlLabel2];
        urlLabel2.adjustsFontSizeToFitWidth = YES;
        urlLabel2.ol_x = 31;
        urlLabel2.ol_y = CGRectGetMaxY(urlLabel.frame)+0;
        urlLabel2.ol_width = 180;
        //二维码
        UIImageView *qrCode = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"share_qrCode"]];
        [self addSubview:qrCode];
        
        qrCode.ol_x = screenW-70-28;
        qrCode.ol_y = CGRectGetMaxY(newsContent.frame)+131;
        qrCode.ol_width = 68;
        qrCode.ol_height = 68;
        self.ol_width = screenW;
        CGFloat viewH = CGRectGetMaxY(self.subviews.lastObject.frame)>500?CGRectGetMaxY(self.subviews.lastObject.frame):500;
        self.ol_height = (viewH + 28);
        
//        CGFloat contentH = [news.mainText va_calculatedTextMaxHeightWithMaxWidth:screenW - 31*2 font:m_FontPF_Regular_WithSize(12)].height;
        
        UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(12, 155, screenW-12*2, self.ol_height-155-12)];
        shadowView.backgroundColor =  UIColor.whiteColor;
        //阴影设置
        shadowView.layer.shadowColor = [UIColor py_colorWithHexString:@"27347d"].CGColor;
        shadowView.layer.shadowOffset = CGSizeMake(1, 1);
        shadowView.layer.shadowOpacity = 0.2;
        shadowView.layer.shadowRadius = 2.0;
        shadowView.layer.cornerRadius = 8.0;
        [self insertSubview:shadowView atIndex:1];
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(12);
            make.top.offset(155);
        }];
//        bgImageView.ol_height = viewH + 20;
    }
    return self;
}

- (UIView *)createProcessViewByView:(UIView *)vi model:(GWFastNewsModel*)news{

    
    UIView *processBaseView = [[UIView alloc]init];
    processBaseView.frame = CGRectMake(31, vi.ol_y, 375-31*2, 40);
    processBaseView.backgroundColor = UIColor.whiteColor;
    
    NSInteger goodNum = news.good;
    NSInteger badNum = news.bad;
    NSInteger totalNum = goodNum +badNum;
    CGFloat process = (CGFloat)goodNum/(CGFloat)totalNum;
    
    UILabel *goodLab = [[UILabel alloc]initWithFrame:CGRectMake(4, 0, 100, 20)];
    goodLab.text = [NSString stringWithFormat:@"利好%ld",(long)goodNum];
    goodLab.font = [UIFont systemFontOfSize:13];
    goodLab.textColor =[UIColor orangeColor];
    [processBaseView addSubview:goodLab];
    
    UILabel *badLab = [[UILabel alloc]initWithFrame:CGRectMake(371-100-31-31, 0, 100, 20)];
    badLab.textAlignment = NSTextAlignmentRight;
    UIColor *badColor = [UIColor colorWithRed:77.0/255.0 green:214.0/255.0 blue:182.0/255.0 alpha:1];
    badLab.text = [NSString stringWithFormat:@"利空%ld",(long)badNum];
    badLab.font = [UIFont systemFontOfSize:13];
    badLab.textColor = badColor;
    [processBaseView addSubview:badLab];
    
        //创建进度条
        UIProgressView *progressView=[[UIProgressView alloc]init];

        //设置进度条的尺寸
    progressView.frame = CGRectMake(0, 20, 375-31*2, 20);
//   progressView.
        //设置进度条的风格
    
    progressView.progressViewStyle=UIProgressViewStyleDefault;
    
        //进度条走过的颜色
    
        progressView.progressTintColor = [UIColor orangeColor];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    progressView.transform = transform;
        //进度条轨道的颜色
    progressView.trackTintColor = badColor;
    progressView.layer.cornerRadius = 1.5;
    progressView.clipsToBounds = YES;
        //进度条前进的的图片

        //设置当前进度
    
        [progressView setProgress:process animated:YES];
    
       [processBaseView addSubview:progressView];
    return processBaseView;
}

- (NSString*)weekStrigWithDay:(NSInteger)day{
    
    NSArray *weekdays = @[@"星期六",@"星期日", @"星期一", @"星期二", @"星期三",@"星期四", @"星期五"];
    return [weekdays objectAtIndex:day];
    
}
-(NSString *)weekdayStringFromDate:(NSDate *)inputDate
{
    //知道为什么加一个null类型吗？
    //因为数组的下标是以0开始的
    //而星期的对应数字范围是1-7
    //所以加一个null类型(不会取到这个null值)
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

-(CGFloat)getHeightWithText:(NSString *)text andAtribute:(NSDictionary *)attribute width:(CGFloat)width font:(UIFont *)font{
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return textSize.height;
}

-(NSAttributedString *)getAttributeWithString:(NSString *)string{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //行距
    style.lineSpacing = 4;
    style.alignment = NSTextAlignmentJustified;
    //段落间距
    style.paragraphSpacing = 16;
    //首行缩进
//    style.firstLineHeadIndent = 32;

    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:style}];
    return attrText;
}

- (CGSize)p_getSizeWithTextSize:(CGSize)size fontSize:(UIFont *)font withStr:(NSString *)str{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //行距
    style.lineSpacing = 4;
    style.alignment = NSTextAlignmentJustified;
    
    style.alignment = NSTextAlignmentJustified;
    
    style.paragraphSpacing = 16;
    //首行缩进
//    style.firstLineHeadIndent = 32;
    
    CGSize resultSize = [str boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName :font,NSParagraphStyleAttributeName:style}
                                           context:nil].size;
    return resultSize;
}

@end
