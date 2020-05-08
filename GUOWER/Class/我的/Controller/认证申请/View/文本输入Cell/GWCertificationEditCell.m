//
//  GWCertificationEditCell.m
//  GUOWER
//
//  Created by ourslook on 2018/7/11.
//  Copyright © 2018年 Vanne. All rights reserved.
//

#import "GWCertificationEditCell.h"
#import "GWCertificationUIModel.h"

@interface GWCertificationEditCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *gw_title;

@property (weak, nonatomic) IBOutlet UITextField *gw_textField;

@end

@implementation GWCertificationEditCell

- (void)awakeFromNib {
    [super awakeFromNib];

    @weakify(self);
    [self.base_disposableArray addObject:[self.gw_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (self_weak_.textChangeBlcok) {
            self_weak_.textChangeBlcok(x);
        }
    }]];
    
}

-(void)setModel:(GWCertificationUIModel *)model{
    
    self.gw_textField.delegate = self;
    _model = model;
    self.gw_title.text = model.cellTitle;
    self.gw_textField.placeholder = model.cellPlaceholder;
    self.gw_textField.text = model.cellText;
    self.gw_textField.keyboardType = model.cellKeyboardType;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *title = self.model.cellTitle;
    
    if ([title isEqualToString:@"姓名"]) {
        return [textField.text va_isOverflowInRange:range hasSpace:YES replacementString:string MaxLength:10 textField:textField];
    }else if ([title isEqualToString:@"身份证号"]){
        return [textField.text va_isPureNumberAlphabetInRange:range replacementString:string maxLength:18 textField:textField];
    }else if ([title isEqualToString:@"手机号码"]){
        return [textField.text va_isPureNumberInRange:range replacementString:string maxLength:11 textField:textField];
    }else if ([title isEqualToString:@"邮箱"]){
        return [textField.text va_isOverflowInRange:range hasSpace:NO replacementString:string MaxLength:100 textField:textField];
    }else if ([title isEqualToString:@"企业名称"]){
        return [textField.text va_isOverflowInRange:range hasSpace:YES replacementString:string MaxLength:100 textField:textField];
    }else if ([title isEqualToString:@"企业证件号"]){
        return [textField.text va_isPureNumberAlphabetInRange:range replacementString:string maxLength:18 textField:textField];
    }
    
    return YES;
    
}


@end
