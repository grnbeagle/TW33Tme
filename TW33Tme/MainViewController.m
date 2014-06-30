//
//  MainViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/29/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) ContainerViewController *containerViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, assign) BOOL showingMenu;
@property (nonatomic, strong) NSArray *viewControllers;
@end

@implementation MainViewController
{
    UINavigationController *timelineViewController;
    ProfileViewController *profileViewController;

    CGPoint panStartCoordinate;
    NSString *direction;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        timelineViewController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        profileViewController = [[ProfileViewController alloc] init];

        self.viewControllers = @[timelineViewController, profileViewController];

        self.containerViewController = [[ContainerViewController alloc] init];
        self.containerViewController.delegate = self;
        self.containerViewController.viewControllers = self.viewControllers;

        [self.view addSubview:self.containerViewController.view];
        [self addChildViewController:_containerViewController];
        [_containerViewController didMoveToParentViewController:self];

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

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPan:)];
    panGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *)getMenu {
    if (_menuViewController == nil) {
        self.menuViewController = [[MenuViewController alloc] init];
        self.menuViewController.menuItems = self.viewControllers;

        [self.view addSubview:self.menuViewController.view];
        [self addChildViewController:_menuViewController];
        [_menuViewController didMoveToParentViewController:self];
        _menuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self showContainerViewWithShadow:YES withOffset:-2];

    }
    UIView *view = self.menuViewController.view;
    return view;
}

- (void)toggleMenu {
    if (self.showingMenu) {
        [self animateContainerSlideBy:0 withCallback:^{
            self.showingMenu = NO;
        }];
    } else {
        UIView *menuView = [self getMenu];
        [self.view sendSubviewToBack:menuView];
        [self animateContainerSlideBy:(self.view.frame.size.width - 80) withCallback:^{
            self.showingMenu = YES;
        }];
    }
}

- (void)animateContainerSlideBy:(CGFloat)positionX withCallback:(void (^) ())callback {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn)
                     animations:^{
                         CGRect newFrame = CGRectMake(positionX, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _containerViewController.view.frame = newFrame;
                     }
                     completion:^(BOOL finished) {
                         if (callback) {
                             callback();
                         }
                     }];
}

- (void)showContainerViewWithShadow:(BOOL)value withOffset:(double)offset {
	[_containerViewController.view.layer setCornerRadius:3];
	[_containerViewController.view.layer setShadowColor:[UIColor grayColor].CGColor];
	[_containerViewController.view.layer setShadowOpacity:0.8];
	[_containerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
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
                UIView *menuView = [self getMenu];
                [self.view sendSubviewToBack:menuView];

            } else {
                direction = @"L";
                distance = 0;
            }
            CGRect movedFrame = _containerViewController.view.frame;
            movedFrame.origin.x = distance;
            _containerViewController.view.frame = movedFrame;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if ([direction isEqualToString:@"R"]) {
                [self animateContainerSlideBy:(self.view.frame.size.width - 80) withCallback:^{
                    self.showingMenu = YES;
                }];
            } else {
                [self animateContainerSlideBy:0 withCallback:^{
                    self.showingMenu = NO;
                }];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}

- (void) onSelectMenuItem:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"menuSelected"]) {
        [self animateContainerSlideBy:0 withCallback:^{
            self.showingMenu = NO;
        }];
    }
}

@end
