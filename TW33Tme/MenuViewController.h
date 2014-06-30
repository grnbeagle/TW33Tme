//
//  MenuViewController.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/28/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol MenuViewControllerDelegate <NSObject>
//
//@end

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, assign) id<MenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *menuItems;

@end
