//
//  ProfileCell.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/29/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "ProfileCell.h"
#import "Utils.h"
#import "UIImage+ImageEffects.h"
#import "math.h"
#import "GPUImage.h"

@interface ProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@property (strong, nonatomic) UIImageView *bannerImage;
@end

@implementation ProfileCell

@synthesize imageView;

- (void)awakeFromNib
{
    CALayer *layer = [self.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onScrollDistanceChanged:)
                                                 name:@"distanceChanged"
                                               object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    [Utils loadImageUrl:user.profileImageUrl inImageView:self.imageView withAnimation:NO];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];

    if (user.bannerImageUrl != nil && self.bannerImage == nil) {
        self.bannerImage = [[UIImageView alloc] init];
        self.bannerImage.frame = CGRectMake(0, 0, self.frame.size.width, 300);
        self.bannerImage.contentMode = UIViewContentModeScaleAspectFill;

        [Utils loadImageUrl:user.bannerImageUrl inImageView:self.bannerImage withAnimation:NO withSuccess:^{

            UIImage *blurredBackground = [self.bannerImage.image applyBlurWithRadius:15 tintColor:nil saturationDeltaFactor:1.8 maskImage:nil];
            self.bannerImage.image = blurredBackground;

            blurredBackground = [self.bannerImage.image applyBlurWithRadius:15 tintColor:nil saturationDeltaFactor:1.8 maskImage:nil];
            self.bannerImage.image = blurredBackground;

//            UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.3];
//            UIImage *blurredBackground = [bannerImage.image applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1.8 maskImage:nil];
//
//            bannerImage.image = blurredBackground;
        }];

        [self addSubview:self.bannerImage];
        [self sendSubviewToBack:self.bannerImage];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)onScrollDistanceChanged:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"distanceChanged"]) {
        if (self.bannerImage) {
            NSNumber *distanceNumber = [notification valueForKey:@"object"];
            CGFloat distance = abs([distanceNumber floatValue]);
            // UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.3];
            NSLog(@"--> %f", distance);

            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *blurredBackground = [self.bannerImage.image applyBlurWithRadius:15 tintColor:nil saturationDeltaFactor:1.8 maskImage:nil];
                self.bannerImage.image = blurredBackground;
            });
        }
    }
}
@end
