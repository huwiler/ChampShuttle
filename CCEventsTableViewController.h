//
//  CCEventsTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEventsController.h"

@interface CCEventsTableViewController : UITableViewController

@property (nonatomic, strong) CCEventsController *eventsController;
@property (nonatomic, strong) CCEventsController *filteredEventsController;
@property (strong, nonatomic) UIActivityIndicatorView *navActivityIndicator;
@property (strong, nonatomic) NSMutableArray *filters;
@property (nonatomic) BOOL loading;

//- (IBAction)eventsButtonAction:(id)sender;
//- (IBAction)blogButtonAction:(id)sender;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *eventsButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *blogButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsButton;
@property (weak, nonatomic) IBOutlet UIButton *optionsButton;

//- (void)setToBlogMode;
//- (void)setToEventsMode;
- (void)setFiltersFromUserPrefs;

@end
