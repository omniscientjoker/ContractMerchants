//
//  BaseTabBarController.m
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "BaseTabBarController.h"
#import "CMTabBar.h"

#import "MineViewController.h"

//停留秒数
#define STAY_BANNER_SECOND      3.0
#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface BaseTabBarController ()<CMTabBarDelegate,UIAlertViewDelegate>{
    @private
    BOOL selectDefaultIndex;
    NSString *urlVersion;
}
@property(nonatomic, strong) MineViewController        *minePageVC;
@property(nonatomic, strong) CMTabBar                  *myView;
/*设置之前选中的按钮*/
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //app 唤醒
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeClick) name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void) didBecomeClick{
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];
}

-(void) initTabbarUI{
    selectDefaultIndex=YES;
    [self setupSubviews];
    self.navigationController.navigationBar.hidden = YES;
    [self initTabbar];
}
- (void)setupSubviews{
    self.minePageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:nil selectedImage:nil];
    self.minePageVC.tabBarItem.tag = 3;
    self.viewControllers = @[self.minePageVC];
}
-(void) initTabbar{
    if(self.myView){
        [self.myView removeFromSuperview];
    }
    CGRect rect = self.tabBar.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar5s"]];
    
    self.myView = [[CMTabBar alloc] init];
    self.myView.delegate = self;
    self.myView.frame = rect;
    [self.tabBar addSubview:self.myView];
    NSArray * arr = [NSArray arrayWithObjects:@"精选",@"客户",@"我的",@"更多", nil];
    for (unsigned int i=0; i<self.viewControllers.count; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"button_tabbar_%d", i + 1];
        NSString *imageNameSel = [NSString stringWithFormat:@"button_tabbar_selected_%d", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *imageSel = [UIImage imageNamed:imageNameSel];
        [self.myView addButtonWithImage:image selectedImage:imageSel Title:[arr objectAtIndex:i]];
    }
}
/**永远别忘记设置代理*/
- (void)tabBar:(CMTabBar *)tabBar selectedFrom:(NSInteger)from to:(NSInteger)to{
    self.selectedIndex = to;
}
+ (void)logout{
    [[BaseTabBarController sharedInstance].minePageVC.view removeFromSuperview];
    [BaseTabBarController sharedInstance].minePageVC=nil;
}
-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(!selectDefaultIndex){
        [super setSelectedIndex:selectedIndex];
    }else{
        selectDefaultIndex=NO;
        [super setSelectedIndex:0];
    }
}

#pragma mark 初始化页面
+ (BaseTabBarController *)sharedInstance{
    static BaseTabBarController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
-(MineViewController *)minePageVC{
    if(!_minePageVC){
        _minePageVC=[[MineViewController alloc] init];
    }
    return _minePageVC;
}


#pragma mark viewLife
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
