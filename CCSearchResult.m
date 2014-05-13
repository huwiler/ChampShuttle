//
//  CCSearchResult.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 5/3/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCSearchResult.h"

@implementation CCSearchResult

- (id)initWithID:(NSString *)searchID type:(NSString *)type score:(NSNumber *)score data:(NSDictionary *)data {
    
    self = [super init];
    
    if (self) {
        
        _searchID = searchID;
        _type = type;
        _score = score;
        _data = data;
        
        return self;
        
    }
    
    return nil;
    
}

@end
