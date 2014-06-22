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
        instance = [[TwitterClient alloc]
                    initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
                    consumerKey:@"oktJjqH6ZF1cFT6AGSB532une"
                    consumerSecret:@"pozqvOv9OXe8Gb8jqvKtzzBAgglGIkTtsbHGWEko47xQktIl2n"];
    });

    return instance;
}

- (void)startLogin {
    // TODO: do I need to keep this?
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
                                 // Save user id here "user_id"
                                 [self.requestSerializer saveAccessToken:accessToken];
                                 [User populateCurrentUser];
                                 if (completion) {
                                     completion();
                                 }


//                                 [self homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                     //NSLog(@"response: %@", responseObject);
//                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                     NSLog(@"error");
//                                 }];
                             } failure:^(NSError *error) {
                                 NSLog(@"[TwitterClient finishLogin] failure: %@", error.description);
                             }];
}

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)verifyCredentialWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}


@end
