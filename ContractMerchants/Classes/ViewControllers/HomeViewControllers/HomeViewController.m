//
//  HomeViewController.m
//  ContractMerchants
//
//  Created by joker on 2017/4/7.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.needSearchField = YES;
    self.needSelectBtn   = YES;
    [self showFakeNavigationSearchField];
    [self showFakeNavigationBarSelectedBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
