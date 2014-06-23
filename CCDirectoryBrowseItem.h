//
//  CCDirectoryBrowseItem.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCPersonController.h"

@interface CCDirectoryBrowseItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *query;
@property (nonatomic, strong) CCPersonController *personController;

- (id)initWithTitle:(NSString *)title query:(NSString *)query;

@end
