//
//  BaseViewController.h
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNaviBar.h"
#import "BlockDefine.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#define CMWeakSelfDefine __weak __typeof(&*self) weakSelf = self

@interface BaseViewController : UIViewController
@property (nonatomic, assign) BOOL autoHideBackButton;
@property (nonatomic, assign) BOOL tockenConfirmFaill;
@property (nonatomic, strong) NSString * lastRequest;
@property (nonatomic, assign) BOOL isHttpRequesting;
@property (nonatomic, strong, readonly) CMNaviBar *navigationBar;

- (void)touchViewForCloseKeyBord:(Block)block;
- (void)configUIAppearance;

- (void)animatedPopViewController;
- (void)registerKeyBordChangeFrameAction;
- (void)base_willKeyboardChageFrame:(NSNotification *)notification view:(UIView *)view;

#pragma mark navbar
- (BOOL)navigationControllerIsWillDealloc;
- (void)showFakeNavigationBar:(NSString *)title;
- (void)updateFakeNavigationBarTitle:(NSString *)title;
- (void)setFakeNavigationBarTitleView:(UIView *)titleView;
- (void)setFakeNavigationBarLeftButton:(UIButton *)leftButton;
- (void)setFakeNavigationBarRightButton:(UIButton *)rightButton;

#pragma mark - aleartmessage
//message
- (void)showSuccessAlertWithMessage:(NSString *)message;
- (void)showErrorAlertWithMessage:(NSString *)message;
- (void)showAlertWithMessage:(NSString *)message hideAfterDelay:(float)delay;
//loading
- (void)loading;
- (BOOL)isloading;
- (void)loading:(NSString *)text;
//解决连续发送两个请求的问题
- (void)loadingBlock:(Block)operationBlock;
- (void)loading:(NSString *)text operationBlock:(Block)operationBlock;
- (void)closeLoading;

#pragma mark table
- (UITableView *)getViewTableView;
- (void)setupTableViewRefresh:(UITableView *)tableView needsFooterRefresh:(BOOL)isFooterRefresh;
- (void)setUpTableViewFooterRefresh:(UITableView *)tableView;
- (void)reloadHeaderTableViewDataSource;
- (void)reloadFooterTableViewDataSource;
//是否加载完所有数据
- (void)setLoadDataFinish:(UITableView *)tableView finish:(BOOL) finish;
- (void)didCMNaviBarBackAction;
@end
