//
//  PersonCell.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/29/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "PersonCell.h"
#import "Utils.h"

@interface PersonCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@end

@implementation PersonCell

@synthesize imageView;

- (void)awakeFromNib
{
    CALayer *layer = [self.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];
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
}
@end
