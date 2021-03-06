//
//  HomeViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "ContainerViewController.h"
#import "HomeViewController.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "Utils.h"
#import "UIView+SuperView.h"

@interface HomeViewController ()

@property (strong, nonatomic) TwitterClient *client;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetCell *stubCell;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *tweets;

@property NSNumber *sinceId; // The most recent id for pull to refresh
@end

@implementation HomeViewController

- (id)initWithMode:(ViewMode)aMode {
    self = [super init];
    self.mode = aMode;
    if (self) {
        self.title = (self.mode == timelineView) ? @"Timeline" : @"Mentions";
        self.tweets = [[NSMutableArray alloc] init];
        self.client = [TwitterClient instance];
        self.icon = [UIImage imageNamed: (self.mode == timelineView) ? @"TimelineIcon" : @"MentionIcon"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    [self setupUI];

    [self fetchData];
}

- (TweetCell *)stubCell {
    if (!_stubCell) {
        _stubCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    }
    return _stubCell;
}

- (void)configureCell:(TweetCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.tweet = self.tweets[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.stubCell atIndexPath:indexPath];
    [self.stubCell layoutSubviews];

    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    return size.height + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    [cell.replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [cell.retweetButton addTarget:self action:@selector(retweetButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [cell.favoriteButton addTarget:self action:@selector(favoriteButtonClicked:) forControlEvents:UIControlEventTouchDown];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageTap:)];
    [cell.imageView addGestureRecognizer:tapGestureRecognizer];
    cell.imageView.tag = indexPath.row;

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    TweetViewController *tweetViewController = [[TweetViewController alloc] init];
    tweetViewController.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tweetViewController animated:YES];
}

- (void)fetchData {
    TwitterClient *client = [TwitterClient instance];
    NSDictionary *params;
    if ([self.sinceId doubleValue] > 0) {
        params = @{ @"since_id": self.sinceId };
    }
    if (self.mode == mentionsView) {
        [client mentionsWithParams:params
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   [self processResponse:responseObject withParams:params];
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"[HomeViewController fetchData] error: %@", error.description);
                               }];
    } else {
        [client homeTimelineWithParams:params
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   [self processResponse:responseObject withParams:params];
                               }
                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"[HomeViewController fetchData] error: %@", error.description);
                               }];
    }
}

- (void)processResponse:(id)responseObject withParams:(NSDictionary *)params {
    NSError *error;
    if (params) {
        NSArray *newTweets = [MTLJSONAdapter
                              modelsOfClass:[Tweet class]
                              fromJSONArray:responseObject
                              error:&error];
        for (Tweet *tweet in newTweets) {
            [self.tweets insertObject:tweet atIndex:0];
        }
    } else {
        [self.tweets addObjectsFromArray:[MTLJSONAdapter
                                          modelsOfClass:[Tweet class]
                                          fromJSONArray:responseObject
                                          error:&error]];
    }
    if (error) {
        NSLog(@"[HomeViewController fetchData] transform error: %@", error.description);
    }
    NSLog(@"[HomeViewController fetchData] success row count: %d", self.tweets.count);
    if (self.tweets.count > 0) {
        self.sinceId = ((Tweet *)self.tweets[0]).id;
    }
    [self.tableView reloadData];
}
- (void)refresh:(id)sender {
    [self fetchData];
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)showCompose {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)setupUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    UIImage *composeIcon = [Utils imageWithImage:[UIImage imageNamed:@"ComposeIcon"] scaledToSize:CGSizeMake(15, 15)];
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                      initWithImage:composeIcon
                                      landscapeImagePhone:nil
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(showCompose)];

    UIImage *hamburgerIcon = [Utils imageWithImage:[UIImage imageNamed:@"HamburgerIcon"] scaledToSize:CGSizeMake(15, 15)];
    UIBarButtonItem *hamburgerButton = [[UIBarButtonItem alloc]
                                        initWithImage:hamburgerIcon
                                        landscapeImagePhone:nil
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(hamburgerIconClicked:)];

    self.navigationItem.rightBarButtonItem = composeButton;
    self.navigationItem.leftBarButtonItem = hamburgerButton;

    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

- (void)hamburgerIconClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerClicked" object:nil];
}

- (void)replyButtonClicked:(id)sender {
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];

    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.replyTo = self.tweets[indexPath.row];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)retweetButtonClicked:(id)sender {
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];

    Tweet *currentTweet = self.tweets[indexPath.row];
    TwitterClient *client = [TwitterClient instance];
    if (currentTweet.retweeted) {
        NSNumber *retweetId = currentTweet.id;
        if (currentTweet.retweetedStatus) {
            retweetId = currentTweet.retweetedStatus.id;
        }
        [client destroyWithId:retweetId
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"[HomeViewController retweet destroy] success");
                          currentTweet.retweeted = NO;
                          currentTweet.retweetCount -= 1;
                          [cell refreshView:currentTweet];
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"[HomeViewController retweet destroy] failure: %@", error.description);
                      }];
    } else {
        [client retweetWithId:currentTweet.id
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSLog(@"[HomeViewController retweet] success");
                          currentTweet.retweeted = YES;
                          currentTweet.retweetCount += 1;
                          currentTweet.retweetedStatus = [MTLJSONAdapter modelOfClass:Tweet.class fromJSONDictionary:responseObject error:nil];
                          [cell refreshView:currentTweet];
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          NSLog(@"[HomeViewController retweet] failure: %@", error.description);
                      }];
    }
}
- (void)favoriteButtonClicked:(id)sender {
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];

    Tweet *currentTweet = self.tweets[indexPath.row];
    TwitterClient *client = [TwitterClient instance];
    if (currentTweet.favorited) {
        [client removeFavoriteWithId:currentTweet.id
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"[HomeViewController unfavorite] success");
                           currentTweet.favorited = NO;
                           currentTweet.favouritesCount -= 1;
                           [cell refreshView:currentTweet];
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"[HomeViewController unfavorite] failure: %@", error.description);
                       }];
    } else {
        [client favoriteWithId:currentTweet.id
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSLog(@"[HomeViewController favorite] success");
                           currentTweet.favorited = YES;
                           currentTweet.favouritesCount += 1;
                           [cell refreshView:currentTweet];
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                           NSLog(@"[HomeViewController favorite] failure: %@", error.description);
                       }];
    }
}

- (void)onUserImageTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    Tweet *currentTweet = self.tweets[tapGestureRecognizer.view.tag];
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = currentTweet.user;
    [self.navigationController pushViewController:profileViewController animated:YES];
}
@end
