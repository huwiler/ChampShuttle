//
//  CCMenuItem.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMenuItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray *badges;   // [vegan/vegetarian/well balanced]
@property (nonatomic, copy) NSString *day;          // monday/tuesday/etc
@property (nonatomic, copy) NSString *station;      // Grill/Deli/etc
@property (nonatomic, copy) NSString *type;         // lunch/dinner

- (id) initWithTitle:(NSString *)title badges:(NSMutableArray *)badges day:(NSString *)day station:(NSString *)station type:(NSString *)type;

@end
