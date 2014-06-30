//
//  CCEventsController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCEvent.h"

@interface CCEventsController : NSObject

@property (nonatomic, strong) NSMutableArray *eventList;

- (unsigned)countOfList;
- (CCEvent *)objectInListAtIndex:(unsigned)index;
- (void)addEvent:(CCEvent *)event;
- (void)addEventWithTitle:(NSString *)title link:(NSString *)link time:(NSString *)time category:(NSString *)category displayDate:(NSString *)displayDate date:(NSDate *)date;

@end
