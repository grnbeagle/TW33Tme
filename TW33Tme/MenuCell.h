//
//  MenuCell.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/28/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (strong, nonatomic) UIViewController *menuItem;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (void)setMenuItem:(UIViewController *)menuItem;

@end
