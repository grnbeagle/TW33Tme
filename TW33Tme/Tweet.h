//
//  Tweet.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Tweet : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *originalUser;
@property (assign) int retweetCount;
@property (assign) int favouritesCount;
@property NSNumber *id;
@property BOOL retweeted;
@property BOOL favorited;
@property (nonatomic, strong) Tweet *retweetedStatus;

- (User *)author;
@end
