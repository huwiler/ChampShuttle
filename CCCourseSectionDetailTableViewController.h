//
//  CCCourseSectionDetailTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCourse.h"
#import "CCSection.h"

@interface CCCourseSectionDetailTableViewController : UITableViewController

@property (nonatomic, strong) CCSection *section;
@property (nonatomic, copy) NSString *courseTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *datesLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatsLabel;

@end
