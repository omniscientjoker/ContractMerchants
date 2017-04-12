
//
//  MineHeadView.m
//  ContractMerchants
//
//  Created by joker on 2017/4/12.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "MineHeadView.h"
#import "UIImage+blur.h"
@interface MineHeadView ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)UITableView   * tableView;
@property(nonatomic, strong)NSArray       * titleArray;
@property(nonatomic, strong)UIImageView   * headBackImgView;
@property(nonatomic, strong)UIImageView   * HeadImgView;
@property(nonatomic, strong)UILabel       * nameLable;
@property(nonatomic, strong)UIImage       * headImg;
@property(nonatomic, strong)NSString      * nameStr;
@end



@implementation MineHeadView
-(instancetype)initWithImgName:(UIImage *)img Name:(NSString *)name{
    self = [super init];
    if (self) {
        _headImg = img;
        _nameStr = name;
    }
    return self;
}
-(UIImageView *)headBackImgView{
    if (_headBackImgView) {
        _headBackImgView = [[UIImageView alloc] initWithImage:[_headImg imgWithBlur]];
        _headBackImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _headBackImgView.contentMode=UIViewContentModeScaleAspectFill;
        _headBackImgView.userInteractionEnabled = YES;
        _headBackImgView.clipsToBounds=YES;
        [_headBackImgView addSubview:self.HeadImgView];
        [_headBackImgView addSubview:self.nameLable];
    }
    return _headBackImgView;
}
-(UIImageView *)HeadImgView{
    if (_HeadImgView) {
        _HeadImgView = [[UIImageView alloc] initWithImage:_headImg];
        _HeadImgView.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2);
        _HeadImgView.layer.masksToBounds    = YES;
        _HeadImgView.userInteractionEnabled = YES;
        _HeadImgView.clipsToBounds          = YES;
        _HeadImgView.contentMode            = UIViewContentModeScaleAspectFill;
        _HeadImgView.layer.cornerRadius  = self.frame.size.width/4;
        _HeadImgView.layer.shadowColor   = [UIColor clearColor].CGColor;
        _HeadImgView.layer.shadowOffset  = CGSizeMake(4, 4);
        _HeadImgView.layer.shadowOpacity = 0.5;
        _HeadImgView.layer.shadowRadius  = 3.0;
        _HeadImgView.center = self.center;
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = YES;
        [_HeadImgView addGestureRecognizer:singleTap];
    }
    return _HeadImgView;
}
-(UILabel *)nameLable{
    if (_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.textAlignment = NSTextAlignmentCenter;
        _nameLable.textColor = [UIColor whiteColor];
        _nameLable.backgroundColor = [UIColor clearColor];
        _nameLable.font = [UIFont systemFontOfSize:20.0];
        _nameLable.text = _nameStr;
    }
    return _nameLable;
}
-(void)initBackHeadView{
    [self addSubview:self.headBackImgView];
}
-(void)updateHeadImgWithImg:(UIImage *)img{
    [_headBackImgView setImage:[img imgWithBlur]];
    [_HeadImgView setImage:img];
}
-(void)handleSingleTap:(UITapGestureRecognizer *)handle{
    
}
@end
