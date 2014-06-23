//
//  CCDepartmentController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCDepartmentController.h"
#import "CCDepartment.h"

@implementation CCDepartmentController

- (void)addDepartmentWithTitle:(NSString *)title query:(NSString *)query {
    
    NSString *trimmedTitle = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CCDepartment *department = [[CCDepartment alloc] initWithTitle:trimmedTitle query:query];
    
    // add new course to courseList
    [self.departmentList addObject:department];
}

- (CCDepartment *)objectInListAtIndex:(unsigned)index {
    return [self.departmentList objectAtIndex:index];
}

- (unsigned)countOfList {
    return (unsigned)[self.departmentList count];
}

- (void)setDepartmentList:(NSMutableArray *)departmentList {
    if (_departmentList != departmentList) {
        _departmentList = [departmentList mutableCopy];
    }
}

// set courseList to empty array when initialized
-(id)init {
    if (self = [super init]) {
        _departmentList = [NSMutableArray array];
        return self;
    }
    return nil;
}

@end
