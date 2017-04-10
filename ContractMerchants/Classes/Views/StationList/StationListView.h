//
//  StationListView.h
//  ContractMerchants
//
//  Created by joker on 2017/4/10.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StationListDelegate <NSObject>
@optional
-(void)returnselectStation:(NSString *)stationname;
@end


@interface StationListView : UIView
@property(nonatomic,readwrite,weak)id<StationListDelegate>  delegate;
@end
