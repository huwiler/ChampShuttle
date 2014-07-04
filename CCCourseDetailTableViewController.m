//
//  CCCourseDetailTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/16/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCCourseDetailTableViewController.h"
#import "CCCourseDetailTableViewController.h"
#import "CCCourseSectionDetailTableViewController.h"
#import "AFNetworking.h"
#import "CCCourse.h"
#import "CCSection.h"

@interface CCCourseDetailTableViewController ()

@end

@implementation CCCourseDetailTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"sectionDetail"]) {
        CCCourseSectionDetailTableViewController *detailViewController = [segue destinationViewController];
        detailViewController.section = [self.course.sections objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        detailViewController.courseTitle = self.course.title;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.apiUrl && !self.course) {
        
        self.loading = YES;
        [self showLoading];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        // Check for new Blog posts. If new posts exist, update model and reload table
        [manager GET:self.apiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //CCCourseController *courseController = [[CCCourseController alloc] init];
            
            NSDictionary *courseDictionary = [[responseObject objectForKey:@"items"] objectAtIndex:0];
            NSString *description = [courseDictionary objectForKey:@"description"];
            NSString *prereq = [courseDictionary objectForKey:@"prereq"];
            NSString *title = [courseDictionary objectForKey:@"title"];
            NSString *number = [courseDictionary objectForKey:@"id"];
            NSString *subject = [courseDictionary objectForKey:@"subject"];
            int credits = [[courseDictionary objectForKey:@"credit"] intValue];
            
            self.course = [[CCCourse alloc] initWithTitle:title description:description number:number subject:subject credits:credits prereq:prereq sections:[NSMutableArray array]];
            
            // Date formatter used to extract start and end section dates properly
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateStyle:NSDateFormatterShortStyle];
            [df setDateFormat:@"MM/dd/yy"];
            
            for (NSDictionary *semesterDictionary in [courseDictionary objectForKey:@"children"]) {
                NSString *semester = [semesterDictionary objectForKey:@"id"];
                
                for (NSDictionary *sectionDictionary in [semesterDictionary objectForKey:@"children"]) {
                    
                    NSString *number = [sectionDictionary objectForKey:@"number"];
                    NSString *instructorFirstName = [sectionDictionary objectForKey:@"instructor_fname"];
                    NSString *instructorLastName = [sectionDictionary objectForKey:@"instructor_lname"];
                    NSString *days = [sectionDictionary objectForKey:@"days"];
                    NSString *times = [sectionDictionary objectForKey:@"times"];
                    NSDate *startDate = [df dateFromString:[sectionDictionary objectForKey:@"start_date"]];
                    NSDate *endDate = [df dateFromString:[sectionDictionary objectForKey:@"end_date"]];
                    int seats = [[sectionDictionary objectForKey:@"openseats"] intValue];
                    
                    CCSection *section = [[CCSection alloc] initWithNumber:number instructorFirstName:instructorFirstName instructorLastName:instructorLastName days:days times:times startDate:startDate endDate:endDate semester:semester seats:seats];
                    
                    [self.course addSection:section];
                    
                }
            }
            
            [self hideLoading];
            self.loading = NO;
            
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    

    /*if (self.navActivityIndicator == nil) {
        self.navActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.navActivityIndicator];
        [self navigationItem].rightBarButtonItem = barButton;
    }*/
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    }
    else {
        if (self.loading) {
            return 1;
        }
        else {
            return [self.course.sections count];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3) {
        CGSize textSize = [self.course.description sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 10.0f * 3, 1000.0f)];
        return textSize.height + 10.0f * 3;
    }
    else {
        return tableView.rowHeight;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSString *sectionHeader = nil;

    if(section == 1) {
        sectionHeader = @"Sections";
    }

    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Determin Cell prototype identifier
    UITableViewCell *cell;

    // display general course information
    if (indexPath.section == 0) {
        // set title
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            titleLabel.text = self.course.title;
        }
                // set credit #
        else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"attributeCell"];
            [[cell textLabel] setText:@"Credits"];

            if (!self.loading && !self.error) {
                NSString *credits = [NSString stringWithFormat:@"%d", self.course.credits];
                [[cell detailTextLabel] setText:credits];
            }
            else if (self.loading) {
                [[cell detailTextLabel] setText:@"Loading"];
            }
            else {
                [[cell detailTextLabel] setText:@"Unknown"];
            }
        }
                // set prereq
        else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"attributeCell"];
            [[cell textLabel] setText:@"Prereq"];
            [[cell detailTextLabel] setText:self.course.prereq];
        }
                // set description
        else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
            UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:2];

            // Resize label to fit text
            CGRect currentFrame = descriptionLabel.frame;
            CGSize max = CGSizeMake(currentFrame.size.width, 500);
            CGSize expected = [self.course.description sizeWithFont:descriptionLabel.font constrainedToSize:max lineBreakMode:descriptionLabel.lineBreakMode];
            currentFrame.size.height = expected.height;
            descriptionLabel.frame = currentFrame;

            // Set text
            descriptionLabel.text = self.course.description;
        }
    }
            // display sections
    else {
        if (!self.loading) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"sectionCell"];
            CCSection *section = [self.course.sections objectAtIndex:indexPath.row];
            NSString *label = [NSString stringWithFormat:@"%@: %@", section.semester, section.number];
            NSString *detailLabel = [NSString stringWithFormat:@"%d seats; Instructor: %@", section.seats, section.instructorLastName];
            [[cell textLabel] setText:label];
            [[cell detailTextLabel] setText:detailLabel];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"errorCell"];
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
