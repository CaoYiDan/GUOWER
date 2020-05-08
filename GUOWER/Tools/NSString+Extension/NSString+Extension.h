//
//  NSString+Extension.h
//  DSProject
//
//  Created by ourslook on 2017/11/28.
//  Copyright © 2017年 ourslook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *    @brief    NSString转NSNumber
 *
 *    @return    NSNumber
 */
+(NSNumber*)numberValue:(id)value;

/**
 *    @brief     NSNumber转NSString
 *
 *    @param     number     NSNumber
 *
 *    @return    NSString
 */
+(NSString*)stringFromNumber:(NSNumber*)number;

/**
 *    @brief    NSInteger转NSString
 *
 *    @param     integer     NSInteger
 *
 *    @return    NSString
 */
+(NSString*)stringFromInteger:(NSInteger)integer;

/**
 * 是否是空字符串
 */
+ (BOOL)va_isBlankString:(NSString*)str;

/**
 * 判断对象是否为空
 */
+ (BOOL)ol_isNullOrNilWithObject:(id)object;

/**
 * 判断是否是手机号
 */
- (BOOL)va_valiMobile;

/**
 * 判断是否是邮箱
 */
- (BOOL)va_validateEmail;

/**
 * 判断是否是身份证
 */
- (BOOL)va_judgeIdentityStringValid:(NSString *)identityString;

/**
 * 限制文本框输入长度 是否可以输入空格
 */
- (BOOL)va_isOverflowInRange:(NSRange)range hasSpace:(BOOL)hasSpace replacementString:(NSString*)string MaxLength:(NSUInteger)length textField:(UIView*)textField;

/**
 * 限制文本框只能输入数字 并限制长度
 */
- (BOOL)va_isPureNumberInRange:(NSRange)range replacementString:(NSString*)string  maxLength:(NSUInteger)length textField:(UIView*)textField;

/**
 * 限制文本框只能输入字母和数字 并限制长度
 */
- (BOOL)va_isPureNumberAlphabetInRange:(NSRange)range replacementString:(NSString*)string  maxLength:(NSUInteger)length textField:(UIView*)textField;

/**
 * 限制文本框只能输入金钱
 */
- (BOOL)va_isMoneyInRange:(NSRange)range replacementString:(NSString*)string  maxLength:(NSUInteger)length textField:(UITextField*)textField;

/**
 * 计算文本高度
 */
-(CGSize)va_calculatedTextMaxHeightWithMaxWidth:(CGFloat)width font:(UIFont*)font;

/**
 * 将距离米格式化输出
 */
-(NSString*)formatDistance;

/**
 * 拨打电话
 */
+ (void)callPhone:(NSString *)phoneNum;

/**
 * 网址中文字符转换
 */
+ (NSString *)urlEncodeString:(NSString *)originalPara;

/**
 *    @brief    添加金额千位符
 *
 *    @param     money     待格式化的金额
 *
 *    @return    金额字符串
 */
+ (NSString *)formatAmountWithMoney:(double)money;

/**
 *    @brief    获取当前字符串的时间戳 要求格式为 yyyy-MM-dd HH:mm:ss
 *
 *    @return    时间戳
 */
-(NSInteger)ol_yMdHms_to_timeStamp;


/**
 *    @brief    yyyy-MM-dd HH:mm:ss 转 yyyy-MM-dd HH:mm
 *
 *    @return    yyyy-MM-dd HH:mm
 */
-(NSString*)ol_yMdHms_to_yMdHm;


/**
 yyyy-MM-dd HH:mm:ss 转 yyyy-MM-dd

 @return yyyy-MM-dd
 */
-(NSString *)ol_yMdHms_to_yMd;

/**
 yyyy-MM-dd HH:mm:ss 转 yyyy-MM
 
 @return yyyy-MM
 */
-(NSString *)ol_yMdHms_to_yM;

/**
 yyyy-MM-dd 转 yyyy年MM月dd 星期X
 
 @return yyyy年MM月dd 星期X
 */
-(NSString *)ol_yMd_to_yMd_M;

/**
 *    @brief    有小数保留两位，无小数 取整
 *
 *    @param     price     金额
 *
 *    @return    字符串
 */
+(NSString*)formatStringFromDouble:(double)price;

/**
 *    @brief    根据￥格式化字符串
 *
 *    @param     leftFont     ￥左侧文字大小颜色
 *    @param     rightFont     ￥右侧文字大小颜色
 */
-(NSAttributedString*)priceAttributedStringWithLeftFont:(UIFont*)leftFont leftColor:(UIColor*)leftColor rightFont:(UIFont*)rightFont rightColor:(UIColor*)rightColor;

/**
 *    @brief    格式化不同大小
 */
-(NSAttributedString*)balanceAttributedStringWithLeftFont:(UIFont*)leftFont leftColor:(UIColor*)leftColor rightFont:(UIFont*)rightFont rightColor:(UIColor*)rightColor;

/**
 *    @brief    通过字典数组创建富文本
 *
 *    @param     array     字典中key ： title(文字)、font(字体)、color(颜色)
 *
 *    @return    富文本
 */
+(NSAttributedString*)attributedStringWithArray:(NSArray<NSDictionary*>*)array;

/**
 * 字符串转json字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  去掉空格
 */
+ (NSString *)trimString:(NSString *)str;

/**
 *    @brief    计算富文本高度
 */
-(CGFloat)getSpaceLabelHeightWithFont:(UIFont*)font withWidth:(CGFloat)width;


/**
 删掉字符串中某些特定字符，如：(null)
 */
-(NSString *)removeSpecialString;

@end
