//
//  UISearchTextField.h
//  ContractMerchants
//
//  Created by joker on 2017/4/10.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UISearchTextFieldDelegate;

@protocol UISearchTextFieldDelegate <NSObject>
@optional
- (void)beginSearched:(NSString *)str;
@end

@interface UISearchTextField : UITextField
@property (weak, readwrite, nonatomic) id<UISearchTextFieldDelegate> searchdelegate;
@property (nonatomic, strong) UIToolbar *customInputAccessoryView;
-(void)beginSearched;
@end
