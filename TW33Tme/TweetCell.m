//
//  TweetCell.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "TweetCell.h"
#import "Utils.h"
#import "NSDate+DateTools.h"

@implementation TweetCell

@synthesize textLabel;
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

- (void)setTweet:(Tweet *)tweet {
    self.textLabel.text = tweet.text;
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    self.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
    [Utils loadImageUrl:tweet.user.profileImageUrl inImageView:self.imageView withAnimation:YES];
}
@end
