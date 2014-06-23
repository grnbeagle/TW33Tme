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
@property (nonatomic, strong) NSString *thumbImageUrl;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *screenName;

+ (User *)currentUser;

+ (void)setCurrentUser:(User *)user;

//+ (void)populateCurrentUser;

+ (void)verifyCurrentUserWithSuccess:(void (^) ())success
                             failure:(void (^) (NSError *error))failure;
@end
