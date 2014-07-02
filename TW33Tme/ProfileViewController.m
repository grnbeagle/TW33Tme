//
//  ProfileViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/27/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetViewController.h"
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
    CGPoint panStartCoordinate;
    NSString *direction;
}
@property (strong, nonatomic) TwitterClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetCell *stubCell;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    TweetViewController *tweetViewController = [[TweetViewController alloc] init];
    tweetViewController.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tweetViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 155)];
        container.clipsToBounds = NO;

        // Create first page cell
        ProfileCell *firstPage = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        firstPage.user = self.user;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 155)];
        //self.scrollView = [[UIScrollView alloc] init];
        CGRect firstFrame;
        firstFrame.origin.x = 0;
        firstFrame.origin.y = 0;
        firstFrame.size = self.scrollView.frame.size;

        firstPage.frame = firstFrame;
        [self.scrollView addSubview:firstPage];

        // Create second page cell
        ProfileCell *secondPage = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        secondPage.isSecondary = YES;
        secondPage.user = self.user;
        CGRect secondFrame;
        secondFrame.origin.x = self.view.frame.size.width;
        secondFrame.origin.y = 0;
        secondFrame.size = self.scrollView.frame.size;
        secondPage.frame = secondFrame;
        [self.scrollView addSubview:secondPage];

        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height)];

        // We need to touch it
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
        panGesture.cancelsTouchesInView = NO;
        [self.scrollView addGestureRecognizer:panGesture];

        [container addSubview:self.scrollView];
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 115, self.view.frame.size.width, 50)];
        [self.pageControl setNumberOfPages:2];
        [container addSubview:self.pageControl];
        [self.pageControl addTarget:self action:@selector(onPageControlClicked:) forControlEvents:UIControlEventValueChanged];

        return container;
    } else {
        return nil;
    }
}

- (IBAction)onPan:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            panStartCoordinate = point;
            break;
        case UIGestureRecognizerStateChanged: {
            float distance = point.x - panStartCoordinate.x;
            if (distance > 0) { // drag right
                direction = @"R";
            } else {
                direction = @"L";
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if ([direction isEqualToString:@"R"]) {
                self.pageControl.currentPage -= 1;
            } else {
                self.pageControl.currentPage += 1;
            }
            [self changePage];
            break;
        }
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

- (void)onPageControlClicked:(id)sender {
    [self changePage];
}

- (void)changePage {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
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
