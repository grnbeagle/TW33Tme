//
//  ProfileCell.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/29/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileCell : UITableViewCell

@property (strong, nonatomic) User *user;
@property BOOL isSecondary; // Indicate it's the second page

@end
