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
{
    UIImage *sourceImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

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
        self.bannerImage.clipsToBounds = YES;
        [Utils loadImageUrl:user.bannerImageUrl inImageView:self.bannerImage withAnimation:NO withSuccess:^{
            sourceImage = self.bannerImage.image;
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
            UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.3];
            self.bannerImage.image = [sourceImage applyBlurWithRadius:distance tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
            CGRect newFrame = self.bannerImage.frame;
            newFrame.origin.y = -distance;
            newFrame.size.height = 155 + distance;
            self.bannerImage.frame = newFrame;
        }
    }
}
@end
