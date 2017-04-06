//
//  UITextField+Common.h
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Common)
- (BOOL)commonValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
//普通字符的验证
- (BOOL)nameValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
//姓名验证
- (BOOL)passwordValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
//密码中字符的验证
- (BOOL)phoneValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
//电话号码验证
- (BOOL)numberValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
//数字验证
- (BOOL)emailValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
//邮件地址验证
- (BOOL)codeValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
//字符验证
- (BOOL)commonAndPasswordValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
- (BOOL)commonLengthValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage minLength:(int) minLength maxLenth:(int) maxLength;
//长度验证
- (BOOL)IdcardValidate:(NSString *)value;
//身份证验证
- (BOOL)numberverifyCodeValidate:(NSString **)errorMessage prefixErrorMessage:(NSString *)prefixErrorMessage;
// 四位长度 纯数字

@end
