//
//  TwitterClient.h
//  TW33Tme
//
//  Created by Amie Kweon on 6/20/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)startLogin;

- (void)finishLoginWith:(NSString *)queryString withCompletion:(void (^) ())completion;

- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)verifyCredentialWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;


@end
