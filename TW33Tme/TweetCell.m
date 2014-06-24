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

@property (strong, nonatomic) UILabel *retweetCountLabel;
@property (strong, nonatomic) UILabel *favCountLabel;
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
    UIImage *replyIcon = [UIImage imageNamed:@"ReplyIcon"];
    UIImage *retweetIcon = [UIImage imageNamed:@"RetweetIcon"];
    UIImage *favIcon = [UIImage imageNamed:@"FavIcon"];

    self.textLabel.text = tweet.text;
    self.nameLabel.text = [tweet author].name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",[tweet author].screenName];
    self.screenNameLabel.textColor = [Utils getTwitterGray];
    self.timeLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
    self.timeLabel.textColor = [Utils getTwitterGray];
    [Utils loadImageUrl:[tweet author].profileImageUrl inImageView:self.imageView withAnimation:YES];

    if (tweet.retweeted) {
        if (!self.retweetLabel) {
            self.retweetLabel.text = [NSString stringWithFormat:@"       %@ retweeted", tweet.user.name];
            [self.retweetLabel setFrame:CGRectMake(0, 0, 200, 20)];
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            [icon setImage:retweetIcon];
            [self.retweetLabel addSubview:icon];
            self.retweetLabel.textColor = [Utils getTwitterGray];
        }
    } else {
        [self.imageViewTopSpace setConstant:8];
        [self.viewTopSpace setConstant:8];
        self.retweetLabel.hidden = YES;
    }

    // Reply button
    UIImageView *replyIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 14, 10)];
    [replyIconView setImage:replyIcon];
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton addSubview:replyIconView];

    if (!self.retweetCountLabel) {
        // Retweet button
        UIImageView *retweetIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 16, 10)];
        [retweetIconView setImage:retweetIcon];

        self.retweetCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 80, 20)];
        self.retweetCountLabel.textColor = [Utils getTwitterGray];
        [self.retweetCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
        [self.retweetButton addSubview:self.retweetCountLabel];
        [self.retweetButton addSubview:retweetIconView];
        if (tweet.retweeted) {
            self.retweetButton.enabled = NO;
        }
        [self.retweetCountLabel setText:[NSString stringWithFormat:@"%d", tweet.retweetCount]];
    }

    if (!self.favCountLabel) {
        // Favorite button
        UIImageView *favIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 14, 12)];
        [favIconView setImage:favIcon];

        self.favCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 80, 20)];
        self.favCountLabel.textColor = [Utils getTwitterGray];
        [self.favCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [self.favoriteButton setTitle:@"" forState:UIControlStateNormal];
        [self.favoriteButton addSubview:self.favCountLabel];
        [self.favoriteButton addSubview:favIconView];
        if (tweet.favorited) {
            self.favoriteButton.enabled = NO;
        }
        [self.favCountLabel setText:[NSString stringWithFormat:@"%d", tweet.favoritesCount]];
    }
}

- (void)refreshCount {
    [self.retweetCountLabel setText:[NSString stringWithFormat:@"%d", self.tweet.retweetCount]];
    [self.favCountLabel setText:[NSString stringWithFormat:@"%d", self.tweet.favoritesCount]];
}
@end
