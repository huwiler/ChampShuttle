//
//  CCCourseBrowseTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSubject.h"

@interface CCCourseBrowseTableViewController : UITableViewController

@property (nonatomic, strong) CCSubject *subject;
@property (strong, nonatomic) UIActivityIndicatorView *navActivityIndicator;
@property (nonatomic) BOOL error;

@end
