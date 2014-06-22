//
//  User.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "User.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "TwitterClient.h"

@implementation User

static User *currentUser = nil;
static NSString *storeKey = @"current_user";

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name"
             };
}

+ (User *)currentUser {
    if (currentUser == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *archivedObject = [defaults objectForKey:storeKey];
        currentUser = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedObject forKey:storeKey];
    [defaults synchronize];
}

+ (void)populateCurrentUser {
    TwitterClient *client = [TwitterClient instance];
    [client verifyCredentialWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"[User populateCurrentUser] success");
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        [User setCurrentUser:user];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[User populateCurrentUser] failure: %@", error.description);
    }];
}

@end
