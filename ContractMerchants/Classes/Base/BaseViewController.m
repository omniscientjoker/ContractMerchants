//
//  BaseViewController.m
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "BaseViewController.h"
#import "UIView+HUDExtensions.h"
#import "UISearchTextField.h"
#import "StationListView.h"

@interface BaseViewController ()<MBProgressHUDDelegate,UISearchTextFieldDelegate,CMNaviBarDelegate,UIGestureRecognizerDelegate,StationListDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic, assign) BOOL               isLoadingRequest;
@property (nonatomic, strong) Block              block;
@property (nonatomic, strong) UIView             *hudContentView;
@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) UIImageView        *base_fakeNavigationBarBackgroundImageView;
@property (nonatomic, strong) UILabel            *base_fakeNavigationBarTitleLabel;
@property (nonatomic, strong) UISearchTextField  *base_fakeNavigationBarSearchField;
@property (nonatomic, strong) UIButton           *base_fakeNavigationBarSelectedBtn;
@property (nonatomic, strong) UIView             *backVIew;
@property (nonatomic, strong) CMNaviBar          *navigationBar;
@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _needSearchField = NO;
    _needSelectBtn   = NO;
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationBar addDefaultLeftBackButton];
    }else{
        
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    [self.view addSubview:self.navigationBar];
}

- (void)touchViewForCloseKeyBord:(Block)block{
    if (block == nil) {
        return;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickDealWith:)];
    self.block = block;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}
- (void)tapClickDealWith:(UITapGestureRecognizer *)tapGestureRecognizer{
    if (self.block) {
        self.block();
    }
    [self.view endEditing:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    return  YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 文字输入框
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - nav
- (BOOL)navigationControllerIsWillDealloc{
    if (![self.navigationController.viewControllers containsObject:self]) {
        return YES;
    }else{
        return NO;
    }
}
- (void)animatedPopViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIKeyBoard
- (void)registerKeyBordChangeFrameAction{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(base_keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)base_keyboardFrameWillChange:(NSNotification *)notification{
    [self base_willKeyboardChageFrame:notification view:nil];
}
- (void)base_willKeyboardChageFrame:(NSNotification *)notification view:(UIView *)view{
    NSDictionary *userInfo = notification.userInfo;
    CGRect toFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        CGRect rect = [view convertRect:view.frame toView:self.view];
        
        if (beginFrame.origin.y == SCREENHEIGHT){//开始编辑
            CGFloat moveDistance = toFrame.size.height  - (SCREENHEIGHT - (rect.origin.y + rect.size.height)) - 64;
            if ( moveDistance > 0) {
                [self changeSelfViewYPosition:moveDistance];
            }
        }
        else if (toFrame.origin.y == SCREENHEIGHT){//结束编辑
            [self changeSelfViewYPosition:0];
        }
        else{
            CGFloat bottom = (SCREENHEIGHT - (rect.origin.y + rect.size.height));
            CGFloat moveDistance = toFrame.size.height - bottom;
            if ( moveDistance > 0) {
                [self changeSelfViewYPosition:moveDistance];
            }else{
                [self changeSelfViewYPosition:0];
            }
        }
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}
- (void)changeSelfViewYPosition:(CGFloat)yPosition{
    CGRect frame = self.view.frame;
    if (yPosition == 0){
        frame.origin.y = 64;
    }else{
        frame.origin.y -= yPosition;
    }
    self.view.frame = frame;
}

#pragma mark hud
- (UIView *)hudContentView{
    if (_hudContentView) {
        return _hudContentView;
    }
    _hudContentView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENDEFAULTHEIGHT, SCREENWIDTH, SCREENRESULTHEIGHT)];
    _hudContentView.backgroundColor = [UIColor clearColor];
    return _hudContentView;
}
//success
- (void)showSuccessAlertWithMessage:(NSString *)message{
    [self.view addSubview:self.hudContentView];
    HUD = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    UIImage *image = [UIImage imageNamed:@"success_alert_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake( 100/2 - image.size.width/2 , 70/2 - image.size.height/2, image.size.width, image.size.height);
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [customView addSubview:imageView];
    HUD.customView = customView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.label.text = message;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];
}
//error
- (void)showErrorAlertWithMessage:(NSString *)message{
    [self.view addSubview:self.hudContentView];
    HUD = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    UIImage *image = [UIImage imageNamed:@"error_alert_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake( 100/2 - image.size.width/2 , 70/2 - image.size.height/2, image.size.width, image.size.height);
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [customView addSubview:imageView];
    HUD.customView = customView;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.label.text = nil;
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:20];
}
//message
- (void)showAlertWithMessage:(NSString *)message hideAfterDelay:(float)delay{
    [self.view addSubview:self.hudContentView];
    //弹出信息的时候 加载效果要消失
    [HUD hideAnimated:YES];
    if (IsStrEmpty(message)) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.hudContentView animated:YES];
    hud.label.textColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = self;
    hud.detailsLabel.text=message;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:17.0f];
    if (delay) {
        [hud hideAnimated:YES afterDelay:delay];
    }else{
        [hud hideAnimated:YES afterDelay:2.0];
    }
    [self.view hidePopupLoading];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

//loading
- (void)loading{
    if (self.isLoadingRequest) {
        return;
    }
    self.isLoadingRequest = YES;
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoading];
}
- (BOOL)isloading{
    if (HUD != nil && !HUD.isHidden) {
        return YES;
    }
    HUD.delegate = nil;
    [HUD removeFromSuperview];
    HUD = nil;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor colorWithRed:68.0/255.0 green:184.0/255.0 blue:159.0/255.0 alpha:1.0];
    HUD.delegate = self;
    HUD.minSize = CGSizeMake(80.f, 80.f);
    [HUD showAnimated:YES];
    return NO;
}
- (void)loading:(NSString *)text{
    if (IsStrEmpty(text)) {
        return;
    }
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoadingWithText:text];
}

- (void)loadingBlock:(Block)operationBlock{
    if (self.isLoadingRequest) {
        return;
    }
    self.isLoadingRequest = YES;
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoading];
    if (operationBlock) {
        operationBlock();
    }
}
- (void)loading:(NSString *)text operationBlock:(Block)operationBlock{
    if (self.isLoadingRequest) {
        return;
    }
    self.isLoadingRequest = YES;
    [self.view addSubview:self.hudContentView];
    [self.hudContentView showPopupLoadingWithText:text];
    if (operationBlock) {
        operationBlock();
    }
}
- (void)closeLoading
{
    self.isLoadingRequest = NO;
    [self.hudContentView removeFromSuperview];
    [self.hudContentView hidePopupLoading];
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [self.hudContentView removeFromSuperview];
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark 配置下拉刷新
- (UITableView *)getViewTableView{
    
    return self.tableView;
    
}
#pragma mark --是否加载完所有数据
- (void)setLoadDataFinish:(UITableView *) tableView finish:(BOOL) finish{
    if (tableView == nil) {
        return;
    }
    self.tableView = tableView;
    if(finish){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
}

- (void)setupTableViewRefresh:(UITableView *)tableView needsFooterRefresh:(BOOL)isFooterRefresh{
    if (tableView == nil) {
        return;
    }
    self.tableView = tableView;
    // 添加动画图片的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadHeaderTableViewDataSource)];
    if (isFooterRefresh) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadFooterTableViewDataSource)];
    }
}
- (void)setUpTableViewFooterRefresh:(UITableView *)tableView{
    if (tableView == nil) {
        return;
    }
    self.tableView = tableView;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadFooterTableViewDataSource)];
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadHeaderTableViewDataSource{
    [self.tableView.mj_header endRefreshing];
}

- (void)reloadFooterTableViewDataSource{
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - fake navigation
- (CMNaviBar *)navigationBar{
    if (_navigationBar == nil) {
        _navigationBar = [[CMNaviBar alloc] init];
        _navigationBar.delegate = self;
        [_navigationBar setBackgroundColor:[UIColor whiteColor]];
    }
    return _navigationBar;
}
- (void)didCMNaviBarBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImageView *)base_fakeNavigationBarBackgroundImageView{
    if (!_base_fakeNavigationBarBackgroundImageView) {
        _base_fakeNavigationBarBackgroundImageView = [[UIImageView alloc] initWithImage:[common imageWithColor:COMMON_COLOR andSize:CGSizeMake(SCREENWIDTH, 64)]];
        _base_fakeNavigationBarBackgroundImageView.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
        _base_fakeNavigationBarBackgroundImageView.userInteractionEnabled = YES;
    }
    return _base_fakeNavigationBarBackgroundImageView;
}
- (UISearchTextField *)base_fakeNavigationBarSearchField{
    if (!_base_fakeNavigationBarSearchField) {
        _base_fakeNavigationBarSearchField = [[UISearchTextField alloc] init];
        _base_fakeNavigationBarSearchField.searchdelegate = self;
        _base_fakeNavigationBarSearchField.placeholder = @"    品名/规格/钢厂/材质";
        _base_fakeNavigationBarSearchField.frame = CGRectMake(SCREENWIDTH/4, 28, SCREENWIDTH/2, 28);
        _base_fakeNavigationBarSearchField.layer.masksToBounds = YES;
        _base_fakeNavigationBarSearchField.layer.cornerRadius  = 6.0f;
        _base_fakeNavigationBarSearchField.layer.borderWidth   = 1.0f;
        _base_fakeNavigationBarSearchField.layer.borderColor   = [UIColor colorWithRed:14/255.0 green:174/255.0 blue:131/255.0 alpha:1].CGColor;
        _base_fakeNavigationBarSearchField.userInteractionEnabled = YES;
    }
    return _base_fakeNavigationBarSearchField;
}
- (UIButton *)base_fakeNavigationBarSelectedBtn{
    if (!_base_fakeNavigationBarSelectedBtn) {
        _base_fakeNavigationBarSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _base_fakeNavigationBarSelectedBtn.frame = CGRectMake(SCREENWIDTH-SCREENWIDTH/4+10, 28, SCREENWIDTH/4-15, 28);
        _base_fakeNavigationBarSelectedBtn.backgroundColor = [UIColor clearColor];
        [_base_fakeNavigationBarSelectedBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        _base_fakeNavigationBarSelectedBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_base_fakeNavigationBarSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_base_fakeNavigationBarSelectedBtn setTitle:@"宁南站" forState:UIControlStateNormal];
        [_base_fakeNavigationBarSelectedBtn setImage:[UIImage imageNamed:@"icon_arrowdown_img"] forState:UIControlStateNormal];
        _base_fakeNavigationBarSelectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-20,0,0);
        _base_fakeNavigationBarSelectedBtn.imageEdgeInsets = UIEdgeInsetsMake(0,60,0,0);
    }
    return _base_fakeNavigationBarSelectedBtn;
}
- (UILabel *)base_fakeNavigationBarTitleLabel{
    if (!_base_fakeNavigationBarTitleLabel){
        _base_fakeNavigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, SCREENWIDTH - 140, 44)];
        _base_fakeNavigationBarTitleLabel.font = [UIFont systemFontOfSize:22.];
        _base_fakeNavigationBarTitleLabel.textColor = [UIColor whiteColor];
        _base_fakeNavigationBarTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _base_fakeNavigationBarTitleLabel;
}
- (void)showFakeNavigationBarSelectedBtn{
     [self.view addSubview:self.base_fakeNavigationBarSelectedBtn];
}
- (void)showFakeNavigationSearchField{
    [self.view addSubview:self.base_fakeNavigationBarSearchField];
}

- (void)showFakeNavigationBar:(NSString *)title{
    if (_needSelectBtn) {
        [self.view addSubview:self.base_fakeNavigationBarSelectedBtn];
    }
    if (_needSearchField) {
        [self.view addSubview:self.base_fakeNavigationBarSearchField];
    }else{
        [self.view addSubview:self.base_fakeNavigationBarBackgroundImageView];
        if (title.length > 0) {
            [self.view addSubview:self.base_fakeNavigationBarTitleLabel];
            self.base_fakeNavigationBarTitleLabel.text = title;
        }
    }
}
- (void)updateFakeNavigationSelectedBtnTitle:(NSString *)title{
    if (_needSelectBtn) {
        if (_base_fakeNavigationBarSelectedBtn) {
            self.base_fakeNavigationBarSelectedBtn.titleLabel.text = title;
        }
    }
}
- (void)updateFakeNavigationBarTitle:(NSString *)title{
    if (!_needSearchField){
        if (title.length > 0) {
            self.base_fakeNavigationBarTitleLabel.text = title;
        }
    }
}
- (void)setFakeNavigationBarTitleView:(UIView *)titleView{
    [self.view addSubview:self.base_fakeNavigationBarBackgroundImageView];
    if (_needSelectBtn) {
        [self.view addSubview:self.base_fakeNavigationBarSelectedBtn];
    }
    if (!_needSearchField){
        [self.base_fakeNavigationBarTitleLabel removeFromSuperview];
        self.base_fakeNavigationBarTitleLabel = nil;
    }else{
        [self.base_fakeNavigationBarSearchField removeFromSuperview];
        self.base_fakeNavigationBarSearchField = nil;
    }
    CGFloat maxWidth = SCREENWIDTH - 140;
    if (titleView.width > maxWidth) {
        titleView.frame = CGRectMake(titleView.left, titleView.top, maxWidth, titleView.height);
    }
    titleView.center = CGPointMake(self.base_fakeNavigationBarBackgroundImageView.center.x, self.base_fakeNavigationBarBackgroundImageView.center.y + 10);
    [self.base_fakeNavigationBarBackgroundImageView addSubview:titleView];
}
- (void)setFakeNavigationBarLeftButton:(UIButton *)leftButton{
    if (leftButton) {
        leftButton.frame = CGRectMake(70, 20, 70, 44);
        [self.base_fakeNavigationBarBackgroundImageView addSubview:leftButton];
    }
}
- (void)setFakeNavigationBarRightButton:(UIButton *)rightButton{
    if (rightButton) {
        rightButton.frame = CGRectMake(SCREENWIDTH - 70, 20, 70, 44);
        [self.base_fakeNavigationBarBackgroundImageView addSubview:rightButton];
    }
}



-(void)clickSelectBtn:(id)sender{
    StationListView * listView = [[StationListView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    listView.delegate = self;
    [self.view addSubview:listView];
}
-(void)returnselectStation:(NSString *)stationname{
    [self updateFakeNavigationSelectedBtnTitle:stationname];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc{
    NSLog(@"释放 %s",object_getClassName(self));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [HUD removeFromSuperview];
    HUD.delegate = nil;
    HUD = nil;
}

@end
