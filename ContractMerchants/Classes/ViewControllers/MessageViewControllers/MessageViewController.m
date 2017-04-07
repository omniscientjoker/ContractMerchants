//
//  MessageViewController.m
//  ContractMerchants
//
//  Created by joker on 2017/4/7.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "MessageViewController.h"
#import <NIMSDK.h>
@interface MessageViewController ()<NIMLoginManagerDelegate>

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    NSString *userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    NSLog(@"%@",userID);
}



- (void)dealloc{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
