//
//  BasePageViewController.m
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "BasePageViewController.h"

@interface BasePageViewController ()
@property (nonatomic, strong) NSMutableArray *array;//数组dataSource
@end

@implementation BasePageViewController
- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self firstRefreshLoadingSetUp];
}

- (void)firstRefreshLoadingSetUp{
    self.pageId = @"-1";
    self.pageTarget = @"first";
    self.pageNum = @"15";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
