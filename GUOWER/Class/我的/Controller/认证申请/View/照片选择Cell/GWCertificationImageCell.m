//
//  GWCertificationImageCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCertificationImageCell.h"
#import <SDAutoLayout.h>
//model
#import "GWCertificationUIModel.h"
//select
#import "DSImagesPicker.h"
//cells
#import "GWCertificationShowImageCell.h"

#define kMaxCount 1

@interface GWCertificationImageCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** titleLabel */
@property (nonatomic, strong) UILabel *gw_titleLabel;

/** collectionView */
@property (nonatomic, strong) UICollectionView *gw_collectionView;

/** selectImage */
@property (nonatomic, strong) DSImagesPicker *gw_imagePicker;

@end

@implementation GWCertificationImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.gw_titleLabel = [[UILabel alloc]init];
        self.gw_titleLabel.textColor = m_Color_gray(47);
        self.gw_titleLabel.font = m_FontPF_Regular_WithSize(15);
        [self.contentView addSubview:self.gw_titleLabel];
        [self.gw_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_lessThanOrEqualTo(-15);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        self.gw_collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        self.gw_collectionView.backgroundColor = [UIColor whiteColor];
        self.gw_collectionView.delegate = self;
        self.gw_collectionView.dataSource = self;
        [self.gw_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(GWCertificationShowImageCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(GWCertificationShowImageCell.class)];
        [self.gw_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(self.class)];
        [self.contentView addSubview:self.gw_collectionView];
        @weakify(self);
        [self.gw_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.equalTo(self_weak_.gw_titleLabel.mas_bottom);
            make.height.mas_equalTo(74);
        }];
        
        [self setupAutoHeightWithBottomView:self.gw_collectionView bottomMargin:15];
        
    }
    return self;
    
}

-(void)setModel:(GWCertificationUIModel *)model{
    
    _model = model;
    self.gw_titleLabel.text = model.cellTitle;
    [self.gw_collectionView reloadData];
    
    //本来适配的是正方形，现在修改为长方形，且永远只可以显示一张
    
    
    
//    CGFloat width = (m_ScreenW - 50)/4;
//
//    //提供给SDAutoLayout预算Cell高度
//    NSInteger line = ceil(model.cellImages.count/4.00);
//    [self.gw_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(model.cellImages.count?line*width + (line - 1)*10:width);
//    }];
    
}

#pragma mark ---- UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.model.cellImages.count) {
        return self.model.cellImages.count;
    }else{
        return 1;
    }

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.model.cellImages.count) {
        
        GWCertificationShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GWCertificationShowImageCell.class) forIndexPath:indexPath];
        cell.gw_imageView.ol_data = [self.model.cellImages objectAtIndex:indexPath.row];
        cell.gw_imageView.contentMode = UIViewContentModeScaleAspectFill;
        @weakify(self);
        cell.delBtnClickBlock = ^{
            [self_weak_.model.cellImages removeObjectAtIndex:indexPath.row];
            [self_weak_.model.cellAssets removeObjectAtIndex:indexPath.row];
            if (self_weak_.cellNeedReloadData) {
                self_weak_.cellNeedReloadData();
            }
        };
        return cell;
        
    }else{
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
        
        UIImageView *image = [cell.contentView viewWithTag:55];
        
        if (!image) {
            
            image = [[UIImageView alloc]init];
            
            image.tag = 55;
            
            image.contentMode = UIViewContentModeLeft;
            
            image.image = self.model.placeholderImage;
            
            [cell.contentView addSubview:image];
            
            [image mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.top.mas_equalTo(5);
                make.right.bottom.mas_equalTo(-5);
                
            }];
            
        }
        
        
        return cell;
        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //本来适配的是正方形，现在修改为长方形，且永远只可以显示一张 所以写死宽高
    
    if (self.model.cellImages.count) {
        return CGSizeMake(113, 74);
    }
    return CGSizeMake(74, 74);
    
//    CGFloat width = (m_ScreenW - 50)/4;
//    return CGSizeMake(width, width);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:GWCertificationShowImageCell.class]) {
        GWCertificationShowImageCell *showCell = (GWCertificationShowImageCell*)cell;
        if (showCell.gw_delBtn.hidden) return;
    }
    [m_KeyWindow endEditing:YES];
    @weakify(self);
    [self.gw_imagePicker imageSelectorWithSelectedAssets:self_weak_.model.cellAssets vc:[UIViewController currentViewController] multipleImageBlock:^(NSArray<UIImage *> *photos, NSArray *assets) {
        self_weak_.model.cellImages = [NSMutableArray arrayWithArray:photos];
        self_weak_.model.cellAssets = [NSMutableArray arrayWithArray:assets];
        if (self_weak_.cellNeedReloadData) {
            self_weak_.cellNeedReloadData();
        }
    } singleImageBlock:^(id asset, UIImage *photo) {
        if (self_weak_.model.cellAssets.count>=kMaxCount) {
            //替换最后一个
            NSMutableArray *photos = [NSMutableArray arrayWithArray:self_weak_.model.cellImages];
            NSMutableArray *assets = [NSMutableArray arrayWithArray:self_weak_.model.cellAssets];
            [photos replaceObjectAtIndex:photos.count-1 withObject:photo];
            [assets replaceObjectAtIndex:assets.count-1 withObject:asset];
            self_weak_.model.cellImages = photos;
            self_weak_.model.cellAssets = assets;
        }else{
            NSMutableArray *photos = [NSMutableArray arrayWithArray:self_weak_.model.cellImages];
            [photos addObject:photo];
            self_weak_.model.cellImages = photos;
            NSMutableArray *assets = [NSMutableArray arrayWithArray:self_weak_.model.cellAssets];
            [assets addObject:asset];
            self_weak_.model.cellAssets = assets;
        }
        if (self_weak_.cellNeedReloadData) {
            self_weak_.cellNeedReloadData();
        }
    } maxCount:kMaxCount];
    
}

-(DSImagesPicker *)gw_imagePicker{
    
    if(!_gw_imagePicker){
        _gw_imagePicker = [[DSImagesPicker alloc]init];
    }
    return _gw_imagePicker;
    
}

@end
