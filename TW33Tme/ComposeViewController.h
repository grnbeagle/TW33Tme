//
//  ComposeViewController.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) Tweet *replyTo;

@end
