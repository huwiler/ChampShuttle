//
//  CCDirectoryQuicklinksViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCDirectoryQuicklinksViewController.h"
#import "CCDirectoryDetailTableViewController.h"

@interface CCDirectoryQuicklinksViewController ()

@end

@implementation CCDirectoryQuicklinksViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    CCDirectoryDetailTableViewController *detailViewController = [segue destinationViewController];
    
    NSInteger section = [self.tableView indexPathForSelectedRow].section;
    
    if (section == 0) {
        detailViewController.person = [self.quickLinksPeopleController objectInListAtIndex:(unsigned)[self.tableView indexPathForSelectedRow].row];
    }
    else if (section == 1) {
        detailViewController.person = [self.recentPeopleController objectInListAtIndex:(unsigned)[self.tableView indexPathForSelectedRow].row];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Build quick links model
    
    self.quickLinksPeopleController = [[CCPersonController alloc] init];
    self.recentPeopleController = [[CCPersonController alloc] init];
    
    CCPerson *security = [[CCPerson alloc] initWithName:@"Security" title:@"Public Safety" department:@"Campus Public Safety" email:@"SecurityIssues@champlain.edu" phone:@"(802) 865-6465" building:@"Durick Hall"];
    
    CCPerson *helpdesk = [[CCPerson alloc] initWithName:@"Help Desk" title:@"Computer Help Desk" department:@"Support Services" email:@"Helpdesk@champlain.edu" phone:@"(802) 860-2710" building:@"Rowell Annex"];
    
    [self.quickLinksPeopleController addPerson:security];
    [self.quickLinksPeopleController addPerson:helpdesk];
    
    // Build Recents model - Recent links are stored in NSUserDefaults whenever the person
    //  detail screen is loaded.
    NSMutableArray *newRecentPeopleArray;
    NSData *oldRecentPeopleData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentPeople"];
    
    if (oldRecentPeopleData != nil) {
        NSArray *oldRecentPeopleArray = [NSKeyedUnarchiver unarchiveObjectWithData:oldRecentPeopleData];
        if (oldRecentPeopleArray != nil) {
            newRecentPeopleArray = [[NSMutableArray alloc] initWithArray:oldRecentPeopleArray];
        }
    }
    if (newRecentPeopleArray == nil) {
        newRecentPeopleArray = [[NSMutableArray alloc] init];
    }
    
    int recentsLength = (unsigned)[newRecentPeopleArray count];
    while (recentsLength--) {
        [self.recentPeopleController addPerson:[newRecentPeopleArray objectAtIndex:recentsLength]];
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.quickLinksPeopleController countOfList];
    }
    else if (section == 1) {
        return [self.recentPeopleController countOfList];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"personCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CCPerson *personAtIndex;
    
    if (indexPath.section == 0) {
        personAtIndex = [self.quickLinksPeopleController objectInListAtIndex:(unsigned)indexPath.row];
    }
    else {
        personAtIndex = [self.recentPeopleController objectInListAtIndex:(unsigned)indexPath.row];
    }
    
    [[cell textLabel] setText:personAtIndex.name];
    [[cell detailTextLabel] setText:personAtIndex.department];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Quick Links";
    }
    
    if (section == 1) {
        return @"Recent";
    }
    
    return @"";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
