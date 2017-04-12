//
//  MineHeadView.h
//  ContractMerchants
//
//  Created by joker on 2017/4/12.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MineHeadViewDelegate <NSObject>
@optional
-(void)tapHeadImg;
@end


@interface MineHeadView : UIView

@end
