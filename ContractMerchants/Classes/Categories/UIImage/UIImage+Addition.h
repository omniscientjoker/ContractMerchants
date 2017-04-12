//
//  UIImage+Addition.h
//  ContractMerchants
//
//  Created by joker on 2017/4/12.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (Addition)
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

+ (UIImage *)imageWithURLNamed:(NSString *)name;
+ (UIImage *)cm_imageName:(NSString *)name;

+ (UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize fitScale:(BOOL)fitScal;

@end
