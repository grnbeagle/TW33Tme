//
//  TweetCell.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (void)refreshView:(Tweet *)tweet;
@end
