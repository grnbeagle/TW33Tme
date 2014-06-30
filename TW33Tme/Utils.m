//
//  Utils.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "Utils.h"
#import "UIImageView+AFNetworking.h"

@implementation Utils

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation {
    [Utils loadImageUrl:url inImageView:imageView withAnimation:enableAnimation withSuccess:nil];
}

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation withSuccess:(void (^) ())success {
    NSURL *urlObject = [NSURL URLWithString:url];
    __weak UIImageView *iv = imageView;

    [imageView
     setImageWithURLRequest:[NSURLRequest requestWithURL:urlObject]
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         BOOL isCached = (request == nil);
         if (!isCached && enableAnimation) {
             iv.alpha = 0.0;
             iv.image = image;
             [UIView animateWithDuration:0.5
                              animations:^{
                                  iv.alpha = 1.0;
                              }];
         } else {
             iv.image = image;
         }
         if (success) {
             success();
         }
     }
     failure:nil];
}

+ (UIColor *)getColorFrom:(CGFloat [3])rgb {
    return [UIColor colorWithRed:rgb[0]/255.0f green:rgb[1]/255.0f blue:rgb[2]/255.0f alpha:1];
}

+ (UIColor *)getTwitterBlue {
    CGFloat colors[3] ={85, 172, 238};
    return [Utils getColorFrom:colors];
}

+ (UIColor *)getTwitterGray {
    CGFloat colors[3] ={117, 135, 149};
    return [Utils getColorFrom:colors];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
