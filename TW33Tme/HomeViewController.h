//
//  HomeViewController.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    timelineView,
    mentionsView
} ViewMode;

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property ViewMode mode;
@property (strong, nonatomic) UIImage *icon;

-(id)initWithMode:(ViewMode)aMode;

@end
