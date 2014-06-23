//
//  TweetViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/22/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "NSDate+DateTools.h"
#import "Utils.h"

@interface TweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesWordLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopConstraint;

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    self.title = @"Tweet";

    self.textLabel.text = self.tweet.text;
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.timeLabel.text = self.tweet.createdAt.timeAgoSinceNow;
    [Utils loadImageUrl:self.tweet.user.profileImageUrl inImageView:self.imageView withAnimation:YES];
    if (self.tweet.retweeted) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
    } else {
        [self.imageViewTopConstraint setConstant:8];
        [self.nameLabelTopConstraint setConstant:8];
        self.retweetLabel.hidden = YES;
    }

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    self.retweetCountLabel.text = [formatter stringFromNumber:self.tweet.retweetCount];
    self.retweetWordLabel.text = ([self.tweet.retweetCount doubleValue] > 2) ? @"RETWEETS" : @"RETWEET";
    if (self.tweet.favoritesCount == nil) {
        self.tweet.favoritesCount = [NSNumber numberWithInt:0];
    }
    self.favoritesCountLabel.text = [formatter stringFromNumber:self.tweet.favoritesCount];
    self.favoritesWordLabel.text = ([self.tweet.favoritesCount doubleValue] > 2) ? @"FAVORITES" : @"FAVORITE";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CALayer *layer = [self.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];

    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Reply"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(showCompose)];
    self.navigationItem.rightBarButtonItem = replyButton;
}

- (void)showCompose {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.replyTo = self.tweet;
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

@end
