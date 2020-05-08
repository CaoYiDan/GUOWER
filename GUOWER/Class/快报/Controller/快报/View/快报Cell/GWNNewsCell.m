//
//  GWNNewsCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/3.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNNewsCell.h"
#import <SDAutoLayout.h>
//model
#import "GWFastNewsModel.h"
//shareView
#import "VAShareView.h"
//buttonlayout
#import "UIButton+ImageTitleSpacing.h"

@interface GWNNewsCell ()

/** 文章标题 */
@property (weak, nonatomic) IBOutlet UILabel *gw_titleLabel;
/** 文章内容 */
@property (weak, nonatomic) IBOutlet UILabel *gw_contentLabel;
/** 发布时间 */
@property (weak, nonatomic) IBOutlet UILabel *gw_timeLabel;
/** 浏览量 */
@property (weak, nonatomic) IBOutlet UIButton *gw_viewsNum;
/** 分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *gw_shareButton;

@property (weak, nonatomic) IBOutlet UIView *gw_contentView;

/**
 利好
 */
@property (weak, nonatomic) IBOutlet UIButton *good;

/**
 利空
 */
@property (weak, nonatomic) IBOutlet UIButton *bad;

@end

@implementation GWNNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.gw_shareButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    [self setupAutoHeightWithBottomView:self.gw_contentView bottomMargin:0];
    
    [self.good addTarget:self action:@selector(goodClick) forControlEvents:UIControlEventTouchDown];
    [self.bad setImage:[UIImage imageNamed:@"bad1"] forState:UIControlStateSelected];
     [self.bad addTarget:self action:@selector(badClick) forControlEvents:UIControlEventTouchDown];
    self.good.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.bad.titleLabel.adjustsFontSizeToFitWidth = YES;
}

-(void)setModel:(GWFastNewsModel *)model{
    
    _model = model;
    
    [self refreshGoodAndBadWithModel:model];
    
    self.gw_titleLabel.text = model.title;
    self.gw_contentLabel.text = model.mainText;
    self.gw_timeLabel.text = [[NSDate dateFromString:model.releaseDate] stringWithFormat:@"HH:mm"];
    [self.gw_viewsNum setTitle:model.lookTimes.stringValue forState:UIControlStateNormal];
}
/**
 根据model，刷新利好和利空的UI
 
 @return
 */
-(void)refreshGoodAndBadWithModel:(GWFastNewsModel*)model{
    
    if (model.isGood) {
        [self.good setImage:[UIImage imageNamed:@"good1"] forState:0];
        [self.bad setImage:[UIImage imageNamed:@"bad0"] forState:0];
        self.good.enabled = NO;
        self.bad.enabled = NO;
    }else if(model.isBad){
        [self.good setImage:[UIImage imageNamed:@"good0"] forState:0];
        [self.bad setImage:[UIImage imageNamed:@"bad1"] forState:0];
        self.good.enabled = NO;
        self.bad.enabled = NO;
    }else{
        [self.good setImage:[UIImage imageNamed:@"good0"] forState:0];
        [self.bad setImage:[UIImage imageNamed:@"bad0"] forState:0];
       
        self.good.enabled = YES;
        self.bad.enabled = YES;
    }
    
 
    
    [self.good setTitle:[NSString stringWithFormat:@" 利好%ld",(long)model.good] forState:0];
    [self.bad setTitle:[NSString stringWithFormat:@" 利空%ld",(long)model.bad] forState:0];
}
/**
 利好点击
 */
-(void)goodClick{
    
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_fastnews_addgood:[self.model.ID stringValue] parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        self_weak_.model.isGood = YES;
     
        self_weak_.model.good+=1;
        
        [self_weak_ refreshGoodAndBadWithModel:self_weak_.model];
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
          NSLog(@"%@",message);
    } netWorkError:^(NSError *error) {
        
    }]];
}

/**
 利空点击
 */
-(void)badClick{
    @weakify(self);
    [self.base_sessionTaskArray addObject:[URLRequestHelper api_app_news_fastnews_addbad:[self.model.ID stringValue] parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
        
    } success:^(URLResponse *response, id object) {
        NSLog(@"%@",object);
        self_weak_.model.bad+=1;
        self_weak_.model.isBad = YES;
        [self_weak_ refreshGoodAndBadWithModel:self_weak_.model];
    } failure:^(URLResponse *response, NSInteger code, NSString *message) {
        NSLog(@"%@",response);
    } netWorkError:^(NSError *error) {
        
    }]];
}
/**
 *    @brief    分享
 */
- (IBAction)shareBtnMethod:(UIButton *)sender {

    VAShareView *shareView = [[VAShareView alloc] init];
    VAShareModel *shareModel = [[VAShareModel alloc] init];
    shareModel.thumbImage = self.model;
    [shareView showShareViewWithShareModel:shareModel shareContentType:VAShareContentTypeImage];
    
}

@end
