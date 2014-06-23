//
//  CCDirectoryModalViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCDirectoryModalViewController.h"

@interface CCDirectoryModalViewController ()

@end

@implementation CCDirectoryModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setTableView:nil];
    [self setBrowseType:nil];
    [super viewDidUnload];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"DirectoryBrowseTypeCell"];
    
    switch (indexPath.row) {
        case 0:
            self.browseType = (UISegmentedControl *)[cell viewWithTag:1];
            BOOL browseByDepartment = [[NSUserDefaults standardUserDefaults]
                                       boolForKey:@"BrowseByDepartment"
                                       ];
            BOOL browseByLocation = [[NSUserDefaults standardUserDefaults]
                                     boolForKey:@"BrowseByLocation"
                                     ];
            
            if (browseByDepartment) {
                self.browseType.selectedSegmentIndex = 0;
            }
            else if (browseByLocation) {
                self.browseType.selectedSegmentIndex = 1;
            }
            
            break;
    }
    
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Browse by ...";
}

- (IBAction)save:(id)sender {
    BOOL browseByDepartment = self.browseType.selectedSegmentIndex == 0 ? YES : NO;
    BOOL browseByLocation = self.browseType.selectedSegmentIndex == 1 ? YES : NO;
    
    [[NSUserDefaults standardUserDefaults]
     setBool:browseByDepartment
     forKey:@"BrowseByDepartment"
     ];
    
    [[NSUserDefaults standardUserDefaults]
     setBool:browseByLocation
     forKey:@"BrowseByLocation"
     ];
    
    if (self.delegate.directoryMode != SEARCH) {
        self.delegate.directoryMode = browseByDepartment ? BROWSE_DEPARTMENT : BROWSE_LOCATION;
    }
    
    [self.delegate.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
