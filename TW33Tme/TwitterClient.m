//
//  TwitterClient.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/20/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//
//  oAuth steps:
//  1. startLogin: get a request token
//  2. startLogin callback: open the authorize URL on mobile Safari
//  3. finishLogin: get the access token
//  4. finishLogin callback: save the access token

#import "TwitterClient.h"
#import "User.h"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;

    // TODO: move keys
    dispatch_once(&onceToken, ^{
//        instance = [[TwitterClient alloc]
//                    initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
//                    consumerKey:@"oktJjqH6ZF1cFT6AGSB532une"
//                    consumerSecret:@"pozqvOv9OXe8Gb8jqvKtzzBAgglGIkTtsbHGWEko47xQktIl2n"];
        instance = [[TwitterClient alloc]
                    initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
                    consumerKey:@"oktJjqH6ZF1cFT6AGSB532une"
                    consumerSecret:@"pozqvOv9OXe8Gb8jqvKtzzBAgglGIkTtsbHGWEko47xQktIl2n"];
    });

    return instance;
}

- (void)startLogin {
    [self.requestSerializer removeAccessToken];

    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"tw33tme://oauth"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSLog(@"[TwitterClient startLogin] success");
                                NSString *authURL = [NSString
                                                     stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",
                                                     requestToken.token];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
                            } failure:^(NSError *error) {
                                NSLog(@"[TwitterClient startLogin] failure %@", [error description]);
                            }];
}

- (void)finishLoginWith:(NSString *)queryString withCompletion:(void (^) ())completion {
    [self fetchAccessTokenWithPath:@"/oauth/access_token"
                              method:@"POST"
                        requestToken:[BDBOAuthToken tokenWithQueryString:queryString]
                             success:^(BDBOAuthToken *accessToken) {
                                 NSLog(@"[TwitterClient finishLogin] success");
                                 [self.requestSerializer saveAccessToken:accessToken];
                                 [User verifyCurrentUserWithSuccess:^{
                                     if (completion) {
                                         completion();
                                     }
                                 } failure:^(NSError *error) {
                                     NSLog(@"[TwitterClient finishLogin] verify failure: %@", error.description);
                                 }];

                             } failure:^(NSError *error) {
                                 NSLog(@"[TwitterClient finishLogin] failure: %@", error.description);
                             }];
}

- (AFHTTPRequestOperation *)homeTimelineWithParams:(NSDictionary *)params
                                           success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)timelineWithScreenName:(NSString *)screenName
                                       success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"screen_name": screenName};
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)verifyCredentialWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)updateWithStatus:(NSString *)status
                                     success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"status": status};
    return [self POST:@"1.1/statuses/update.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)retweetWithId:(NSNumber *)tweetId
                                  success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)destroyWithId:(NSNumber *)tweetId
                                        success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self POST:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweetId] parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)favoriteWithId:(NSNumber *)tweetId
                                   success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"id": tweetId};
    return [self POST:@"1.1/favorites/create.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)removeFavoriteWithId:(NSNumber *)tweetId
                                         success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    NSDictionary *parameters = @{@"id": tweetId};
    return [self POST:@"1.1/favorites/destroy.json" parameters:parameters success:success failure:failure];
}
@end
