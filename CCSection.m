//
//  CCSection.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCSection.h"

@implementation CCSection

- (id)initWithNumber:(NSString *)number instructorFirstName:(NSString *)instructorFirstName instructorLastName:(NSString *)instructorLastName days:(NSString *)days times:(NSString *)times startDate:(NSDate *)startDate endDate:(NSDate *)endDate semester:(NSString *)semester seats:(unsigned)seats {
    self = [super init];
    if (self) {
        _number = number;
        _instructorFirstName = instructorFirstName;
        _instructorLastName = instructorLastName;
        _days = days;
        _startDate = startDate;
        _endDate = endDate;
        _semester = semester;
        _times = times;
        _seats = seats;
        
        return self;
    }
    return nil;
}

@end
