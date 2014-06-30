//
//  CCEventsModalViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/27/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEventsTableViewController.h"

@interface CCEventsModalViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) CCEventsTableViewController *delegate;
@property (strong, nonatomic) NSMutableArray *switches;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

- (void) switchToggled:(id)sender;

@end
