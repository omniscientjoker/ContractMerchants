//
//  StationListView.m
//  ContractMerchants
//
//  Created by joker on 2017/4/10.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "StationListView.h"
#define kStationListCellHeight 56
@interface StationListView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView   * tableView;
@property(nonatomic, strong)NSArray       * titleArray;
@property(nonatomic, strong)UIView        * headView;
@end

@implementation StationListView
static NSString *const kStationCellIdentifier = @"stationlistCellIndentifier";
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    [self initDataSoure];
    [self addSubview:self.tableView];
    [self addSubview:self.headView];    
}
- (void)initDataSoure{
    _titleArray = @[@"离线地图管理",@"车辆信息",@"路线偏好设置",@"常见问题",@"功能介绍",@"去评分",@"关于"];
}
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENDEFAULTHEIGHT)];
        _headView.backgroundColor = [UIColor whiteColor];
        UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 28, 60, 28)];
        [backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:backBtn];
        
        UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-40, 28, 80, 28)];
        titleLab.text = @"采购站点";
        titleLab.textColor = [UIColor blackColor];
        [_headView addSubview:titleLab];
    }
    return _headView;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREENDEFAULTHEIGHT, SCREENWIDTH, SCREENRESULTHEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = RGB(245, 245, 245);
        [self addSubview:_tableView];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kStationCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark tableview
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kStationListCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:
         UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:
         UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStationCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStationCellIdentifier];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate conformsToProtocol:@protocol(StationListDelegate)] && [self.delegate respondsToSelector:@selector(returnselectStation:)]) {
        [self.delegate returnselectStation:_titleArray[indexPath.row]];
    }
    [self clickBackBtn:nil];
}


#pragma mark btn 
-(void)clickBackBtn:(id)sender{
    if (_tableView) {
        [_tableView removeFromSuperview];
        _tableView = nil;
    }
    if (_headView) {
        [_headView removeFromSuperview];
        _headView = nil;
    }
    [self removeFromSuperview];
}
@end
