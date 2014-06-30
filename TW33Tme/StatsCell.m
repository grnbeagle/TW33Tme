//
//  StatsCell.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/29/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "StatsCell.h"

@interface StatsCell ()
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@end
@implementation StatsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%d", user.statusesCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%d", user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d", user.following];
}
@end
