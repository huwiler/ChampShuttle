//
//  CCSubject.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCSubject.h"
#import "CCCourseController.h"

@implementation CCSubject

- (id)initWithTitle:(NSString *)title code:(NSString *)code {
    self = [super init];
    if (self) {
        _title = title;
        _code = code;
        _courseController = [[CCCourseController alloc] init];

        return self;
    }
    return nil;
}

@end
