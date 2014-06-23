//
//  CCLocationController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLocation.h"

@interface CCLocationController : NSObject

@property (nonatomic, strong) NSMutableArray *locationList;
- (unsigned)countOfList;
- (CCLocation *)objectInListAtIndex:(unsigned)index;
- (void)addLocationWithTitle:(NSString *)title
                       query:(NSString *)query;

@end
