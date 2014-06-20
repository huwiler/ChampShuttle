//
//  CCSubject.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCCourseController.h"

@interface CCSubject : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) CCCourseController *courseController;

- (id)initWithTitle:(NSString *)title code:(NSString *)code;

@end
