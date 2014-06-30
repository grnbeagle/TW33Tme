//
//  ContainerViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/27/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "ContainerViewController.h"
#import "Utils.h"

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarView;

@property (strong, nonatomic) UIViewController *currentViewController;

@end

@implementation ContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

    if (self.currentViewController != nil) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
    }
    self.currentViewController = content;
}

- (void) onSelectMenuItem:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"menuSelected"]) {
        [self displayContentController:(UIViewController *)notification.object];
    }
}

- (void)setupUI {
    // Cosmetics
    self.view.backgroundColor = [Utils getTwitterBlue];

    // Events and subviews
    [self displayContentController:self.viewControllers[0]];

    // Navigations
    UITabBarItem *homeButton = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"FavIcon"] tag:0];
    UITabBarItem *tabTwo = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];

    [self.tabBarView setItems:@[homeButton, tabTwo] animated:YES];

//    self.navigationBarView.translucent = NO;
//    self.navigationBarView.barTintColor = [Utils getTwitterBlue];
//    self.navigationBarView.tintColor = [UIColor whiteColor];

    UIImage *hamburgerIcon = [Utils imageWithImage:[UIImage imageNamed:@"HamburgerIcon"] scaledToSize:CGSizeMake(15, 15)];
    UIBarButtonItem *hamburgerButton = [[UIBarButtonItem alloc]
                                        initWithImage:hamburgerIcon
                                        landscapeImagePhone:nil
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(toggleMenu:)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Home"];
    navItem.leftBarButtonItem = hamburgerButton;
//    [self.navigationBarView pushNavigationItem:navItem animated:YES];
}
- (void)toggleMenu:(id)sender {
    [_delegate toggleMenu];
}
@end
