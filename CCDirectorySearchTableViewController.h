//
//  CCDirectorySearchTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPersonController.h"
#import "CCDepartmentController.h"
#import "CCLocationController.h"

typedef enum {
    SEARCH,
    BROWSE_DEPARTMENT,
    BROWSE_LOCATION
} DirectoryMode;

@interface CCDirectorySearchTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, copy) NSString *query;
@property (nonatomic) DirectoryMode directoryMode;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) CCPersonController *personController;
@property (nonatomic, strong) CCLocationController *locationController;
@property (nonatomic, strong) CCDepartmentController *departmentController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *browseButton;

- (IBAction)browse:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)quicklinks:(id)sender;

- (void) setToBrowseMode;
- (void) setToSearchMode;

@end
