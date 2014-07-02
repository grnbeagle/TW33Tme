//
//  User.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"

@implementation User

static User *currentUser = nil;
static NSString *storeKey = @"current_user";

- (NSString *)profileImageUrl {
    if (!_profileImageUrl) {
        _profileImageUrl = [self.thumbImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    }
    return _profileImageUrl;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"thumbImageUrl": @"profile_image_url",
             @"bannerImageUrl": @"profile_banner_url",
             @"screenName": @"screen_name",
             @"following": @"friends_count",
             @"followersCount": @"followers_count",
             @"friendsCount": @"friends_count",
             @"statusesCount": @"statuses_count",
             @"place": @"location"
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

+ (void)verifyCurrentUserWithSuccess:(void (^) ())success
                             failure:(void (^) (NSError *error))failure {
    TwitterClient *client = [TwitterClient instance];
    [client verifyCredentialWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"[User verifyCurrentUser] success");
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:responseObject error:nil];
        [User setCurrentUser:user];
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[User verifyCurrentUser] failure: %@", error.description);
        if (failure) {
            failure(error);
        }
    }];
}

@end
