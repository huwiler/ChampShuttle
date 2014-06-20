//
//  CCCourseOptionsModalViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCCourseOptionsModalViewController.h"

@interface CCCourseOptionsModalViewController ()

@end

@implementation CCCourseOptionsModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setDelegate:nil];
    [self setGradSwitch:nil];
    [self setCpsSwitch:nil];
    [self setUndergradSwitch:nil];
    
    [super viewDidUnload];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"includeCell"];
    
    UILabel *includeLabel = (UILabel *)[cell viewWithTag:2];
    
    switch (indexPath.row) {
        case 0:
            includeLabel.text = @"Graduate";
            self.gradSwitch = (UISwitch *)[cell viewWithTag:1];
            self.gradSwitch.on = [[NSUserDefaults standardUserDefaults]
                                  boolForKey:@"IncludeGraduate"
                                  ] == NO ? NO : YES;
            break;
        case 1:
            includeLabel.text = @"CPS";
            self.cpsSwitch = (UISwitch *)[cell viewWithTag:1];
            self.cpsSwitch.on = [[NSUserDefaults standardUserDefaults]
                                 boolForKey:@"IncludeCPS"
                                 ] == NO ? NO : YES;
            break;
        case 2:
            includeLabel.text = @"Undergrad";
            self.undergradSwitch = (UISwitch *)[cell viewWithTag:1];
            self.undergradSwitch.on = [[NSUserDefaults standardUserDefaults]
                                       boolForKey:@"IncludeUndergraduate"
                                       ] == NO ? NO : YES;
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
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Include ...";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"... courses in search.";
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    [[NSUserDefaults standardUserDefaults]
     setBool:self.gradSwitch.on
     forKey:@"IncludeGraduate"
     ];
    
    [[NSUserDefaults standardUserDefaults]
     setBool:self.cpsSwitch.on
     forKey:@"IncludeCPS"
     ];
    
    [[NSUserDefaults standardUserDefaults]
     setBool:self.undergradSwitch.on
     forKey:@"IncludeUndergraduate"
     ];
    
    [self.delegate setFiltersFromUserPrefs];
    [self.delegate.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
