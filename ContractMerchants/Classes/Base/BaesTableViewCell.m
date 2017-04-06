//
//  BaesTableViewCell.m
//  IOSFrame
//
//  Created by joker on 16/10/12.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "BaesTableViewCell.h"
@interface BaesTableViewCell ()
@property  (nonatomic , assign) UInt64 selectOrHightTime;
@end
@implementation BaesTableViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0xd9/255.0f green:0xd9/255.0f blue:0xd9/255.0f alpha:1.0f];
    }else{
        [self controlResetBackgroundColor];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        NSDate *datenow = [NSDate date];
        long time = [datenow timeIntervalSince1970] * 1000;
        self.backgroundColor = [UIColor colorWithRed:0xd9/255.0f green:0xd9/255.0f blue:0xd9/255.0f alpha:1.0f];
        self.selectOrHightTime = time;
    }else{
        [self controlResetBackgroundColor];
    }
}
- (void)controlResetBackgroundColor{
    NSDate *datenow = [NSDate date];
    long time = [datenow timeIntervalSince1970] * 1000;
    if (time - self.selectOrHightTime > 100) {
        [self resetBackgrounColor];
    }else{
        [self performSelector:@selector(resetBackgrounColor) withObject:nil afterDelay:0.1];
    }
}
- (void)resetBackgrounColor{
    self.backgroundColor = [UIColor whiteColor];
}
@end
