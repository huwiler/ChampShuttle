//
//  CCCourseSearchTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCourseController.h"
#import "CCSubjectController.h"

typedef enum {
    SEARCH,
    BROWSE
} CourseMode;

@interface CCCourseSearchTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSString *query;
@property (nonatomic, strong) CCCourseController *courseController;
@property (nonatomic, strong) CCCourseController *filteredCourseController;
@property (nonatomic, strong) CCSubjectController *subjectController;
@property (nonatomic, strong) CCSubjectController *filteredSubjectController;
@property (nonatomic) CourseMode courseMode;
@property (strong, nonatomic) UIActivityIndicatorView *navActivityIndicator;
@property (strong, nonatomic) NSMutableArray *filters;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browseButton;

- (IBAction)browse:(id)sender;
- (IBAction)search:(id)sender;

- (void)setFiltersFromUserPrefs;
- (void)setToBrowseMode;
- (void)setToSearchMode;

@end
