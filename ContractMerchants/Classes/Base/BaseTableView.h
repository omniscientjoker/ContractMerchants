//
//  BaseTableView.h
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMHTTPResponse.h"
@interface BaseTableView : UITableView
- (void)setupRefresh:(Block)block;

//1.如果是网络请求后的数据刷新,传回response,原则是:tableview的数据源不为空时,只显示正常列表。
//如果此时的列表为空,那么会根据response解析是否是网络问题造成,是则展示网络失败,否则展示无数据.
//2.如果response传入为nil,要么展示正常的有数据的列表,要么展示无数据。
- (void)cm_reloadData:(JMHTTPResponse *)response;//没有数据的时候会显示

- (void)cm_reloadData:(JMHTTPResponse *)response count:(NSInteger ) count;

- (void)cm_reloadData:(JMHTTPResponse *)response display:(BOOL) display;

@end
