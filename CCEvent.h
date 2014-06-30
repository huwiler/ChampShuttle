//
//  CCEvent.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCEvent : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *displayDate;
@property (nonatomic, strong) NSDate *date;

- (id)initWithTitle:(NSString *)title link:(NSString *)link time:(NSString *)time category:(NSString *)category displayDate:(NSString *)displayDate date:(NSDate *)date;

@end
