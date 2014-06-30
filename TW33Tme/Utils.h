//
//  Utils.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation;

+ (void)loadImageUrl:(NSString *)url inImageView:(UIImageView *)imageView withAnimation:(BOOL)enableAnimation withSuccess:(void (^) ())success;

+ (UIColor *)getColorFrom:(CGFloat [3])rgb;

+ (UIColor *)getTwitterBlue;

+ (UIColor *)getTwitterGray;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
