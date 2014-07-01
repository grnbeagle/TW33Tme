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
@property (strong, nonatomic) UINavigationController *navigationController;

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
}

-(UINavigationController*) navigationController {
    if(_navigationController == nil) {
        _navigationController = [[UINavigationController alloc] init];
    }
    return _navigationController;
}

- (void) displayContentController: (UIViewController*) content {
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    [content didMoveToParentViewController:self];
}

- (void) onSelectMenuItem:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"menuSelected"]) {
        [self.navigationController setViewControllers:@[(UIViewController *)notification.object]];
        [self displayContentController:self.navigationController];
    }
}

- (void)setupUI {
    // Cosmetics
    self.view.backgroundColor = [Utils getTwitterBlue];

    // Events and subviews
    [self.navigationController setViewControllers:@[self.viewControllers[0]]];
    [self displayContentController:self.navigationController];

    // Navigations

    UITabBarItem *home = [[UITabBarItem alloc] initWithTitle:@"Timeline" image:[Utils imageWithImage:[UIImage imageNamed:@"TimelineIcon"] scaledToSize:CGSizeMake(20, 20)] tag:0];
    UITabBarItem *profile = [[UITabBarItem alloc] initWithTitle:@"About Me" image:[Utils imageWithImage:[UIImage imageNamed:@"ProfileIcon"] scaledToSize:CGSizeMake(20, 20)] tag:1];
    self.tabBarView.tintColor = [Utils getTwitterGray];
    [self.tabBarView setItems:@[home, profile] animated:YES];
    self.tabBarView.delegate = self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self.navigationController setViewControllers:@[self.viewControllers[item.tag]]];
    [self displayContentController:self.navigationController];
}
@end
