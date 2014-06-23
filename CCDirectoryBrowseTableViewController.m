//
//  CCDirectoryBrowseTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCDirectoryBrowseTableViewController.h"
#import "CCDirectoryDetailTableViewController.h"

@interface CCDirectoryBrowseTableViewController ()

@end

@implementation CCDirectoryBrowseTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPerson"]) {
        CCDirectoryDetailTableViewController *detailViewController = [segue destinationViewController];
        detailViewController.person = [self.browseItem.personController objectInListAtIndex:(unsigned)[self.tableView indexPathForSelectedRow].row];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.navActivityIndicator == nil) {
        self.navActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.navActivityIndicator];
        [self navigationItem].rightBarButtonItem = barButton;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.browseItem.personController != nil && [self.browseItem.personController countOfList] > 0) {
        return [self.browseItem.personController countOfList];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (self.browseItem.personController != nil && [self.browseItem.personController countOfList] > 0) {
        static NSString *CellIdentifier = @"personCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        CCPerson *personAtIndex = [self.browseItem.personController objectInListAtIndex:(unsigned)indexPath.row];
        
        [[cell textLabel] setText:personAtIndex.name];
        [[cell detailTextLabel] setText:personAtIndex.department];
    }
    else if (self.error) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"errorCell"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
