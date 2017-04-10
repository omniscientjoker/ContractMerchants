//
//  UISearchTextField.m
//  ContractMerchants
//
//  Created by joker on 2017/4/10.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UISearchTextField.h"

@implementation UISearchTextField
- (UIView *)inputAccessoryView{
    return self.inputAccessoryViewInit;
}

- (UIToolbar *)inputAccessoryViewInit{
    if (self.customInputAccessoryView) {
        return self.customInputAccessoryView;
    }
    self.customInputAccessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.inputAccessoryView.width - 60, 0, 60, self.inputAccessoryView.height)];
    [completeButton setTitle:@"搜索" forState:UIControlStateNormal];
    [completeButton setTitleColor:COMMON_COLOR forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(beginSearched) forControlEvents:UIControlEventTouchUpInside];
    [self.customInputAccessoryView addSubview:completeButton];
    return self.customInputAccessoryView;
}

- (void)beginSearched{
    [self resignFirstResponder];
    if ([self.delegate conformsToProtocol:@protocol(UISearchTextFieldDelegate)] && [self.delegate respondsToSelector:@selector(beginSearched:)]) {
        [self.searchdelegate beginSearched:self.text];
    }
}
@end
