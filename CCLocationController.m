//
//  CCLocationController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCLocationController.h"
#import "CCLocation.h"

@implementation CCLocationController

- (void)addLocationWithTitle:(NSString *)title query:(NSString *)query {
    
    NSString *trimmedTitle = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CCLocation *location = [[CCLocation alloc] initWithTitle:trimmedTitle query:query];
    
    // add new course to courseList
    [self.locationList addObject:location];
}


- (CCLocation *)objectInListAtIndex:(unsigned)index {
    return [self.locationList objectAtIndex:index];
}

- (unsigned)countOfList {
    return (unsigned)[self.locationList count];
}

- (void)setLocationList:(NSMutableArray *)locationList {
    if (_locationList != locationList) {
        _locationList = [locationList mutableCopy];
    }
}

// set courseList to empty array when initialized
-(id)init {
    if (self = [super init]) {
        _locationList = [NSMutableArray array];
        return self;
    }
    return nil;
}


@end
