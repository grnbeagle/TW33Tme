//
//  TweetCell.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "TweetCell.h"
#import "ComposeViewController.h"
#import "Utils.h"
#import "NSDate+DateTools.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopSpace;



@end

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
    self.screenNameLabel.textColor = [Utils getTwitterGray];
    self.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
    self.timeLabel.textColor = [Utils getTwitterGray];
    [Utils loadImageUrl:tweet.user.profileImageUrl inImageView:self.imageView withAnimation:YES];
    if (tweet.retweeted) {
        self.retweetLabel.text = [NSString stringWithFormat:@"       %@ retweeted", tweet.user.name];
        [self.retweetLabel setFrame:CGRectMake(0, 0, 200, 20)];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [icon setImage:[UIImage imageNamed:@"RetweetIcon"]];
        [self.retweetLabel addSubview:icon];
        self.retweetLabel.textColor = [Utils getTwitterGray];
    } else {
        [self.imageViewTopSpace setConstant:8];
        [self.viewTopSpace setConstant:8];
        self.retweetLabel.hidden = YES;
    }
}

@end
