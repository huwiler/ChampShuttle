//
//  CCCourse.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSection.h"

@interface CCCourse : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *number;
@property (nonatomic) int credits;
@property (nonatomic, copy) NSString *prereq;
@property (nonatomic, strong) NSMutableArray *sections;

- (id)initWithTitle:(NSString *)title description:(NSString *)description number:(NSString *)number subject:(NSString *)subject credits:(int)credits prereq:(NSString *)prereq sections:(NSMutableArray *)sections;

- (void)addSection:(CCSection *)section;

@end
