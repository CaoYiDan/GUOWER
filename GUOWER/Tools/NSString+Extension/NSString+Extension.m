//
//  NSString+Extension.m
//  DSProject
//
//  Created by ourslook on 2017/11/28.
//  Copyright © 2017年 ourslook. All rights reserved.
//

#import "NSString+Extension.h"
#import "JGActionSheet.h"

@implementation NSString (Extension)

/**
 *    @brief    NSString转NSNumber
 *
 *    @return    NSNumber
 */
+(NSNumber*)numberValue:(id)value{

    if ([value isKindOfClass:NSNumber.class]) {
        return (NSNumber*)value;
    }
    
    if ([value isKindOfClass:NSString.class]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSNumber *number = [numberFormatter numberFromString:value];
        
        return number;
    }
    
    return nil;
    
}

/**
 *    @brief     NSNumber转NSString
 *
 *    @param     number     NSNumber
 *
 *    @return    NSString
 */
+(NSString*)stringFromNumber:(NSNumber*)number{

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    NSString* string = [numberFormatter stringFromNumber:number];
    
    return string;
    
}

+(NSString *)stringFromInteger:(NSInteger)integer{
    
    return [NSNumber numberWithInteger:integer].stringValue;
    
}

//是否是空字符串
+ (BOOL)va_isBlankString:(NSString *)str{
    
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}

/** 判断对象是否为空 */
+ (BOOL)ol_isNullOrNilWithObject:(id)object;
{
    if (object == nil || [object isEqual:[NSNull null]]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([object isKindOfClass:[NSNumber class]]) {
        if ([object isEqualToNumber:@0]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

//判断是否是手机号
-(BOOL)va_valiMobile{
    
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length != 11)
    {
        return NO;
    }
    else{
        /**
         * 手机号码
         * 移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188 198
         * 联通：130 131 132 145 155 156 166 171 175 176 185 186
         * 电信：133 149 153 173 177 180 181 189 199
         * 虚拟运营商: 170
         */
        NSString *target = @"^(0|86|17951)?(13[0-9]|15[012356789]|16[6]|19[89]]|17[01345678]|18[0-9]|14[579])[0-9]{8}$";
        NSPredicate *targetPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", target];
        if ([targetPredicate evaluateWithObject:self]) {
            return YES;
        }
        
        return NO;
    }
}

- (BOOL)va_validateEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
    
}

- (BOOL)va_judgeIdentityStringValid:(NSString *)identityString {

    NSString *IDNumber = identityString;
    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3",@"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    // 余数数组
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3",@"2", nil];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    
    // 身份证号码最后一位
    NSString *string = [IDNumber substringFromIndex:17];
    
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    if ([str isEqualToString:string]) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
    

}

//限制文本框输入长度
- (BOOL)va_isOverflowInRange:(NSRange)range hasSpace:(BOOL)hasSpace replacementString:(NSString*)string MaxLength:(NSUInteger)length textField:(UIView*)textField{
    
    if (!hasSpace) {
        
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]]componentsJoinedByString:@""];
        if (![string isEqualToString:tem]) {
            return NO;
        }
        
    }
    
    //总长度
    NSUInteger proposedNewLength = self.length - range.length + string.length;
    if (proposedNewLength > length) {
        
        if (self.length<length) {
            NSUInteger subLength = length - self.length;
            if ([textField isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField*)textField;
                tf.text = [NSString stringWithFormat:@"%@%@",self,[string substringWithRange:NSMakeRange(0, subLength)]];
            }else if ([textField isKindOfClass:[UITextView class]]){
                UITextView *tv = (UITextView*)textField;
                tv.text = [NSString stringWithFormat:@"%@%@",self,[string substringWithRange:NSMakeRange(0, subLength)]];
            }
        }
        
        return NO;//限制长度
    }
    return YES;
    
}

//限制文本框只能输入数字 并限制长度
- (BOOL)va_isPureNumberInRange:(NSRange)range replacementString:(NSString*)string  maxLength:(NSUInteger)length textField:(UIView*)textField{
    
    NSUInteger lengthOfString = string.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex];
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48-0
        if (character > 57) return NO;// > 57
    }
    
    //限制长度
    return [self va_isOverflowInRange:range hasSpace:NO replacementString:string MaxLength:length textField:textField];
    
}

//限制文本框只能输入字母和数字 并限制长度
- (BOOL)va_isPureNumberAlphabetInRange:(NSRange)range replacementString:(NSString*)string  maxLength:(NSUInteger)length textField:(UIView*)textField{
    
    NSUInteger lengthOfString = string.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48-0
        if (character > 57 && character < 65) return NO;//58-64
        if (character > 90 && character < 97) return NO;//91-96
        if (character > 122) return NO;
    }
    
    //限制长度
    return [self va_isOverflowInRange:range hasSpace:NO replacementString:string MaxLength:length textField:textField];
    
}

/**
 * 限制文本框只能输入金钱
 */
- (BOOL)va_isMoneyInRange:(NSRange)range replacementString:(NSString*)string  maxLength:(NSUInteger)length textField:(UITextField*)textField{
    
    NSString *NumbersWithDot = @".1234567890";
    NSString *NumbersWithoutDot = @"1234567890";
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    
    if (![string isEqualToString:@""]) {
        
        NSCharacterSet *cs;
        // 小数点在字符串中的位置 第一个数字从0位置开始
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        // 判断字符串中是否有小数点，并且小数点不在第一位
        // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
        // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        if (dotLocation == NSNotFound && range.location != 0) {
            
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            
            /*
             [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
             在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
            if (range.location >= length) {
                NSLog(@"单笔金额不能超过%ld",(long)length);
                if ([string isEqualToString:@"."] && range.location == 9) {
                    return YES;
                }
                return NO;
            }
        }else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
        }
        
        // 按cs分离出数组,数组按@""分离出字符串
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            NSLog(@"只能输入数字和小数点");
            return NO;
        }
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            NSLog(@"小数点后最多两位");
            return NO;
        }
        if (textField.text.length > 11) {
            return NO;
        }
    }
    return YES;
    
}

//计算文本宽高
-(CGSize)va_calculatedTextMaxHeightWithMaxWidth:(CGFloat)width font:(UIFont *)font{
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return textSize;
}

/**
 * 将距离米格式化输出
 */
-(NSString*)formatDistance{
    
    CGFloat distance = self.floatValue;
    
//    if (distance<200) {
//        return @"<200m";
//    }
//    else if(distance<1000.00) {//小于1000米显示为米
//        return m_NSStringFormat(@"%.0fm",distance);
//    }else{
//        return m_NSStringFormat(@"%.2fkm",distance/1000.00);
//    }
    
    if(distance<1000.00) {//小于1000米显示为米
        return m_NSStringFormat(@"%.0fm",distance);
    }else{
        return m_NSStringFormat(@"%.2fkm",distance/1000.00);
    }
    
}

/**
 * 拨打电话
 */
+(void)callPhone:(NSString* )string{
    
    if ([NSString ol_isNullOrNilWithObject:string]) return;
    
    JGActionSheetSection *s1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[string] buttonIcons:nil buttonStyle:JGActionSheetButtonStyleDefault];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonIcons:nil buttonStyle:JGActionSheetButtonStyleCancel]]];
    
    sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    sheet.outsidePressBlock = ^(JGActionSheet *sheet) {
        [sheet dismissAnimated:YES];
    };
    sheet.buttonPressedBlock = ^(JGActionSheet *actionSheet, NSIndexPath *indexPath) {
        
        [actionSheet dismissAnimated:YES];
        
        if (indexPath.section) return;
        
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", string];
        
        if (@available(iOS 10.0, *)) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
            
        }else {
            
            /// 10以下系统
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
            
        }
        
    };
    
    [sheet showInView:m_KeyWindow animated:YES];
    
}

/**
 * 网址中文字符转换
 */
+ (NSString *)urlEncodeString:(NSString *)originalPara {
    
    CFStringRef encodeParaCf = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                       (CFStringRef)originalPara,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8);
    NSString *encodePara = (__bridge NSString *)(encodeParaCf);
    return encodePara;
    
}

/**
 *    @brief    添加金额千位符
 *
 *    @param     money     待格式化的金额
 *
 *    @return    金额字符串
 */
+ (NSString *)formatAmountWithMoney:(double)money{
    money = MAX(money, 0);
    NSNumberFormatter *moneyFormatter = [[NSNumberFormatter alloc]init];
    moneyFormatter.positiveFormat = @"###,###,##0.00";
    NSString *formatString = [moneyFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    
    return formatString;
    
}

/**
 *    @brief    获取当前字符串的时间戳 要求格式为 yyyy-MM-dd HH:mm:ss
 *
 *    @return    时间戳
 */
-(NSInteger)ol_yMdHms_to_timeStamp{
    
    return [[NSDate dateFromString:self withFormat:[NSDate timestampFormatString]] utcTimeStamp];
    
}

/**
 *    @brief    yyyy-MM-dd HH:mm:ss 转 yyyy-MM-dd HH:mm
 *
 *    @return    yyyy-MM-dd HH:mm
 */
-(NSString*)ol_yMdHms_to_yMdHm{
    
    return [[NSDate dateFromString:self withFormat:[NSDate timestampFormatString]] stringWithFormat:@"yyyy-MM-dd HH:mm"];
    
}

/**
 yyyy-MM-dd HH:mm:ss 转 yyyy-MM-dd
 
 @return yyyy-MM-dd
 */
-(NSString *)ol_yMdHms_to_yMd{
    return [[NSDate dateFromString:self withFormat:[NSDate timestampFormatString]] stringWithFormat:@"yyyy-MM-dd"];
}

/**
 yyyy-MM-dd 转 yyyy年MM月dd 星期X
 
 @return yyyy年MM月dd 星期X
 */
-(NSString *)ol_yMd_to_yMd_M{
    
    NSDate *date = [NSDate dateFromString:self withFormat:[NSDate dateFormatString]];
    
    NSString *dateString = [date  stringWithFormat:@"yyyy年MM月dd日"];
    
    NSString *weakString = [self weekStrigWithDay:date.weekday];
    
    return m_NSStringFormat(@"%@ %@",dateString,weakString);
}

- (NSString*)weekStrigWithDay:(NSInteger)day{
    
    NSArray *weekdays = @[@"星期六",@"星期日", @"星期一", @"星期二", @"星期三",@"星期四", @"星期五",@"星期六"];
    return [weekdays objectAtIndex:day];
    
}

/**
 yyyy-MM-dd HH:mm:ss 转 yyyy-MM
 
 @return yyyy-MM
 */
-(NSString *)ol_yMdHms_to_yM{
    return [[NSDate dateFromString:self withFormat:[NSDate timestampFormatString]] stringWithFormat:@"yyyy-MM"];
}

/**
 *    @brief    有小数保留两位，无小数 取整
 *
 *    @param     price     金额
 *
 *    @return    字符串
 */
+(NSString*)formatStringFromDouble:(double)price{
    
  double new = floor(price);
    
    if (price - new <= 0) {
        return [NSString stringFromInteger:[NSNumber numberWithDouble:price].integerValue];
    }
    return [NSString stringWithFormat:@"%.2f",price];
    
}

/**
 *    @brief    根据￥格式化字符串
 *
 *    @param     leftFont     ￥左侧文字大小颜色
 *    @param     rightFont     ￥右侧文字大小颜色
 */
-(NSAttributedString*)priceAttributedStringWithLeftFont:(UIFont*)leftFont leftColor:(UIColor*)leftColor rightFont:(UIFont*)rightFont rightColor:(UIColor*)rightColor{
    
    NSString *mark = @"¥";
    
    if ([self containsString:@"￥"]) {
        mark = @"￥";
    }
    
    NSArray <NSString*> *stringArray = [self componentsSeparatedByString:mark];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *one = [[NSAttributedString alloc] initWithString:stringArray[0] attributes:@{NSFontAttributeName: leftFont, NSForegroundColorAttributeName: leftColor}];
    
    NSString *string = [mark stringByAppendingString:stringArray[1]];
    
    NSAttributedString *two = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: rightFont, NSForegroundColorAttributeName: rightColor}];
    
    [attributedString appendAttributedString:one];
    [attributedString appendAttributedString:two];
    
    return attributedString;
    
}

/**
 *    @brief    通过字典数组创建富文本
 *
 *    @param     array     字典中key ： title(文字)、font(字体)、color(颜色)
 *
 *    @return    富文本
 */
+(NSAttributedString*)attributedStringWithArray:(NSArray<NSDictionary*>*)array{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    for (NSDictionary *format in array) {
        
        NSMutableDictionary *style = [NSMutableDictionary dictionary];
        
        if ([format.allKeys containsObject:@"font"]) {
            [style setObject:[format objectForKey:@"font"] forKey:NSFontAttributeName];
        }
        
        if ([format.allKeys containsObject:@"color"]) {
            [style setObject:[format objectForKey:@"color"] forKey:NSForegroundColorAttributeName];
        }
        
        if ([format.allKeys containsObject:@"title"]) {
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[format objectForKey:@"title"] attributes:style];
            [attributedString appendAttributedString:string];
        }
        
    }
    
    return attributedString;
    
}

/**
 * 字符串转json字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 *  去掉空格
 */
+ (NSString *)trimString:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(CGFloat)getSpaceLabelHeightWithFont:(UIFont*)font withWidth:(CGFloat)width {
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSKernAttributeName:@1.5f
                          };
    CGSize size = [self boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

/**
 删掉字符串中某些特定字符，如：(null)
 */
-(NSString *)removeSpecialString{
    return [self stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
}

@end
