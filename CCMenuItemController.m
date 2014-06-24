//
//  CCMenuItemController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCMenuItemController.h"

@implementation CCMenuItemController

- (CCMenuItem *)objectInListAtIndex:(unsigned)index {
	return [self.menuItemList objectAtIndex:index];
}

- (unsigned)countOfList {
	return (unsigned)[self.menuItemList count];
}

- (void) addMenuItemWithTitle:(NSString *)title badges:(NSMutableArray *)badges day:(NSString *)day station:(NSString *)station type:(NSString *)type {
    
    //BOOL error = NO;
    /*
     // Trim whitespace and make day lowercase
     day = [[day lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     
     // Make sure day is valid
     if (![day isEqualToString:@"monday"] &&
     ![day isEqualToString:@"tuesday"] &&
     ![day isEqualToString:@"wednesday"] &&
     ![day isEqualToString:@"thursday"] &&
     ![day isEqualToString:@"friday"] &&
     ![day isEqualToString:@"saturday"] &&
     ![day isEqualToString:@"sunday"]) {
     
     error = true;
     }
     */
    
    CCMenuItem *menuItem = [[CCMenuItem alloc] initWithTitle:title badges:badges day:day station:station type:type];
    
    [self addMenuItem:menuItem];
    
}

- (void)setMenuItemList:(NSMutableArray *)menuItemList {
    if (_menuItemList != menuItemList) {
        _menuItemList = [menuItemList mutableCopy];
    }
}

- (void) addMenuItem:(CCMenuItem *)menuItem {
    
    //NSLog(@"Adding %@", [menuItem title]);
    
    [self.menuItemList addObject:menuItem];
}

- (id)init {
	if (self = [super init]) {
		_menuItemList = [NSMutableArray array];
		return self;
	}
    return nil;
}

@end
