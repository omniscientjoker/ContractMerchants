//
//  CMNaviBar.h
//  ContractMerchants
//
//  Created by joker on 2017/4/7.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CMNaviBarDelegate <NSObject>
- (void)didCMNaviBarBackAction;
@end

@interface CMNaviBar : UIView
@property (nonatomic ,weak)   id<CMNaviBarDelegate> delegate;
@property (nonatomic, strong) UIView            *titleView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong) UIColor           *bottomLineColor;
- (instancetype)init;
- (void)setRightViews:(NSArray *)views;
- (void)setLeftViews:(NSArray *)views;
- (void)setTitle:(NSString *)title;
- (void)addDefaultLeftBackButton;
- (UIButton *)addRightButton:(NSString *)title imageName:(NSString *)imageName target:(id)target selector:(SEL)selector;
- (UIButton *)addButton:(NSString *)title imageName:(NSString *)imageName target:(id)target selector:(SEL)selector isLeft:(BOOL)isLeft;
@end
