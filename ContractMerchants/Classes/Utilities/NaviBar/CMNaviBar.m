//
//  CMNaviBar.m
//  ContractMerchants
//
//  Created by joker on 2017/4/7.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "CMNaviBar.h"
const CGFloat CMNaviBarStatusBarDefaultHeight = 20;
const CGFloat CMNaviBarDefaultHeight = 44 + CMNaviBarStatusBarDefaultHeight;
const CGFloat CMNaviBarViewsDefaultWidth   = 65;
const CGFloat CMNaviBarButtonDefaultWidth  = 45;
const CGFloat CMNaviBarViewsDefaultPadding = 10;
const CGFloat CMNaviBarViewsDefaultMargin  = 5;

@interface CMNaviBar()
@property (nonatomic, strong) NSArray   *leftViews;
@property (nonatomic, strong) NSArray   *rightViews;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) UIButton  *backButton;
@property (nonatomic, strong) UIView    *bottomLine;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, assign) BOOL      didLayoutSubviews;
@end

@implementation CMNaviBar
#pragma mark - mark Override
- (instancetype)init{
    if (self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CMNaviBarDefaultHeight)]) {
        self.layer.borderColor=[UIColor clearColor].CGColor;
        self.layer.borderWidth=1.0f;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self configureSubviews];
}
#pragma mark - LayoutSubviews
- (void)configureSubviews{
    if (self.superview == nil || self.didLayoutSubviews == YES){
        return;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat lineHeight = 0.5;
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - lineHeight, CGRectGetWidth(self.frame), lineHeight);
    self.bottomLine.backgroundColor = self.bottomLineColor?:[UIColor colorWithRed:0xe2/255. green:0xe2/255. blue:0xe2/255. alpha:1.0];
    CGFloat limitWidthNumber = MIN(1, self.leftViews.count + self.rightViews.count) * 2;
    UIView *titleView = [self realTitleView];
    
    CGFloat width = CGRectGetWidth(self.frame);
    if (limitWidthNumber > 0) {
        if (titleView == self.titleLabel) {
            [self.titleLabel sizeToFit];
        }
        CGFloat limitWidthNumber = MIN(1, self.leftViews.count + self.rightViews.count) * 2;
        CGFloat titleViewMaxWidth = width - limitWidthNumber * (CMNaviBarViewsDefaultWidth + CMNaviBarViewsDefaultPadding + CMNaviBarViewsDefaultMargin);
        CGFloat titleViewWidth = MIN(titleViewMaxWidth, CGRectGetWidth(titleView.frame));
        if (CGRectGetWidth(titleView.frame) > 0 ) {
            CGFloat titleViewHeight = CGRectGetHeight(titleView.frame) > 0 ? CGRectGetHeight(titleView.frame):(CMNaviBarDefaultHeight - CMNaviBarStatusBarDefaultHeight);
            titleView.frame = CGRectMake(width/2 - titleViewWidth/2, CMNaviBarStatusBarDefaultHeight/2 +CMNaviBarDefaultHeight/2 - titleViewHeight/2, titleViewWidth, titleViewHeight);
            [self addSubview:titleView];
        }
        
        [self layoutSubviews:self.leftViews isLeft:YES];
        [self layoutSubviews:self.rightViews isLeft:NO];
        
    }else{
        if (CGRectGetWidth(titleView.frame) <= 0 || CGRectGetWidth(titleView.frame) > CGRectGetWidth(self.frame)) {
            titleView.frame = CGRectMake(0, CMNaviBarStatusBarDefaultHeight, CGRectGetWidth(self.frame), CMNaviBarDefaultHeight - CMNaviBarStatusBarDefaultHeight);
        }
        [self addSubview:titleView];
    }
    [self addSubview:self.bottomLine];
    self.didLayoutSubviews = YES;
}
- (void)layoutSubviews:(NSArray *)views isLeft:(BOOL)isLeft{
    UIView *titleView = [self realTitleView];
    CGFloat titleViewMinX = (self.titleView || self.title)?CGRectGetMinX(titleView.frame):CGRectGetMidX(self.frame);
    CGFloat titleViewMaxX = (self.titleView || self.title)?CGRectGetMaxX(titleView.frame):CGRectGetMidX(self.frame);
    CGFloat minPointX = isLeft ? CMNaviBarViewsDefaultMargin : titleViewMaxX + CMNaviBarViewsDefaultPadding;
    CGFloat maxPointX = isLeft ? titleViewMinX - CMNaviBarViewsDefaultPadding : CGRectGetWidth(self.frame) - CMNaviBarViewsDefaultMargin;
    __block CGFloat lastViewMaxPoiontX = isLeft? minPointX:maxPointX;
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isLeft) {
            if (lastViewMaxPoiontX + CGRectGetWidth(view.frame) + CMNaviBarViewsDefaultPadding < maxPointX) {
                view.frame = CGRectMake(0, CGRectGetMinY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
                lastViewMaxPoiontX += (CGRectGetWidth(view.frame) + CMNaviBarViewsDefaultPadding);
            }else{
                //说明空间不够下次布局了，而且这次布局要压缩
                view.frame = CGRectMake(lastViewMaxPoiontX, CGRectGetMinY(view.frame), maxPointX - lastViewMaxPoiontX - CMNaviBarViewsDefaultPadding, CGRectGetHeight(view.frame));
                *stop = YES;
            }
        }else{
            if (lastViewMaxPoiontX - CGRectGetWidth(view.frame) - CMNaviBarViewsDefaultPadding > minPointX) {
                view.frame = CGRectMake(lastViewMaxPoiontX+10 -  CGRectGetWidth(view.frame), CGRectGetMinY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
                lastViewMaxPoiontX -= (CGRectGetWidth(view.frame) + CMNaviBarViewsDefaultPadding);
            }else{
                //说明空间不够下次布局了，而且这次布局要压缩
                view.frame = CGRectMake(minPointX, CGRectGetMinY(view.frame), lastViewMaxPoiontX - minPointX ,CGRectGetHeight(view.frame));
                *stop = YES;
            }
        }
        [self addSubview:view];
    }];
}
- (void)resetLayoutSubviewsFlagThenConfigure{
    self.didLayoutSubviews = NO;
    [self configureSubviews];
}
- (UIView *)realTitleView{
    return self.titleView?:self.titleLabel;
}
#pragma mark - Setter Methods
- (void)setRightViews:(NSArray *)views{
    _rightViews = views;
    [self resetLayoutSubviewsFlagThenConfigure];
}
- (void)setLeftViews:(NSArray *)views{
    //说明要有返回按钮，不能直接替换
    if (self.backButton && [views containsObject:self.backButton] == NO) {
        NSMutableArray *mutableArray = [(views?:@[]) mutableCopy];
        [mutableArray addObject:self.backButton];
        _leftViews = mutableArray;
    }else{
        _leftViews = views;
    }
    [self resetLayoutSubviewsFlagThenConfigure];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    [self resetLayoutSubviewsFlagThenConfigure];
}
- (void)setTitleView:(UIView *)titleView{
    _titleView = titleView;
    [self resetLayoutSubviewsFlagThenConfigure];
}
#pragma mark - Action
- (void)backAction:(id)sender{
    if ([_delegate respondsToSelector:@selector(didCMNaviBarBackAction)]) {
        [_delegate didCMNaviBarBackAction];
    }
}
#pragma mark - Public
- (void)addDefaultLeftBackButton{
    if (self.backButton == nil) {
        self.backButton = [self addButton:nil imageName:@"navigationBarBack" target:self selector:@selector(backAction:) isLeft:YES];
        [self resetLayoutSubviewsFlagThenConfigure];
    }
}
- (UIButton *)addRightButton:(NSString *)title imageName:(NSString *)imageName target:(id)target selector:(SEL)selector{
    return [self addButton:title imageName:imageName target:target selector:selector isLeft:NO];
}
- (UIButton *)addButton:(NSString *)title imageName:(NSString *)imageName target:(id)target selector:(SEL)selector isLeft:(BOOL)isLeft{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, CMNaviBarStatusBarDefaultHeight, CMNaviBarViewsDefaultWidth, CMNaviBarDefaultHeight - CMNaviBarStatusBarDefaultHeight)];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (title) {
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:RGB(247, 120, 79) forState:UIControlStateNormal];
    }else{
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(0, CMNaviBarStatusBarDefaultHeight, CMNaviBarButtonDefaultWidth, CMNaviBarDefaultHeight - CMNaviBarStatusBarDefaultHeight);
    }
    
    if (isLeft) {
        NSMutableArray *mutableArray = [(self.leftViews?:@[]) mutableCopy];
        [mutableArray addObject:button];
        self.leftViews = mutableArray;
    }else{
        NSMutableArray *mutableArray = [(self.rightViews?:@[]) mutableCopy];
        [mutableArray addObject:button];
        self.rightViews = mutableArray;
    }
    return button;
}

#pragma mark - Init
- (UIView *)bottomLine{
    if (_bottomLine){
        return _bottomLine;
    }
    
    _bottomLine = [[UIView alloc] init];
    
    return _bottomLine;
}
- (UILabel *)titleLabel{
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor=RGB(50, 50, 50);
    return _titleLabel;
}
@end
