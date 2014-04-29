//
//  CCTweet.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCTweet.h"

@implementation CCTweet

- (id)initWithID:(NSString *)champlainID twitterID:(NSString *)twitterID link:(NSString *)link screenName:(NSString *)screenName text:(NSString *)text createdAt:(NSString *)createdAt image:(UIImage *)image {
    
    self = [super init];
    
    if (self) {
        
        _champlainID = champlainID;
        _twitterID = twitterID;
        _link = link;
        _screenName = screenName;
        _text = text;
        _createdAt = createdAt;
        _image = image;
        
        return self;
        
    }
    
    return nil;
    
}

@end
