//
//  CCEventsModalViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/27/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCEventsModalViewController.h"

@interface CCEventsModalViewController ()

@end

@implementation CCEventsModalViewController

- (void)viewDidLoad
{
    // set up model for switches
    self.switches = [[NSMutableArray alloc] initWithObjects:
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeAthletics", @"Athletics/Wellness", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeCampusCommunity", @"Campus & Community Event", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeCampusWide", @"Campus-wide Event", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeCareerServices", @"Career Services", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeClass", @"Class", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeDublin", @"Dublin - Offsite", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeExam", @"Final Exams", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeHousing", @"Housing", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeLead", @"LEAD", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeMaintenance", @"Maintenance", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeMeeting", @"Meeting", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeStudentAcademic", @"Student Activity - Academic", [NSNumber numberWithBool:YES], nil],
                     [[NSMutableArray alloc] initWithObjects:@"EventsIncludeStudentSocial", @"Student Activity - Social", [NSNumber numberWithBool:YES], nil],
                     nil];
    
    for (int i = 0; i < [self.switches count]; i++) {
        BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:[[self.switches objectAtIndex:i] objectAtIndex:0]];
        if (!on) {
            [[self.switches objectAtIndex:i] replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
}

// Make sure toolbar is shown
- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void) switchToggled:(id)sender {
    UISwitch *typeSwitch = (UISwitch *)sender;
    UITableViewCell *cell = (UITableViewCell *)typeSwitch.superview.superview.superview;
    UITableView *tableView = (UITableView *)cell.superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    [[self.switches objectAtIndex:indexPath.row] replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:typeSwitch.on]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *cellIdentifier = @"eventFilterCell";
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *includeLabel = (UILabel *)[cell viewWithTag:2];
    
    NSString *title = [[self.switches objectAtIndex:indexPath.row] objectAtIndex:1];
    BOOL on = [[[self.switches objectAtIndex:indexPath.row] objectAtIndex:2] boolValue];
    
    includeLabel.text = title;
    UISwitch *typeSwitch = (UISwitch *)[cell viewWithTag:1];
    typeSwitch.on = on;
    
    [typeSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Include the following...";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"... event types in Events listing.";
}

- (IBAction)save:(id)sender {
    for (int i = 0; i < [self.switches count]; i++) {
        BOOL on = [[[self.switches objectAtIndex:i] objectAtIndex:2] boolValue];
        NSString *key = [[self.switches objectAtIndex:i] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setBool:on forKey:key];
    }
    
    [self.delegate setFiltersFromUserPrefs];
    [self.delegate.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
