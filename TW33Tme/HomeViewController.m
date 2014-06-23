//
//  HomeViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "HomeViewController.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "UIView+SuperView.h"

@interface HomeViewController ()

@property (strong, nonatomic) TwitterClient *client;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TweetCell *stubCell;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *tweets;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        self.tweets = [[NSMutableArray alloc] init];
        self.client = [TwitterClient instance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];

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
    [client homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        [self.tweets addObjectsFromArray:[MTLJSONAdapter
                                          modelsOfClass:[Tweet class]
                                          fromJSONArray:responseObject
                                          error:&error]];
        if (error) {
            NSLog(@"[HomeViewController fetchData] transform error: %@", error.description);
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HomeViewController fetchData] error: %@", error.description);
    }];
}

- (void)refresh:(id)sender {
    [(UIRefreshControl *)sender endRefreshing];
}

- (void)showCompose {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)setupUI {
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Compose"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(showCompose)];
    self.navigationItem.rightBarButtonItem = composeButton;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void) replyButtonClicked:(id)sender {
    TweetCell *cell = (TweetCell *)[sender findSuperViewWithClass:[TweetCell class]];
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];

    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    composeViewController.replyTo = self.tweets[indexPath.row];
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    [self presentViewController:navBar animated:YES completion:nil];

}
@end
