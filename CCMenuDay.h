//
//  CCMenuDay.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCMenuItemController.h"

@interface CCMenuDay : NSObject

@property (nonatomic, strong) CCMenuItemController *menuItems;
@property (nonatomic, copy) NSString *title;

- (void)addMenuItem:(CCMenuItem *)menuItem;
- (void)addMenuItemWithTitle:(NSString *)title badges:(NSMutableArray *)badges day:(NSString *)day station:(NSString *)station type:(NSString *)type;
- (id)initWithTitle:(NSString *)title;

@end
