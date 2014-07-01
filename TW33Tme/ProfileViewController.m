//
//  ProfileViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/27/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"
#import "ProfileCell.h"
#import "TweetCell.h"
#import "StatsCell.h"
#import "Utils.h"

@interface ProfileViewController ()
{
    BOOL isAboutMe;
}
@property (strong, nonatomic) TwitterClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetCell *stubCell;
@property (strong, nonatomic) NSMutableArray *tweets;
@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        self.tweets = [[NSMutableArray alloc] init];
        self.client = [TwitterClient instance];
        self.icon = [UIImage imageNamed:@"ProfileIcon"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.user == nil) {
        self.user = [User currentUser];
        isAboutMe = YES;
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsCell" bundle:nil] forCellReuseIdentifier:@"StatsCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
}

-(void)viewDidAppear:(BOOL)animated {
    [self setupUI];

    [self fetchData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.tweets.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StatsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatsCell" forIndexPath:indexPath];
        cell.user = self.user;
        return cell;
    } else {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0) {
        [self configureCell:self.stubCell atIndexPath:indexPath];
        [self.stubCell layoutSubviews];

        CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

        return size.height + 1;
    } else {
        return 65; // height of stats row
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 150 : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // one for stat and another for tweets
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        cell.user = self.user;
        return cell;
    } else {
        return nil;
    }
}

- (void)fetchData {
    TwitterClient *client = [TwitterClient instance];
    [client timelineWithScreenName:self.user.screenName
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               NSError *error;
                               [self.tweets addObjectsFromArray:[MTLJSONAdapter
                                                                 modelsOfClass:[Tweet class]
                                                                 fromJSONArray:responseObject
                                                                 error:&error]];
                               if (error) {
                                   NSLog(@"[ProfileViewController fetchData] transform error: %@", error.description);
                               }
                               NSLog(@"[ProfileViewController fetchData] success row count: %d", self.tweets.count);
                               [self.tableView reloadData];
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               NSLog(@"[ProfileViewController fetchData] error: %@", error.description);
                           }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat distance = self.tableView.contentOffset.y;
    if (distance < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"distanceChanged" object:[NSNumber numberWithFloat:distance]];
    }
}

- (void)setupUI {
    if (!isAboutMe) {
        return; // add a hamburger icon for About Me only
    }
    UIImage *hamburgerIcon = [Utils imageWithImage:[UIImage imageNamed:@"HamburgerIcon"] scaledToSize:CGSizeMake(15, 15)];
    UIBarButtonItem *hamburgerButton = [[UIBarButtonItem alloc]
                                        initWithImage:hamburgerIcon
                                        landscapeImagePhone:nil
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(hamburgerIconClicked:)];

    self.navigationItem.leftBarButtonItem = hamburgerButton;
}

- (void)hamburgerIconClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hamburgerClicked" object:nil];
}

@end
