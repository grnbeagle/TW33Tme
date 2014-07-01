//
//  MenuCell.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/28/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "MenuCell.h"
#import "Utils.h"

@implementation MenuCell

@synthesize imageView, textLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenuItem:(UIViewController *)menuItem {
    [self.textLabel setText:menuItem.title];
    if ([menuItem respondsToSelector:@selector(icon)]) {
        [self.imageView setImage:[menuItem performSelector:@selector(icon)]];
        self.imageView.alpha = 0.5;
    }
}

@end
