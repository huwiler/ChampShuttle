//
//  CCMenuItem.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCMenuItem.h"

@implementation CCMenuItem

- (id)initWithTitle:(NSString *)title badges:(NSMutableArray *)badges day:(NSString *)day station:(NSString *)station type:(NSString *)type {
	self = [super init];
	if (self) {
		_title = title;
		_badges = badges;
		_day = day;
		_station = station;
        _type = type;
        return self;
	}
	return nil;
}

@end
