//
//  CMTabBar.h
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMTabBar;

@protocol CMTabBarDelegate <NSObject>
/*工具栏按钮被选中, 记录从哪里跳转到哪里. (方便以后做相应特效)*/
- (void) tabBar:(CMTabBar *)tabBar selectedFrom:(NSInteger) from to:(NSInteger)to;
@end

@interface CMTabBar : UIView
@property(nonatomic,weak) id<CMTabBarDelegate> delegate;
-(void)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage Title:(NSString *)title;
@end
