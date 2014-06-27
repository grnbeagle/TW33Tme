//
//  ContainerViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/27/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "ContainerViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "Utils.h"

@interface ContainerViewController ()
{
    HomeViewController *homeViewController;
    ProfileViewController *profileViewController;
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) NSArray *viewControllers;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarView;
@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        homeViewController = [[HomeViewController alloc] init];
        profileViewController = [[ProfileViewController alloc] init];

        self.viewControllers = @[homeViewController, profileViewController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [Utils getTwitterBlue];
//    UIView *homeView = homeViewController.view;
//    UIView *profileView = profileViewController.view;

    [self displayContentController:homeViewController];
    //[self.containerView addSubview:profileView];
    //[self.containerView addSubview:homeView];

    UITabBarItem *homeButton = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"FavIcon"] tag:0];
    UITabBarItem *tabTwo = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];

    [self.tabBarView setItems:@[homeButton, tabTwo] animated:YES];

    self.navigationBarView.translucent = NO;
    self.navigationBarView.barTintColor = [Utils getTwitterBlue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

@end
