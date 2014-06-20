//
//  CCCourseController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCCourseController.h"
#import "CCCourse.h"

@implementation CCCourseController

- (void)addCourse:(CCCourse *)course {
    [self.courseList addObject:course];
}

- (void)addCourseWithNumber:(NSString *)number title:(NSString *)title description:(NSString *)description prereq:(NSString *)prereq subject:(NSString *)subject credits:(int)credits sections:(NSMutableArray *)sections {
    
    // ...create course object & set sections to newly created sections array.
    CCCourse *course = [[CCCourse alloc] initWithTitle:title description:description number:number subject:subject credits:credits prereq:prereq sections:sections];
    
    // add new course to courseList
    [self addCourse:course];
}

- (void)addCourseSectionWithNumber:(NSString *)number title:(NSString *)title description:(NSString *)description subject:(NSString *)subject credits:(int)credits prereq:(NSString *)prereq instructorFirstName:(NSString *)instructorFirstName instructorLastName:(NSString *)instructorLastName days:(NSString *)days times:(NSString *)times startDate:(NSDate *)startDate endDate:(NSDate *)endDate semester:(NSString *)semester seats:(unsigned int)seats {
    
    // 1: split number in to courseNumber (number w/out section) and number (number w/ section)
    // 2: create new section object
    // 3:    iterate existing courses
    // 3.1:    if course already exists,
    //           add new section to existing section array of existing course
    //         else, create NSMutableArray with new section in it,
    //           create course object & set sections to array
    
    // 1: split number in to courseNumber (number w/out section) and number (number w/ section).
    NSError *error;
    NSRegularExpression *courseNumberRegex = [NSRegularExpression regularExpressionWithPattern:@"\\-.*" options:0 error:&error];
    NSString *courseNumber = [courseNumberRegex stringByReplacingMatchesInString:number options:0 range:NSMakeRange(0, [number length]) withTemplate:@""];
    
    // 2: create new section object.
    CCSection *section = [[CCSection alloc] initWithNumber:number instructorFirstName:instructorFirstName instructorLastName:instructorLastName days:days times:times startDate:startDate endDate:endDate semester:semester seats:seats];
    
    // 3: iterate existing courses.
    BOOL found = NO;
    for (CCCourse *course in self.courseList) {
        // 3.1: if course already exists...
        if ([course.number isEqualToString:courseNumber]) {
            // ...add new section to existing section array of existing course...
            [course.sections addObject:section];
            found = YES;
        }
    }
    
    if (!found) {
        // If doesn't already exist, create NSMutableArray with new section in it...
        NSMutableArray *sections = [NSMutableArray array];
        [sections addObject:section];
        
        [self addCourseWithNumber:courseNumber title:title description:description prereq:prereq subject:subject credits:credits sections:sections];
    }
}

- (void)addCourseSectionFromDictionary:(NSDictionary *)course {
    
    // Date formatter used to extract start and end date properly
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setDateFormat:@"MM/dd/yy"];
    
    NSString *days = [course objectForKey:@"days"];
    int credits = [[course objectForKey:@"credit"] intValue];
    unsigned seats = [[course objectForKey:@"openseats"] intValue];
    NSString *semester = [course objectForKey:@"semester"];
    NSString *instructorFirstName = [course objectForKey:@"instructor_fname"];
    NSString *instructorLastName = [course objectForKey:@"instructor_lname"];
    NSString *prereq = [course objectForKey:@"prereq"];
    NSString *title = [course objectForKey:@"title"];
    NSString *description = [course objectForKey:@"description"];
    NSString *times = [course objectForKey:@"times"];
    NSDate *startDate = [df dateFromString:[course objectForKey:@"start_date"]];
    NSDate *endDate = [df dateFromString:[course objectForKey:@"end_date"]];
    NSString *number = [course objectForKey:@"number"];
    NSString *subject = [course objectForKey:@"subject"];
    
    // Capitalize Semester
    semester = [semester stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[semester substringToIndex:1] uppercaseString]];
    
    [self addCourseSectionWithNumber:number title:title description:description subject:subject credits:credits prereq:prereq instructorFirstName:instructorFirstName instructorLastName:instructorLastName days:days times:times startDate:startDate endDate:endDate semester:semester seats:seats];
}

- (CCCourse *)objectInListAtIndex:(unsigned)index {
    return [self.courseList objectAtIndex:index];
}

- (unsigned long)countOfList {
    return [self.courseList count];
}

- (void)setCourseList:(NSMutableArray *)courseList {
    if (_courseList != courseList) {
        _courseList = [courseList mutableCopy];
    }
}

// set courseList to empty array when initialized
-(id)init {
    if (self = [super init]) {
        _courseList = [NSMutableArray array];
        return self;
    }
    return nil;
}

@end
