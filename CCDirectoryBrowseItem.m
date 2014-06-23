//
//  CCDirectoryBrowseItem.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCDirectoryBrowseItem.h"

@implementation CCDirectoryBrowseItem

- (id)initWithTitle:(NSString *)title query:(NSString *)query {
    self = [super init];
    
    if (self) {
        _title = title;
        _query = query;
        _personController = [[CCPersonController alloc] init];
        
        return self;
    }
    
    return nil;
}

@end
