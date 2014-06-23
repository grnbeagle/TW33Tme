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
@property NSNumber *retweetCount;
@property NSNumber *favoritesCount;
@property NSNumber *id;
@property BOOL retweeted;

@end
