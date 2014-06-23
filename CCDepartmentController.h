//
//  CCDepartmentController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCDepartment.h"

@interface CCDepartmentController : NSObject

@property (nonatomic, strong) NSMutableArray *departmentList;
- (unsigned)countOfList;
- (CCDepartment *)objectInListAtIndex:(unsigned)index;
- (void)addDepartmentWithTitle:(NSString *)title
                         query:(NSString *)query;

@end
