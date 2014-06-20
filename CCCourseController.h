//
//  CCCourseController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCCourse.h"

@interface CCCourseController : NSObject

@property (nonatomic, strong) NSMutableArray *courseList;
- (unsigned long)countOfList;
- (CCCourse *)objectInListAtIndex:(unsigned)index;

- (void)addCourseWithNumber:(NSString *)number
                      title:(NSString *)title
                description:(NSString *)description
                     prereq:(NSString *)prereq
                    subject:(NSString *)subject
                    credits:(int)credits
                   sections:(NSMutableArray *)sections;

- (void)addCourse:(CCCourse *)course;

- (void)addCourseSectionWithNumber:(NSString *)number
                             title:(NSString *)title
                       description:(NSString *)description
                           subject:(NSString *)subject
                           credits:(int)credits
                            prereq:(NSString *)prereq
               instructorFirstName:(NSString *)instructorFirstName
                instructorLastName:(NSString *)instructorLastName
                              days:(NSString *)days
                             times:(NSString *)times
                         startDate:(NSDate *)startDate
                           endDate:(NSDate *)endDate
                          semester:(NSString *)semester 
                             seats:(unsigned)seats;

- (void)addCourseSectionFromDictionary:(NSDictionary *)course;

@end
