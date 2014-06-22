//
//  User.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface User : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;

+ (User *)currentUser;

+ (void)setCurrentUser:(User *)user;

+ (void)populateCurrentUser;

@end
