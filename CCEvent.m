//
//  CCEvent.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCEvent.h"

@implementation CCEvent

- (id)initWithTitle:(NSString *)title link:(NSString *)link time:(NSString *)time category:(NSString *)category displayDate:(NSString *)displayDate date:(NSDate *)date {
    
    self = [super init];
    if (self) {
        _title = title;
        _link = link;
        _time = time;
        _category = category;
        _displayDate = displayDate;
        _date = date;
        
        return self;
    }
    return nil;
}

@end
