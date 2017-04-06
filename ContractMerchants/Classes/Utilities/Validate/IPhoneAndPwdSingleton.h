//
//  IPhoneAndPwdSingleton.h
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    CheckDataType_None,
    CheckDataType_Empty,
    CheckDataType_FormatWrong,
    CheckDataType_Space
}CheckDataType;

@interface IPhoneAndPwdSingleton : NSObject

+(IPhoneAndPwdSingleton *)sharedInstance;

#pragma mark TextField Content
//是否为空
+ (BOOL)isStringNull:(NSString *)tmpString;
//连续相同字符
+ (BOOL)isAllSameChars:(NSString *)tmpString;
//联系递增字符
+ (BOOL)hasAllIncreaseChars:(NSString *)tmpString;
//连续递减字符
+ (BOOL)hasAllDecreaseChars:(NSString *)tmpString;

#pragma mark 是否又对应字符
//有特殊符号
+ (BOOL)isHaveCharacter:(NSString *)tmpString;
//有空格
+ (BOOL)isHaveSpace:(NSString *)tmpString;
//有中文
+ (BOOL)isHaveChinese:(NSString *)tmpString;
//有数字
+ (BOOL)isHaveNum:(NSString *)tmpString;
//有字母
+ (BOOL)isHaveWord:(NSString *)tmpString;


#pragma mark 长度
//长度等于
+ (BOOL)isLengthEqualGivenLength:(NSString *)tmpString length:(int)length;
//长度小于
+ (BOOL)isLengthUnderGivenLength:(NSString *)tmpString length:(int)length;
//长度超过
+ (BOOL)isLengthOverGivenLength:(NSString *)tmpString length:(int)length;
//长度大于、大于
+ (BOOL)isLengthAllGivenLength:(NSString *)tmpString maxlength:(int)maxlength minlength:(int)minlength;


#pragma mark 获取
//是否为纯数字
+ (BOOL)isNumText:(NSString *)str;
//第一个是否为数字1
+ (BOOL)isFirstIsNumOne:(NSString *)tmpString;
//是否以空格开头
+ (BOOL)isFirstIsNullOne:(NSString *)tmpString;
//是否以空格结尾
+(BOOL)isLastIsNullOne:(NSString *)tmpString;


#pragma mark 验证字符串
/*地区码*/
+(BOOL)areaCode:(NSString *)code;
/*邮箱验证*/
+(BOOL)isValidateEmail:(NSString *)email;
//验证身份证 -1 为错误 10：男 11:女
+(BOOL)chk18PaperId:(NSString *) sPaperIdParam;
/*手机号码验证*/
+(BOOL)isValidateMobile:(NSString *)mobile;
/*隐藏手机号中间四位*/
+ (NSString *)getHidePhoneNum:(NSString *)phoneNum;
/*隐藏身份证中间几位*/
+ (NSString *)getHideIdentityNum:(NSString *)identityNum;
/* 功能:获取指定范围的字符串* 参数:字符串的开始小标* 参数:字符串的结束下标*/
+(NSString *)getStringWithRange:(NSString *)str Value1:(int)value1 Value2:(int)value2;


@end
