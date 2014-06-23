//
//  ComposeViewController.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Utils.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];

    self.nameLabel.text = [[User currentUser] name];
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", [[User currentUser] screenName]];
    [Utils loadImageUrl:[[User currentUser] profileImageUrl] inImageView:self.imageView withAnimation:YES];

    self.textView.delegate = self;

    if (self.replyTo != nil) {
        self.textView.text = [NSString stringWithFormat:@"@%@", self.replyTo.user.screenName];
        self.placeholderLabel.hidden = YES;
        [self.textView becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save {
    [[TwitterClient instance]
     updateWithStatus:[self.textView text]
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"[ComposeViewController save] success");
         [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[ComposeViewController save] failure: %@", error.description);
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

- (void)setupUI {
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Cancel"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Save"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;

    // Round image view corners
    CALayer *layer = [self.imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];

}
@end
