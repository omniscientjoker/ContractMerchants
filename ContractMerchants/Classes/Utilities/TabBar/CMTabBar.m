//
//  CMTabBar.m
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "CMTabBar.h"
#import "CMTabBarButton.h"

@interface CMTabBar ()
/*之前选中的按钮*/
@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation CMTabBar
- (void)addButtonWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage Title:(NSString *)title{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [btn setAdjustsImageWhenHighlighted:NO];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:RGB(146, 145, 147) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(249, 101, 32) forState:UIControlStateSelected];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 13, (btn.size.width-50)/2);
    btn.titleEdgeInsets = UIEdgeInsetsMake(34, -33, 0, 0);
    [self addSubview:btn];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

/**专门用来布局子视图, 别忘了调用super方法*/
- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.tag = i;
        CGFloat x = i * self.bounds.size.width / count;
        CGFloat y = 0;
        CGFloat width = self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height;
        btn.frame = CGRectMake(x, y, width, height);
        if (i == 0 ){
            btn.selected = YES;
            self.selectedBtn = btn;
        }
    }
}

/*自定义TabBar的按钮点击事件*/
- (void)clickBtn:(UIButton *)button {
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag to:button.tag];
    }
}

@end
