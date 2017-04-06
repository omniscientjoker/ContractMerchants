//
//  BaseTableView.m
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "BaseTableView.h"
#import "JMHTTPSessionManager.h"
@interface BaseTableView ()
@property (nonatomic, strong) UIView *normalFooterView;
@property (nonatomic, strong) UIView *noDataFooterView;
@property (nonatomic, strong) UIView *noNetWorkFooterView;
@property (nonatomic, assign) BOOL isLoadFailed;//网络异常导致加载失败
@property (nonatomic, strong) Block refreshBlock;
@end

#define ADJUST_TABLEVIEW_HEIGHT           64
#define NO_DATA_IMAGE_WIDTH               160
#define NO_DATA_IMAGE_HEIGHT              160
#define NO_DATA_IMAGE_AND_LABEL_PADDING   10

@implementation BaseTableView
#pragma mark - 配置
- (void)setupRefresh:(Block)block{
    if (block) {
        self.refreshBlock = block;
    }
}
#pragma mark - footerView初始化
- (UIView *)normalFooterView{
    if(!_normalFooterView){
        _normalFooterView = [[UIView alloc] init];
    }
    return _normalFooterView;
}

- (UIView *)noDataFooterView{
    if(!_noDataFooterView){
        _noDataFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - ADJUST_TABLEVIEW_HEIGHT)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - NO_DATA_IMAGE_WIDTH/2, _noDataFooterView.frame.size.height/3 - NO_DATA_IMAGE_HEIGHT/2, NO_DATA_IMAGE_WIDTH, NO_DATA_IMAGE_HEIGHT)];
        imageView.image = [UIImage imageNamed:@"tableview_no_data"];
        [_noDataFooterView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshDataWhenTapInNoDataEnvironment)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [_noDataFooterView addGestureRecognizer:tap];
    }
    return _noDataFooterView;
}

- (UIView *)noServerFooterView{
    if(!_noDataFooterView){
        _noDataFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - ADJUST_TABLEVIEW_HEIGHT)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - NO_DATA_IMAGE_WIDTH/2, _noDataFooterView.frame.size.height/3 - NO_DATA_IMAGE_HEIGHT/2, NO_DATA_IMAGE_WIDTH, NO_DATA_IMAGE_HEIGHT)];
        imageView.image = [UIImage imageNamed:@"tableview_error_server"];
        [_noDataFooterView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshDataWhenTapInNoDataEnvironment)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_noDataFooterView addGestureRecognizer:tap];
    }
    return _noDataFooterView;
}
- (UIView *)noNetWorkFooterView{
    if(!_noNetWorkFooterView){
        _noNetWorkFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - ADJUST_TABLEVIEW_HEIGHT)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - NO_DATA_IMAGE_WIDTH/2, _noNetWorkFooterView.frame.size.height/3 - NO_DATA_IMAGE_HEIGHT/2, NO_DATA_IMAGE_WIDTH, NO_DATA_IMAGE_HEIGHT)];
        imageView.image = [UIImage imageNamed:@"tableview_no_network"];
        [_noNetWorkFooterView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshDataWhenTapInNoDataEnvironment)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [_noNetWorkFooterView addGestureRecognizer:tap];
    }
    return _noNetWorkFooterView;
}

#pragma mark - 相关操作
- (void)refreshDataWhenTapInNoDataEnvironment{
    JMBlockSafeRun(self.refreshBlock);
}
- (void)reloadData{
    [super reloadData];
}
- (void)cm_reloadData:(JMHTTPResponse *)response{
    [self reloadData];//数据加载结束后
    if (response && [response.errorCode isEqualToString:moc_http_request_operation_manager_response_network_error_code]) {
        self.tableFooterView = self.noNetWorkFooterView;
    }else if(response && [response.errorCode isEqualToString:moc_http_request_operation_manager_response_other_error_code]){
        self.tableFooterView = self.noServerFooterView;
    }else{
        NSInteger sections = self.numberOfSections;
        NSInteger rows = 0;
        for (int i = 0; i < sections; i++) {
            rows += [self numberOfRowsInSection:i];
        }
        if (rows == 0) {
            self.tableFooterView =self.noDataFooterView;
        }else{
            self.tableFooterView =self.normalFooterView;
        }
    }
}

- (void)cm_reloadData:(JMHTTPResponse *)response count:(NSInteger ) count{
    [self reloadData];//数据加载结束后
    if (response && [response.errorCode isEqualToString:moc_http_request_operation_manager_response_network_error_code]) {
        self.tableFooterView = self.noNetWorkFooterView;
    }else if(response && [response.errorCode isEqualToString:moc_http_request_operation_manager_response_other_error_code]){
        self.tableFooterView = self.noServerFooterView;
    }else{
        if(count==0){
            self.tableFooterView =self.noDataFooterView;
        }else{
            self.tableFooterView =self.normalFooterView;
        }
    }
}

- (void)cm_reloadData:(JMHTTPResponse *)response display:(BOOL) display{
    [self reloadData];//数据加载结束后
    if (response && [response.errorCode isEqualToString:moc_http_request_operation_manager_response_network_error_code]) {
        self.tableFooterView = self.noNetWorkFooterView;
    }else if(response && [response.errorCode isEqualToString:moc_http_request_operation_manager_response_other_error_code]){
        self.tableFooterView = self.noServerFooterView;
    }else{
        if(!display){
            self.tableFooterView =self.noDataFooterView;
        }else{
            self.tableFooterView =self.normalFooterView;
        }
    }
}

- (void)dealloc{
    
    [self removeAllGestureRecognizer];
    
}

@end
