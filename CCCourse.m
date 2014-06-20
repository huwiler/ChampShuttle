//
//  CCCourse.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCCourse.h"
#import "CCSection.h"

@implementation CCCourse

- (id)initWithTitle:(NSString *)title description:(NSString *)description number:(NSString *)number subject:(NSString *)subject credits:(int)credits prereq:(NSString *)prereq sections:(NSMutableArray *)sections {
    self = [super init];
    if (self) {
        _title = title;
        _description = description;
        _number = number;
        _credits = credits;
        _prereq = prereq;
        _sections = sections;
        _subject = subject;
        
        return self;
    }
    return nil;
}

- (void)addSection:(CCSection *)section {
    [self.sections addObject:section];
}

// Make sure sections is mutable
- (void)setSections:(NSMutableArray *)sections {
    if (_sections != sections) {
        _sections = [sections mutableCopy];
    }
}

@end
