//
//  UITextField+Common.m
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UITextField+Common.h"
#import "IPhoneAndPwdSingleton.h"
#define TX_TEXT_MINLENGTH         6  //文本最小长度
#define TX_TEXT_MAXLENGTH         12 //文本最大长度

#define TX_PWD_MINLENGTH          6  //密码最小长度
#define TX_PWD_MAXLENGTH          16 //密码最大长度
#define XT_CODE_LENGTH            4

@implementation UITextField (Common)
- (BOOL)commonLengthValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage minLength:(int) minLength maxLenth:(int) maxLength{
    //长度验证
    if(![IPhoneAndPwdSingleton isLengthAllGivenLength:self.text maxlength:maxLength minlength:minLength])
    {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:[NSString stringWithFormat:@"长度是%d-%d位哦",minLength,maxLength]];
        return NO;
    }
    return YES;
}

- (BOOL)commonValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    
    if (![self commonAndPasswordValidate:errorMessage prefixErrorMessage:prefixErrorMessage]) {//对的话还要进一步验证
        return NO;
    }
    //验证密码长度 6-12 位
    if(![IPhoneAndPwdSingleton isLengthAllGivenLength:self.text maxlength:TX_TEXT_MAXLENGTH minlength:TX_TEXT_MINLENGTH])
    {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"长度不对哦"];
        return NO;
    }
    return YES;
}
- (BOOL)nameValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    
    if (IsStrEmpty(self.text)) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能为空"];
        return NO;
    }
    
    if ([self.text containsString:@" "]) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能包含空格"];
        return NO;
    }
    return YES;
}
- (BOOL)phoneValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    //验证密码长度 6-12 位
    if (IsStrEmpty(self.text)) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能为空"];
        return NO;
    }
    if(![IPhoneAndPwdSingleton isValidateMobile:self.text])
    {
        *errorMessage = @"请输入正确的手机号码";
        return NO;
    }
    return YES;
}
- (BOOL)numberValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    //验证密码长度 6-12 位
    if (IsStrEmpty(self.text)) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能为空"];
        return NO;
    }
    if(![IPhoneAndPwdSingleton isNumText:self.text])
    {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"只能为纯数字"];
        return NO;
    }
    return YES;
}
- (BOOL)emailValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    //验证密码长度 6-12 位
    if (IsStrEmpty(self.text)) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能为空"];
        return NO;
    }
    if(![IPhoneAndPwdSingleton isValidateEmail:self.text])
    {
        *errorMessage = @"请输入正确的邮箱";
        return NO;
    }
    return YES;
}
- (BOOL)passwordValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    
    if (![self commonAndPasswordValidate:errorMessage prefixErrorMessage:prefixErrorMessage]) {//对的话还要进一步验证
        return NO;
    }
    //验证密码长度 6-12 位
    if(![IPhoneAndPwdSingleton isLengthAllGivenLength:self.text maxlength:TX_PWD_MAXLENGTH minlength:TX_PWD_MINLENGTH])
    {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"长度不对哦"];
        return NO;
    }
    return YES;
}
- (BOOL)codeValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    //验证密码长度 6-12 位
    if (IsStrEmpty(self.text)) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能为空"];
        return NO;
    }
    if (self.text.length != XT_CODE_LENGTH) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:[NSString stringWithFormat:@"长度只能为%@",@(XT_CODE_LENGTH)]];
        return NO;
    }
    return YES;
}
- (BOOL)commonAndPasswordValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    
    if (IsStrEmpty(self.text)) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能为空"];
        return NO;
    }
    
    for (int i = 0; i < self.text.length; i++) {
        unichar c = [self.text characterAtIndex:i];
        if (c != '_') {
            if (c > '9' || c < '0') {
                if ((c < 'a' ||c > 'z') ) {
                    if ((c < 'A' ||c > 'Z')) {
                        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"只能由数字、字母、下划线组成"];
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}
- (BOOL)numberverifyCodeValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage{
    //验证密码长度 6-12 位
    if (IsStrEmpty(self.text)) {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"不能为空"];
        return NO;
    }
    if(![IPhoneAndPwdSingleton isLengthAllGivenLength:self.text maxlength:4 minlength:4])
    {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"长度不对哦"];
        return NO;
    }
    if(![IPhoneAndPwdSingleton isNumText:self.text])
    {
        *errorMessage = [self packageErrorInfo:prefixErrorMessage mainInfo:@"只能为纯数字"];
        return NO;
    }
    return YES;
}

- (BOOL)IdcardValidate:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18)
    {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd, @"[0-9]{3}[0-9Xx]"];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value])
    {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue
                   + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    BOOL result = [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    return result;
}
- (NSInteger)getIDCardSex:(NSString *)card
{
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 0;
    if ([card length] != 18)
    {
        return defaultValue;
    }
    NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0)
    {  //偶数为女
        return 0;
    }
    else
    {
        return 1;
    }
}
- (NSString *)packageErrorInfo:(NSString *)prefixErrorMessage mainInfo:(NSString *)mainInfo{
    return [NSString stringWithFormat:@"%@%@",prefixErrorMessage,mainInfo];
}
@end
