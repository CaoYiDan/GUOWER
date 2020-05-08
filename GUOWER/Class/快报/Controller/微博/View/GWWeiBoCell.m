//
//  GWWeiBoCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/25.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWWeiBoCell.h"
#import <SDAutoLayout.h>
#import <TTTAttributedLabel.h>
#import "GWWBRootClass.h"
#import "GWSafariViewController.h"
#import <KSPhotoBrowser.h>
#import "UIButton+ImageTitleSpacing.h"
#import "GWHPHotNewsCell.h"
#import "VAShareView.h"

@interface GWWeiBoCell ()<TTTAttributedLabelDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

/**  */
@property (nonatomic, weak) UIView *gw_contentView;

/**  */
@property (nonatomic, weak) UILabel *gw_titleLabel;

/** content */
@property (nonatomic, weak) TTTAttributedLabel *gw_contentLabel;

/**  */
@property (nonatomic, weak) UICollectionView *gw_collectionView;

/**  */
@property (nonatomic, weak) UILabel *gw_time;

/**  */
@property (nonatomic, weak) GWHPHotNewsProjectButton *gw_share;

@end

@implementation GWWeiBoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:contentView];
        self.gw_contentView = contentView;
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.right.mas_equalTo(0);
        }];
        
        //title
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = m_FontPF_Medium_WithSize(18);
        titleLabel.textColor = UIColor.blackColor;
        titleLabel.numberOfLines = 0;
        [contentView addSubview:titleLabel];
        self.gw_titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        //content
        TTTAttributedLabel *contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;//自动检索链接
        contentLabel.delegate = self;
        contentLabel.numberOfLines = 0;
        contentLabel.font = m_FontPF_Regular_WithSize(14);
        contentLabel.textColor = m_Color_gray(91);
        NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
        [mutableLinkAttributes setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [mutableLinkAttributes setObject:GW_ThemeColor forKey:(NSString *)kCTForegroundColorAttributeName];
        contentLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
        [contentView addSubview:contentLabel];
        self.gw_contentLabel = contentLabel;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).mas_equalTo(20);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        //image
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(self.class)];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
    
        [contentView addSubview:collectionView];
        self.gw_collectionView = collectionView;
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).mas_equalTo(15);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        //share
        GWHPHotNewsProjectButton *share = [GWHPHotNewsProjectButton buttonWithType:UIButtonTypeCustom];
        [share setImage:[UIImage imageNamed:@"cell_share"] forState:UIControlStateNormal];
        [share setTitle:@"分享" forState:UIControlStateNormal];
        [share.titleLabel setFont:m_FontPF_Regular_WithSize(14)];
        [share setTitleColor:m_Color_gray(188) forState:UIControlStateNormal];
        [share layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        self.gw_share = share;
        
        [contentView addSubview:share];
        
        [share mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.equalTo(collectionView.mas_bottom).mas_offset(15);
            make.width.mas_equalTo(50);
        }];
        
        share.userInteractionEnabled = NO;
        share.hidden = YES;
        
        [self.base_disposableArray addObject:[[share rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            VAShareView *shareView = [[VAShareView alloc]init];
            VAShareModel *model = [[VAShareModel alloc]init];
            [shareView showShareViewWithShareModel:model shareContentType:VAShareContentTypeText];
            
        }]];
        
        //time
        UILabel *time = [[UILabel alloc]init];
        time.textColor = m_Color_gray(143);
        time.font = m_FontPF_Regular_WithSize(14);
        [contentView addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(share);
            make.left.mas_equalTo(15);
        }];
        self.gw_time = time;
        
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(share.mas_bottom).mas_equalTo(20);
        }];
        
        [self setupAutoHeightWithBottomView:contentView bottomMargin:0];
        
    }
    return self;
    
}

- (void)setModel:(GWWBStatuse *)model{
    
    _model = model;
    
    self.gw_titleLabel.text = model.user.name;
    
    self.gw_contentLabel.text = model.text;
    
    self.gw_time.text = [[NSDate dateFromString:model.created_at] stringWithFormat:@"HH:mm"];
    
    [self.gw_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.collectionViewHeight);
    }];

    [self.gw_collectionView reloadData];
    
}

#pragma mark -- TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    
    GWSafariViewController *vc = [[GWSafariViewController alloc]initWithURL:url];
    [UIViewController.currentViewController presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark ---- UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.model.pic_urls.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *image = [[UIImageView alloc]init];
    
    image.tag = 4;
    
    image.contentMode = UIViewContentModeScaleAspectFill;
    
    image.clipsToBounds = YES;
    
    NSString *string = [self.model.pic_urls objectAtIndex:indexPath.row][@"thumbnail_pic"];
    
    string = [string stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    
    NSString *imageURL =  string;
    
    [image sd_setImageWithURL:imageURL.mj_url];
    
    [cell.contentView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        
    }];
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(self.model.cellHeight,self.model.cellHeight);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 15, 0, 15);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray *urls = [self.model.pic_urls mutableArrayValueForKeyPath:@"thumbnail_pic"];

    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < urls.count; i++) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        UIImageView *imageView = [cell.contentView viewWithTag:4];
        NSString *url = [urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:indexPath.row];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleSlide;

    [browser showFromViewController:UIViewController.currentViewController];

}


@end
