//
//  CCMenuItemController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCMenuItemController.h"
#import "CCMenuItem.h"

@interface CCMenuItemController : NSObject

@property (nonatomic, strong) NSMutableArray *menuItemList;

- (unsigned) countOfList;
- (CCMenuItem *)objectInListAtIndex:(unsigned)index;
- (void) addMenuItemWithTitle:(NSString *)title badges:(NSMutableArray *)badges day:(NSString *)day station:(NSString *)station type:(NSString *)type;
- (void) addMenuItem:(CCMenuItem *)menuItem;

@end
