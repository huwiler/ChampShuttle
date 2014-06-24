//
//  CCMenuDay.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCMenuDay.h"

@implementation CCMenuDay

- (void) addMenuItemWithTitle:(NSString *)title badges:(NSMutableArray *)badges day:(NSString *)day station:(NSString *)station type:(NSString *)type {
    
    CCMenuItem *menuItem = [[CCMenuItem alloc] initWithTitle:title badges:badges day:day station:station type:type];
    
    [self addMenuItem:menuItem];
}

- (void)addMenuItem:(CCMenuItem *)menuItem {
    [self.menuItems addMenuItem:menuItem];
}

- (id)initWithTitle:(NSString *)title {
	self = [super init];
	if (self) {
		_title = title;
        _menuItems = [[CCMenuItemController alloc] init];
        return self;
	}
	return nil;
}

@end
