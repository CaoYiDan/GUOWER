//
//  GWNewsDetailAdvertCell.m
//  GUOWER
//
#import "GWNewsDetailAdvertCell.h"
#import <SDAutoLayout.h>
//imageView
#import "ZYLoadingImageView.h"
//model
#import "GWAdvertModel.h"

@implementation GWNewsDetailAdvertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
    
}
- (void)setGw_array:(NSArray<GWAdvertModel *> *)gw_array{
    
    _gw_array = gw_array;
    
    __block UIView *agoView = nil;
    
    @weakify(self);
    [gw_array enumerateObjectsUsingBlock:^(GWAdvertModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZYLoadingImageView *imageView = [[ZYLoadingImageView alloc]init];
        imageView.ol_data = obj.image;
        [self_weak_.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            agoView?make.top.equalTo(agoView.mas_bottom).mas_equalTo(10):make.top.mas_equalTo(25);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo((m_ScreenW - 30)/(345/120.00));
        }];
        
        agoView = imageView;
        
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [imageView.base_disposableArray addObject:[tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (self_weak_.advertClickBlock) {
                self_weak_.advertClickBlock(idx);
            }
        }]];
        [imageView addGestureRecognizer:tap];
        
    }];
    //kkjhhjnjjnhjhghjjhiijkkkjkjkjnnn
    [self setupAutoHeightWithBottomView:agoView bottomMargin:15];
    
}

@end
