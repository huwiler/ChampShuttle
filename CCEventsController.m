//
//  CCEventsController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCEventsController.h"
//#import "CCEvent.h"

@implementation CCEventsController

- (void) addEvent:(CCEvent *)event {
    [self.eventList addObject:event];
}

- (void) addEventWithTitle:(NSString *)title link:(NSString *)link time:(NSString *)time category:(NSString *)category displayDate:(NSString *)displayDate date:(NSDate *)date {
    
    CCEvent *event = [[CCEvent alloc] initWithTitle:title link:link time:[time stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] category:category displayDate:displayDate date:date];
    
    [self addEvent:event];
}

- (CCEvent *)objectInListAtIndex:(unsigned)index {
    return [self.eventList objectAtIndex:index];
}

- (unsigned)countOfList {
    return (unsigned)[self.eventList count];
}

- (void)setEventList:(NSMutableArray *)eventList {
    if (_eventList != eventList) {
        _eventList = [eventList mutableCopy];
    }
}

-(id)init {
    if (self = [super init]) {
        _eventList = [NSMutableArray array];
        return self;
    }
    return nil;
}

@end
