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
    self.nameLabel.text = [self.tweet author].name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", [self.tweet author].screenName];
    self.screenNameLabel.textColor = [Utils getTwitterGray];
    self.timeLabel.text = self.tweet.createdAt.timeAgoSinceNow;
    self.timeLabel.textColor = [Utils getTwitterGray];
    [Utils loadImageUrl:[self.tweet author].profileImageUrl inImageView:self.imageView withAnimation:YES];
    if (self.tweet.retweeted) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.user.name];
        self.retweetLabel.textColor = [Utils getTwitterGray];
    } else {
        [self.imageViewTopConstraint setConstant:8];
        [self.nameLabelTopConstraint setConstant:8];
        self.retweetLabel.hidden = YES;
    }

    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetWordLabel.text = (self.tweet.retweetCount > 2) ? @"RETWEETS" : @"RETWEET";
    self.retweetWordLabel.textColor = [Utils getTwitterGray];

    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoritesCount];
    self.favoritesWordLabel.text = (self.tweet.favoritesCount > 2) ? @"FAVORITES" : @"FAVORITE";
    self.favoritesWordLabel.textColor = [Utils getTwitterGray];
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
