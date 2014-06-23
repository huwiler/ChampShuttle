//
//  CCDirectoryModalViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDirectorySearchTableViewController.h"

@interface CCDirectoryModalViewController : UIViewController

@property (weak, nonatomic) CCDirectorySearchTableViewController *delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UISegmentedControl *browseType;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
