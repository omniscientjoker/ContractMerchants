//
//  BaseTabBarController.h
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CusTabbarView;
@interface BaseTabBarController : UITabBarController<UINavigationControllerDelegate>
@property(nonatomic,strong) CusTabbarView *tabbar;
@property(nonatomic,assign) BOOL isLive;
+(BaseTabBarController *)sharedInstance;
-(void)initTabbarUI;
-(void)initTabbar;
+(void)logout;
@end
