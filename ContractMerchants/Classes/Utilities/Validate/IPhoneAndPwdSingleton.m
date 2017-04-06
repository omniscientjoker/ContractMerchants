//
//  IPhoneAndPwdSingleton.m
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "IPhoneAndPwdSingleton.h"

@implementation IPhoneAndPwdSingleton
+(IPhoneAndPwdSingleton *)sharedInstance{
    static IPhoneAndPwdSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark TextField Content
//是否为空
+ (BOOL)isStringNull:(NSString *)tmpString{
    BOOL bFlag = ( (tmpString == nil) || ([tmpString isEqualToString:@""]) );
    return  bFlag;
}


//连续相同字符
+ (BOOL)isAllSameChars:(NSString *)tmpString{
    unichar fir = [tmpString characterAtIndex:0];
    for (int i = 1; i < tmpString.length; i++){
        unichar c = [tmpString characterAtIndex:i];
        if (c != fir){
            return NO;
        }
    }
    return YES;
}
//联系递增字符
+ (BOOL)hasAllIncreaseChars:(NSString *)tmpString{
    NSInteger l = tmpString.length;
    unichar top = [tmpString characterAtIndex:0];
    int j = 1;
    for (int i = 1; i < tmpString.length; i++){
        unichar c = [tmpString characterAtIndex:i];
        if (c == top+1){
            j++;
        }else{
            j = 1;
        }
        top = c;
    }
    if (j >= l){
        return YES;
    }else{
        return NO;
    }
}
//连续递减字符
+ (BOOL)hasAllDecreaseChars:(NSString *)tmpString{
    NSInteger l = tmpString.length;
    unichar top = [tmpString characterAtIndex:0];
    int j = 1;
    for (int i = 1; i < tmpString.length; i++){
        unichar c = [tmpString characterAtIndex:i];
        if (c == top-1){
            j++;
        }else{
            j = 1;
        }
        top = c;
    }
    if (j >= l) {
        return YES;
    }else{
        return NO;
    }
}


#pragma mark 是否又对应字符
//有空格
+ (BOOL)isHaveSpace:(NSString *)tmpString{
    NSRange _range = [tmpString rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}
//有中文
+ (BOOL)isHaveChinese:(NSString *)tmpString{
    NSString *Regex = @"[\u2E80-\u9FFF]+";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:tmpString];
}
//有数字
+ (BOOL)isHaveNum:(NSString *)tmpString{
    NSString *Regex = @"[\\d]+";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:tmpString];
}
//有字母
+ (BOOL)isHaveWord:(NSString *)tmpString{
    NSString *Regex = @"[A-Za-z]+";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:tmpString];
}
//有特殊符号
+ (BOOL)isHaveCharacter:(NSString *)tmpString{
    NSString *Regex = @"[';><\\/]+";
    NSPredicate *Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [Test evaluateWithObject:tmpString];
}


#pragma mark 长度
//长度等于
+ (BOOL)isLengthEqualGivenLength:(NSString *)tmpString length:(int)length
{
    BOOL bFlag=([tmpString length] == length);
    return bFlag;
}
//长度超过
+ (BOOL)isLengthOverGivenLength:(NSString *)tmpString length:(int)length
{
    BOOL bFlag = ([tmpString length] > length);
    return  bFlag;
}
//长度小于
+ (BOOL)isLengthUnderGivenLength:(NSString *)tmpString length:(int)length
{
    BOOL bFlag = ([tmpString length] < length);
    return  bFlag;
}
//长度大于等于、大于等于
+ (BOOL)isLengthAllGivenLength:(NSString *)tmpString maxlength:(int)maxlength minlength:(int)minlength
{
    BOOL minFlag = ([tmpString length] >= minlength);
    BOOL maxFlag = ([tmpString length] <= maxlength);
    return minFlag&&maxFlag;
}


#pragma mark 获取
//是否为纯数字
+ (BOOL)isNumText:(NSString *)str{
    if(str.length==0){
        return NO;
    }
    unichar c;
    for (int i=0; i<str.length; i++){
        c=[str characterAtIndex:i];
        if (!isdigit(c)){
            return NO;
        }
    }
    return YES;
}
//第一个是否为数字1
+ (BOOL)isFirstIsNumOne:(NSString *)tmpString{
    BOOL bFlag = [[tmpString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"];
    return  bFlag;
}
//是否以空格开头
+ (BOOL)isFirstIsNullOne:(NSString *)tmpString{
    BOOL bFlag = [tmpString hasPrefix:@" "];
    return bFlag;
}
//是否以空格结尾
+(BOOL)isLastIsNullOne:(NSString *)tmpString{
    BOOL bFlag = [tmpString hasSuffix:@" "];
    return bFlag;
}


#pragma mark 验证字符串
/*邮箱验证*/
+(BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
/*手机号码验证*/
+(BOOL) isValidateMobile:(NSString *)mobile{
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
/*手机号码隐藏*/
+ (NSString *)getHidePhoneNum:(NSString *)phoneNum{
    NSString *newPhoneNum = @"";
    if ([phoneNum isEqualToString:@""]) {
        return newPhoneNum;
    }
    newPhoneNum = [phoneNum substringToIndex:3];
    NSString *lastNum = [phoneNum substringFromIndex:7];
    newPhoneNum = [NSString stringWithFormat:@"%@****%@",newPhoneNum,lastNum];
    return newPhoneNum;
}
/*隐藏身份证中间几位*/
+ (NSString *)getHideIdentityNum:(NSString *)identityNum{
    NSString *newidentityNum = @"";
    if ([identityNum isEqualToString:@""]) {
        return newidentityNum;
    }
    NSUInteger num = identityNum.length-4;
    newidentityNum = [identityNum substringToIndex:6];
    NSString *lastNum = [identityNum substringFromIndex:num];
    newidentityNum = [NSString stringWithFormat:@"%@****%@",newidentityNum,lastNum];
    return newidentityNum;
}
/*验证护照号，只能输入"G加8位数字"或"E加8位数字"，共9个字符*/
+ (BOOL)validatePassportCard:(NSString*)passportNum{
    NSString *regex = @"^[EG]\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject: passportNum]) {
        return NO;
    }
    return YES;
}
/* 功能:获取指定范围的字符串* 参数:字符串的开始小标* 参数:字符串的结束下标*/
+(NSString *)getStringWithRange:(NSString *)str Value1:(int)value1 Value2:(int)value2{
    return [str substringWithRange:NSMakeRange(value1,value2)];
}
/*地区码*/
+(BOOL)areaCode:(NSString *)code{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    return YES;
}
/*功能:验证身份证是否合法的身份证号*/
+ (BOOL) chk18PaperId:(NSString *) sPaperIdParam
{
    NSString *sPaperId = [sPaperIdParam uppercaseString];
    if ([sPaperId length] != 15 && [sPaperId length] != 18){
        return NO;
    }
    NSString *carid = sPaperId;
    long lSumQT =0;
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if ([sPaperId length] == 15){
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++){
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    NSString * sProvince = [carid substringToIndex:2];
    if (![self areaCode:sProvince]){
        return NO;
    }
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil){
        return NO;
    }
    const char *PaperId  = [carid UTF8String];
    if(18 != strlen(PaperId)){
        return NO;
    }
    for (int i=0; i<18; i++){
        if (!isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) ){
            return NO;
        }
    }
    for (int i=0; i<=16; i++){
        lSumQT += (PaperId[i]-48) * R[i];
    }
    if (sChecker[lSumQT%11] != PaperId[17] ){
        return NO;
    }
    return YES;
}
@end
