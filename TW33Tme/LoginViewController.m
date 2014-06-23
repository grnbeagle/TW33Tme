//
//  LoginViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/20/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "TwitterClient.h"
#import "User.h"

@interface LoginViewController ()

- (IBAction)onLoginButton:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([User currentUser] != nil) {
        [User verifyCurrentUserWithSuccess:^{
            HomeViewController *homeViewController = [[HomeViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            [self presentViewController:navigationController animated:YES completion:nil];
        } failure:^(NSError *error) {
            // Saved access token not valid; login again
            [[TwitterClient instance] startLogin];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginButton:(id)sender {
    [[TwitterClient instance] startLogin];
}
@end
