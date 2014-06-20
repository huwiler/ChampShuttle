//
//  CCCourseOptionsModalViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCourseSearchTableViewController.h"

@interface CCCourseOptionsModalViewController : UIViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) CCCourseSearchTableViewController *delegate;
@property (weak, nonatomic) UISwitch *gradSwitch;
@property (weak, nonatomic) UISwitch *cpsSwitch;
@property (weak, nonatomic) UISwitch *undergradSwitch;

@end
