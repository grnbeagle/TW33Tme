//
//  MenuViewController.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/28/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuItems;

@end
