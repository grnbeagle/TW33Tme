//
//  ContainerViewController.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/27/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HamburgerMenuDelegate <NSObject>

- (void)toggleMenu;

@end

@interface ContainerViewController : UIViewController

@property (nonatomic, assign) id<HamburgerMenuDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarView;

@end
