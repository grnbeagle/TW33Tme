//
//  ContainerViewController.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/27/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController <UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarView;
@property (strong, nonatomic) NSArray *viewControllers;

@end
