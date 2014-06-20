//
//  CCCourseSectionDetailTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCCourseSectionDetailTableViewController.h"
#import "CCSection.h"

@interface CCCourseSectionDetailTableViewController ()

@end

@implementation CCCourseSectionDetailTableViewController

- (void)viewDidAppear:(BOOL)animated {
    
    static NSDateFormatter *df = nil;
    if (df == nil) {
        df = [[NSDateFormatter alloc] init];
        [df setDateStyle:NSDateFormatterShortStyle];
        [df setDateFormat:@"MM/dd/yy"];
    }
    NSString *dates = [NSString stringWithFormat:@"%@ - %@", [df stringFromDate:self.section.startDate], [df stringFromDate:self.section.endDate]];
    
    NSString *daysAndTimes;
    if ([self.section.days isEqualToString:@"Online"]) {
        daysAndTimes = @"Online";
    }
    else {
        daysAndTimes = [NSString stringWithFormat:@"%@ (%@)", self.section.days, self.section.times];
    }
    
    NSLog(@"Course title: %@", self.courseTitle);
    
    self.titleLabel.text = self.courseTitle;
    self.numberLabel.text = self.section.number;
    self.datesLabel.text = dates;
    self.daysLabel.text = [NSString stringWithFormat:@"%@, %@", self.section.semester, daysAndTimes];
    self.instructorLabel.text = [NSString stringWithFormat:@"Professor: %@, %@", self.section.instructorLastName, self.section.instructorFirstName];
    self.seatsLabel.text = [NSString stringWithFormat:@"%d Seats Available", self.section.seats];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setNumberLabel:nil];
    [self setDatesLabel:nil];
    [self setDaysLabel:nil];
    [self setInstructorLabel:nil];
    [self setSeatsLabel:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

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
