//
//  TweetViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/22/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "TweetViewController.h"
#import "TwitterClient.h"
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
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopConstraint;

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
}

-(void)viewDidAppear:(BOOL)animated {

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

        [self.imageViewTopConstraint setConstant:30];
        [self.nameLabelTopConstraint setConstant:39];
    } else {
        [self.imageViewTopConstraint setConstant:8];
        [self.nameLabelTopConstraint setConstant:8];
        self.retweetLabel.hidden = YES;
    }

    [self updateCount];

    // Set up buttons
    UIImage *replyIcon = [UIImage imageNamed:@"ReplyIcon"];
    UIImage *retweetIcon = [UIImage imageNamed:@"RetweetIcon"];
    UIImage *favIcon = [UIImage imageNamed:@"FavIcon"];

    // Reply button
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton setBackgroundImage:replyIcon forState:UIControlStateNormal];
    [self.replyButton addTarget:self action:@selector(showCompose:) forControlEvents:UIControlEventTouchDown];

    // Retweet button
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setBackgroundImage:retweetIcon forState:UIControlStateNormal];
    [self.retweetButton addTarget:self action:@selector(retweet:) forControlEvents:UIControlEventTouchDown];

    // Favorite button
    [self.favoriteButton setTitle:@"" forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:favIcon forState:UIControlStateNormal];
    [self.favoriteButton addTarget:self action:@selector(favoriteTweet:) forControlEvents:UIControlEventTouchDown];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateCount {
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetWordLabel.text = (self.tweet.retweetCount > 2) ? @"RETWEETS" : @"RETWEET";
    self.retweetWordLabel.textColor = [Utils getTwitterGray];

    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favouritesCount];
    self.favoritesWordLabel.text = (self.tweet.favouritesCount > 2) ? @"FAVORITES" : @"FAVORITE";
    self.favoritesWordLabel.textColor = [Utils getTwitterGray];

    if (self.tweet.retweeted) {
        [self.retweetButton setAlpha:0.5];
    } else {
        [self.retweetButton setAlpha:1];
    }
    if (self.tweet.favorited) {
        [self.favoriteButton setAlpha:0.5];
    } else {
        [self.favoriteButton setAlpha:1];
    }
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
                                    action:@selector(showCompose:)];
    self.navigationItem.rightBarButtonItem = replyButton;
}

- (void)showCompose:(id)sender {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.replyTo = self.tweet;
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)retweet:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    if (self.tweet.retweeted) {
        NSNumber *retweetId = self.tweet.id;
        if (self.tweet.retweetedStatus) {
            retweetId = self.tweet.retweetedStatus.id;
        }
        [client destroyWithId:retweetId
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"[TweetViewController retweet destroy] success");
                          self.tweet.retweeted = NO;
                          self.tweet.retweetCount -= 1;
                          [self updateCount];
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"[TweetViewController retweet destroy] failure: %@", error.description);
                      }];
    } else {
        [client retweetWithId:self.tweet.id
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"[TweetViewController retweet] success");
                          self.tweet.retweeted = YES;
                          self.tweet.retweetCount += 1;
                          self.tweet.retweetedStatus = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:nil];
                          [self updateCount];
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"[TweetViewController retweet] failure: %@", error.description);
                      }];
    }
}
- (void)favoriteTweet:(id)sender {
    TwitterClient *client = [TwitterClient instance];
    if (self.tweet.favorited) {
        [client removeFavoriteWithId:self.tweet.id
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"[TweetViewController unfavorite] success");
                           self.tweet.favorited = NO;
                           self.tweet.favouritesCount -= 1;
                           [self updateCount];
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"[TweetViewController unfavorite] failure: %@", error.description);
                       }];
    } else {
        [client favoriteWithId:self.tweet.id
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"[TweetViewController favorite] success");
                           self.tweet.favorited = YES;
                           self.tweet.favouritesCount += 1;
                           [self updateCount];
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"[TweetViewController favorite] failure: %@", error.description);
                       }];
    }
}

@end
