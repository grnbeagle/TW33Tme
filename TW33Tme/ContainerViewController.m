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

    CGPoint panStartCoordinate;
    CGPoint contentCoordinate;
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarView;

@property (strong, nonatomic) NSArray *viewControllers;
@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        homeViewController = [[HomeViewController alloc] init];
        profileViewController = [[ProfileViewController alloc] init];

        self.viewControllers = @[homeViewController, profileViewController];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSelectMenuItem:)
                                                     name:@"menuSelected"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
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

- (void) onSelectMenuItem:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"menuSelected"]) {
        NSString *controllerName = ((NSDictionary *)notification.object)[@"controller"];
        for(UIView *aView in self.view.subviews){
            if([aView isKindOfClass:[NSClassFromString(controllerName) class]]){
                [self.view bringSubviewToFront:aView];
            }
        }
    }
}

- (void)setupUI {
    // Cosmetics
    self.view.backgroundColor = [Utils getTwitterBlue];

    // Events and subviews
    [self displayContentController:homeViewController];

    // Navigations
    UITabBarItem *homeButton = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"FavIcon"] tag:0];
    UITabBarItem *tabTwo = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];

    [self.tabBarView setItems:@[homeButton, tabTwo] animated:YES];

    self.navigationBarView.translucent = NO;
    self.navigationBarView.barTintColor = [Utils getTwitterBlue];

    UIImage *hamburgerIcon = [Utils imageWithImage:[UIImage imageNamed:@"HamburgerIcon"] scaledToSize:CGSizeMake(15, 15)];
    UIBarButtonItem *hamburgerButton = [[UIBarButtonItem alloc]
                                        initWithImage:hamburgerIcon
                                        landscapeImagePhone:nil
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(toggleMenu:)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Hi"];
    navItem.leftBarButtonItem = hamburgerButton;
    [self.navigationBarView pushNavigationItem:navItem animated:YES];
}
- (void)toggleMenu:(id)sender {
    [_delegate toggleMenu];
}
@end
