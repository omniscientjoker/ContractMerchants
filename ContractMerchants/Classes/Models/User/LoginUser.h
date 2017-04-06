//
//  LoginUser.h
//  AutoNaviSample
//
//  Created by joker on 2017/2/20.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "BaseUser.h"

@interface LoginUser : BaseUser
+(LoginUser *)sharedInstance;
//用户数据
@property (nonatomic, strong) NSString *uId;//唯一标识
@property (nonatomic, strong) NSString *telphone;//登录账号--手机号码
@property (nonatomic, strong) NSString *name;//真实姓名
@property (nonatomic, strong) NSString *nickName;//昵称
@property (nonatomic, strong) NSString *sex;//性别
@property (nonatomic, strong) NSString *age;//年龄
@property (nonatomic, strong) NSString *birther;//出生日期
@property (nonatomic, strong) NSString *idCard;//身份证号码
@property (nonatomic, strong) NSString *password;//用户密码 MD5
@property (nonatomic, strong) NSString *loginTime;//登录时间  yyyy-MM-dd hh:mm:ss
@property (nonatomic, strong) NSString *headerImageUrl;//头像url
@property (nonatomic, assign) NSInteger setSlidebarIndex;


@property (nonatomic, assign) BOOL setNorthUp;//车头向上 no 北向上 yes
@property (nonatomic, assign) BOOL set3Dnavi;//3d导航 yes   2d导航 no


//登陆
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isNotFirstLogin;//是否第一次登录  否：正常登录 是:注销登录
@property (nonatomic, assign) BOOL isAutoLogin;//是否自动登录



//系统设置  YES:仅Wi-Fi网络下载  NO:都下载
@property (nonatomic, assign) BOOL wifiDownloadSet;

@property (nonatomic, assign) BOOL isAdvertisement;
@property (nonatomic, assign) BOOL isAdvertisementClick;
@property (nonatomic, strong) NSString * advertisementPhoto;
//推送设置  YES:允许  NO:不允许
@property (nonatomic, strong) NSString *pushSet;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *deviceToken;

+ (void)parseLoginUserInfoFromUserDefaults;

@end
