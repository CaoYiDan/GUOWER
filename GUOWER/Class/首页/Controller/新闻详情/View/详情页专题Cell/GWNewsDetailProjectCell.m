//
//  GWNewsDetailProjectCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/5.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWNewsDetailProjectCell.h"
#import <SDAutoLayout.h>
//tagView
#import "GWNewsProjectTagView.h"
//model
#import "GWNewsModel.h"

@interface GWNewsDetailProjectCell ()

/** 责任编辑 */
@property (nonatomic, weak) UILabel *gw_editorLabel;

/** tagView */
@property (nonatomic, weak) GWNewsProjectTagView *gw_tagView;

/** 声明 */
@property (nonatomic, weak) UILabel *gw_statementLabel;

@end

@implementation GWNewsDetailProjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *editorLabel = [[UILabel alloc]init];
        editorLabel.textColor = m_Color_gray(47);
        editorLabel.font = m_FontPF_Regular_WithSize(15);
        editorLabel.numberOfLines = 0;
        [self.contentView addSubview:editorLabel];
        [editorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_lessThanOrEqualTo(-15);
            make.top.mas_equalTo(20);
        }];
        self.gw_editorLabel = editorLabel;
        
        GWNewsProjectTagView *tagView = [[GWNewsProjectTagView alloc]init];
        [self.contentView addSubview:tagView];
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.equalTo(editorLabel.mas_bottom).mas_offset(15);
        }];
        
        self.gw_tagView = tagView;
        
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = m_Color_gray(248.00);
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.equalTo(tagView.mas_bottom);
            make.right.mas_equalTo(0);
        }];
        
        UILabel *statementLabel = [[UILabel alloc]init];
        statementLabel.textColor = m_Color_gray(91);
        statementLabel.numberOfLines = 0;
        statementLabel.text = @"声明：果味财经登载此文出于传递更多信息之目的，并不意味着赞同其观点或证实其描述。文章内容仅供参考，不构成投资建议。投资者据此操作，风险自担。";
        statementLabel.font = m_FontPF_Regular_WithSize(15);
        [view addSubview:statementLabel];
        [statementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(statementLabel.mas_bottom).mas_offset(10);
        }];
        
        self.gw_statementLabel = statementLabel;
        
        [self setupAutoHeightWithBottomView:view bottomMargin:50];
        
    }
    return self;
    
}

- (void)setModel:(GWNewsModel *)model{
    
    _model = model;
    
    self.gw_editorLabel.text = m_NSStringFormat(@"责任编辑：%@",model.responsibleEditor);
    
    NSMutableArray *array = [NSMutableArray array];/** 内容标签1 */
    if (![NSString ol_isNullOrNilWithObject:model.tag1]) {
        [array addObject:model.tag1];
    }
    if (![NSString ol_isNullOrNilWithObject:model.tag2]) {
        [array addObject:model.tag2];
    }
    if (![NSString ol_isNullOrNilWithObject:model.tag3]) {
        [array addObject:model.tag3];
    }
    
    [self.gw_tagView setTagWithTagArray:array];
    
}

@end
