//
//  NSURL+dictionaryFromQueryString.m
//  TW33Tme
//
//  Created by Amie Kweon on 6/21/14.
//  Copyright (c) 2014 Amie Kweon. All rights reserved.
//

#import "NSURL+dictionaryFromQueryString.h"

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];

    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];

        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [dictionary setObject:val forKey:key];
    }

    return dictionary;
}

@end
