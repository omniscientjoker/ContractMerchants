//
//  UIImage+Addition.m
//  ContractMerchants
//
//  Created by joker on 2017/4/12.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)
@dynamic imageHeight;
@dynamic imageWidth;

+ (UIImage *)imageWithURLNamed:(NSString *)name{
    return nil;
}


- (CGFloat)imageHeight{
    CGFloat height = self.size.height;
    return height;
}
- (CGFloat)imageWidth{
    CGFloat width = self.size.width;
    return width;
}

+ (UIImage *)cm_imageName:(NSString *)name{
    if (![name isKindOfClass:[NSString class]] || name == nil || [name isEqualToString:@""]) {
        return nil;
    }
    NSString *extension = [name pathExtension];
    
    if (extension == nil || [extension isEqualToString:@""]) {
        extension = @"png";
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:extension];
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [color set];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize fitScale:(BOOL)fitScale
{
    CGFloat scale = [UIScreen mainScreen].scale;
    if (fitScale) {
        return [self imageByScalingToSize:CGSizeMake(targetSize.width * scale, targetSize.height * scale)];
    } else {
        return [self imageByScalingToSize:targetSize];
    }
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (scaledHeight > targetHeight) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        if (targetWidth < scaledWidth) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil){
        NSLog(@"could not scale image");
    };
    return newImage;
}

- (UIImage *)imageByBigScalingToSize:(CGSize)targetSize{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        if(scaleFactor<1){
            scaledWidth  = width * scaleFactor;
            scaledHeight = height * scaleFactor;
        }else{
            scaledWidth=width;
            scaledHeight=height;
        }
    }
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight-1));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil){
        NSLog(@"could not scale image");
    };
    return newImage;
}

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    if((bitmapInfo == kCGImageAlphaLast) || (bitmapInfo == kCGImageAlphaNone))
        bitmapInfo = (CGBitmapInfo)kCGImageAlphaNoneSkipLast;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                bitmapInfo);
    CGContextConcatCTM(bitmap, transform);
    CGContextSetInterpolationQuality(bitmap, quality);
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    return newImage;
}

- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    return transform;
}


+ (UIImage *)hj_imageName:(NSString *)name{
    if (![name isKindOfClass:[NSString class]] || name == nil || [name isEqualToString:@""]) {
        return nil;
    }
    NSString *extension = [name pathExtension];
    if (extension == nil || [extension isEqualToString:@""]) {
        extension = @"png";
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[name stringByDeletingPathExtension] ofType:extension];
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (NSData *)compressToSize:(long)targetSize image:(UIImage *)image
{
    NSData *imgData = UIImageJPEGRepresentation(image, 1);
    return [self compressToSize:targetSize sourceSize:imgData.length image:image];
}


+ (NSData *)compressToSize:(long)targetSize sourceSize:(long)sourceSize image:(UIImage *)image
{
    NSLog(@"targetSize:%lu originSize%lu", targetSize, sourceSize);
    
    if (sourceSize <= targetSize) {
        NSData *data = UIImageJPEGRepresentation(image, 0.9);
        return data;
    }
    
    CGFloat compression = (CGFloat)targetSize / (CGFloat)sourceSize;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"compression:%f size:%lu", compression, (unsigned long)[imageData length]);
    
    return imageData;
}


+ (UIImage *)imageFromView:(UIView *)view
{
    return [self imageFromView:view inset:UIEdgeInsetsZero];
}

+ (UIImage *)imageFromView:(UIView *)view inset:(UIEdgeInsets)inset
{
    CGSize size = view.frame.size;
    size.width = size.width - inset.left;
    size.width = size.width - inset.right;
    size.height = size.height - inset.top;
    size.height = size.height - inset.bottom;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO,scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}
@end
