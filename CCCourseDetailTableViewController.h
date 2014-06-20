//
//  CCCourseDetailTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCourse.h"

@interface CCCourseDetailTableViewController : UITableViewController

@property (nonatomic, strong) CCCourse *course;
@property (strong, nonatomic) UIActivityIndicatorView *navActivityIndicator;
@property (nonatomic) BOOL loading;
@property (nonatomic) BOOL error;

@end
