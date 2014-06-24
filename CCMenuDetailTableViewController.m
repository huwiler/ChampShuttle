//
//  CCMenuDetailTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCMenuDetailTableViewController.h"
#import "CCWebViewController.h"

@interface CCMenuDetailTableViewController ()

@end

@implementation CCMenuDetailTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDiningWebsite"]) {
        CCWebViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.url = @"https://cosmosweb.champlain.edu/menu/WeeklyMenu.htm";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.lunch == nil) {
        self.lunch = [[CCMenuItemController alloc] init];
    }
    
    if (self.dinner == nil) {
        self.dinner = [[CCMenuItemController alloc] init];
    }
    
    for (id item in self.day.menuItems.menuItemList) {
        if ([[(CCMenuItem *)item type] isEqualToString:@"lunch"]) {
            [self.lunch addMenuItem:item];
        }
        else if ([[(CCMenuItem *)item type] isEqualToString:@"dinner"]) {
            [self.dinner addMenuItem:item];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [NSString stringWithFormat:@"Lunch\n(%@)", self.weekTitle];
    }
    return [NSString stringWithFormat:@"Dinner\n(%@)", self.weekTitle];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.lunch countOfList];
    }
    if (section == 1) {
        return [self.dinner countOfList];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        if (self.lunch != nil && [self.lunch countOfList] > 0) {
            CCMenuItem *menuItem = [self.lunch objectInListAtIndex:(unsigned)indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuitemwithbadge"];
            [[cell textLabel] setText:menuItem.title];
            
            NSString *detailLabel;
            
            if ([menuItem.badges count] > 0) { // Create cell detailLabel w/ badges
                NSString *badges = [menuItem.badges componentsJoinedByString:@", "];
                detailLabel = [NSString stringWithFormat:@"%@ (%@)", menuItem.station, badges];
            }
            else { // create cell detailLabel w/out badges
                detailLabel = [NSString stringWithFormat:@"%@", menuItem.station];
            }
            
            [[cell detailTextLabel] setText:detailLabel];
        }
        else if (self.lunch == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"loading"];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"error"];
        }
    }
    else if (indexPath.section == 1) {
        if (self.dinner != nil && [self.dinner countOfList] > 0) {
            CCMenuItem *menuItem = [self.dinner objectInListAtIndex:(unsigned)indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:@"menuitemwithbadge"];
            [[cell textLabel] setText:menuItem.title];
            
            NSString *detailLabel;
            
            if ([menuItem.badges count] > 0) { // Create cell detailLabel w/ badges
                NSString *badges = [menuItem.badges componentsJoinedByString:@", "];
                detailLabel = [NSString stringWithFormat:@"%@ (%@)", menuItem.station, badges];
            }
            else { // create cell detailLabel w/out badges
                detailLabel = [NSString stringWithFormat:@"%@", menuItem.station];
            }
            
            [[cell detailTextLabel] setText:detailLabel];
        }
        else if (self.dinner == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"loading"];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"error"];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
