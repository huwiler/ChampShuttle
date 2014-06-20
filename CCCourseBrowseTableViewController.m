//
//  CCCourseBrowseTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCCourseBrowseTableViewController.h"
#import "CCCourseDetailTableViewController.h"
#import "AFNetworking.h"

@interface CCCourseBrowseTableViewController ()

@end

@implementation CCCourseBrowseTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"courseDetail"]) {
        CCCourseDetailTableViewController __block *detailViewController = [segue destinationViewController];
        detailViewController.course = [self.subject.courseController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        NSString *escapedCourseNumber = [detailViewController.course.number stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSString *apiURLString = [NSString stringWithFormat:@"http://classlist.champlain.edu/api2/course/number/%@", escapedCourseNumber];
        
        detailViewController.loading = YES;
        detailViewController.error = NO;
        //[detailViewController.navActivityIndicator startAnimating];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:apiURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *courseDictionary = [[responseObject objectForKey:@"items"] objectAtIndex:0];
            detailViewController.course.credits = [[courseDictionary objectForKey:@"credit"] intValue];
            
            NSMutableArray *sections = [courseDictionary objectForKey:@"children"];
            for (id semesterDictionary in sections) {
                for (id sectionDictionary in [semesterDictionary objectForKey:@"children"]) {
                    
                    // Date formatter used to extract start and end date properly
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateStyle:NSDateFormatterShortStyle];
                    [df setDateFormat:@"MM/dd/yy"];
                    
                    CCSection *section = [[CCSection alloc]
                                        initWithNumber:[sectionDictionary objectForKey:@"number"]
                                        instructorFirstName:[sectionDictionary objectForKey:@"instructor_fname"]
                                        instructorLastName:[sectionDictionary objectForKey:@"instructor_lname"]
                                        days:[sectionDictionary objectForKey:@"days"]
                                        times:[sectionDictionary objectForKey:@"times"]
                                        startDate:[df dateFromString:[sectionDictionary objectForKey:@"start_date"]]
                                        endDate:[df dateFromString:[sectionDictionary objectForKey:@"end_date"]]
                                        semester:[semesterDictionary objectForKey:@"id"]
                                        seats:[[sectionDictionary objectForKey:@"openseats"] intValue]
                                        ];
                    
                    [detailViewController.course addSection:section];
                }
            }
            
            // Turn off activity indicator
            detailViewController.loading = NO;
            [detailViewController.navActivityIndicator stopAnimating];
            
            // Refresh Table UI
            [detailViewController.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            detailViewController.error = YES;
            //[detailViewController.navActivityIndicator stopAnimating];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
    }
}

// UITableView Delegate Methods

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.subject.courseController != nil && [self.subject.courseController countOfList] > 0) {
        return [self.subject.courseController countOfList];
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (self.subject.courseController != nil && [self.subject.courseController countOfList] > 0) {
        static NSString *CellIdentifier = @"courseCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        CCCourse *courseAtIndex = [self.subject.courseController objectInListAtIndex:indexPath.row];
        
        [[cell textLabel] setText:courseAtIndex.title];
        [[cell detailTextLabel] setText:courseAtIndex.number];
    }
    else if (self.error) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"errorCell"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"loadingCell"];
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
