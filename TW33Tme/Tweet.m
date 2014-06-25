//
//  Tweet.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "Tweet.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "NSDictionary+MTLManipulationAdditions.h"
#import "MTLValueTransformer.h"
#import "TwitterClient.h"

@implementation Tweet

- (User *)author {
    return (self.originalUser != nil) ? self.originalUser : self.user;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"id": @"id",
             @"text": @"text",
             @"user": @"user",
             @"createdAt": @"created_at",
             @"retweeted": @"retweeted",
             @"favorited": @"favorited",
             @"retweetCount": @"retweet_count",
             @"favouritesCount": @"favourites_count",
             @"originalUser": @"retweeted_status.user"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)originalUserJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    return dateFormatter;
}

+ (NSValueTransformer *)retweetCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil) {
            return 0;
        } else {
            return inObj;
        }
    }];
}

+ (NSValueTransformer *)favouritesCountJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id inObj) {
        if (inObj == nil) {
            return 0;
        } else {
            return inObj;
        }
    }];
}
@end
