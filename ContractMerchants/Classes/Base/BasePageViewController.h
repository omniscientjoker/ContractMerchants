//
//  BasePageViewController.h
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "BaseViewController.h"

@interface BasePageViewController : BaseViewController
@property (nonatomic, strong) NSString *pageId;
//第一次传-1,load传最小的帖子标识rid，refresh传最大的帖子标识rid
@property (nonatomic, strong) NSString *pageTarget;
//first:第一s次刷新 refresh:N+1次刷新 load:加载
@property (nonatomic, strong) NSString *pageNum;
//请求条数
@property (nonatomic, strong) NSString *pageStatus;
//页面状态
@property (nonatomic, strong, readonly) NSMutableArray *array;
//数组dataSource
@property (nonatomic, assign) long long lastFooterRefreshTime;
//为了上提请求过多bug
- (void)firstRefreshLoadingSetUp;
@end
