//
//  CCEventsTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCEventsTableViewController.h"
#import "CCWebViewController.h"
#import "CCEventsModalViewController.h"
#import "CCEventsController.h"
#import "AFNetworking.h"

@implementation CCEventsTableViewController

- (void) viewWillAppear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:NO animated:YES];
    //[super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //[self.navigationController setToolbarHidden:YES animated:YES];
    //[super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showEvent"]) {
        CCWebViewController *detailViewController = [segue destinationViewController];
        NSString *urlString = [self.filteredEventsController objectInListAtIndex:(unsigned)[self.tableView indexPathForSelectedRow].row].link;
        detailViewController.url = urlString;
    }
    else {
        CCEventsModalViewController *detailViewController = [segue destinationViewController];
        detailViewController.delegate = self;
    }
    
}

- (void) setFiltersFromUserPrefs {
    
    // Build array of filters (regexes) applied to each element of course and subjects controller
    //  before display based on what the user has selected.
    
    if (self.filters != nil) {
        self.filters = nil;
    }
    
    self.filters = [[NSMutableArray alloc] init];
    
    NSArray *types = [[NSArray alloc] initWithObjects:
                      [[NSArray alloc] initWithObjects:@"EventsIncludeAthletics", @"Athletics/Wellness", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeCampusCommunity", @"Campus & Community Event", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeCampusWide", @"Campus-wide Event", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeCareerServices", @"Career Services", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeClass", @"Class", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeDublin", @"Dublin - Offsite", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeExam", @"Final Exams", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeHousing", @"Housing", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeLead", @"LEAD", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeMaintenance", @"Maintenance", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeMeeting", @"Meeting", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeStudentAcademic", @"Student Activity - Academic", nil],
                      [[NSArray alloc] initWithObjects:@"EventsIncludeStudentSocial", @"Student Activity - Social", nil],
                      nil
                      ];
    
    for (int i = 0; i < [types count]; i++) {
        NSString *key = [[types objectAtIndex:i] objectAtIndex:0];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:key] == NO) {
            [self.filters addObject:[[types objectAtIndex:i] objectAtIndex:1]];
        }
    }
    
    // Build filteredCourseController and filteredSubjectController which contain a subset of
    //   the courseController and subjectController based on filters user applied.
    
    self.filteredEventsController = [[CCEventsController alloc] init];
    
    for (int i = 0; i < [self.eventsController countOfList]; i++) {
        CCEvent *event = [self.eventsController objectInListAtIndex:i];
        
        BOOL filterOut = NO;
        
        for (int i = 0; i < [self.filters count]; i++) {
            if ([[self.filters objectAtIndex:i] isEqualToString:event.category]) {
                filterOut = YES;
            }
        }
        if (!filterOut) {
            [self.filteredEventsController addEvent:event];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up navigation activity indicator
    //if (self.navActivityIndicator == nil) {
     //   self.navActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
     //   UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.navActivityIndicator];
      //  [self navigationItem].rightBarButtonItem = barButton;
   // }
    
    self.eventsController = [[CCEventsController alloc] init];
    
    if ([self.eventsController countOfList] == 0) {
        
        self.loading = YES;
        //[self.navActivityIndicator startAnimating];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"https://my.champlain.edu/widget_events/api" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSMutableArray *events = [responseObject mutableCopy];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"D, d M Y H:i:s T"];
            
            // Apply filters set in user prefs and populate courseController
            for (id event in events) {
                [self.eventsController
                 addEventWithTitle:[event objectForKey:@"title"]
                 link:[event objectForKey:@"link"]
                 time:[event objectForKey:@"time"]
                 category:[event objectForKey:@"category"]
                 displayDate: [event objectForKey:@"date"]
                 date:[df dateFromString:[event objectForKey:@"pubdate"]]
                 ];
            }
            
            self.loading = NO;
            [self setFiltersFromUserPrefs];
            
            // Refresh Table UI
            //[self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            //[self.navActivityIndicator stopAnimating];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
    else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 &&
        [self.filteredEventsController countOfList]) {
        
        CGSize textSize = [[self.filteredEventsController objectInListAtIndex:indexPath.row].title sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 10.0f * 3, 1000.0f)];
        return textSize.height + 9.0f * 3 + 48;
        
    }
    else {
        return tableView.rowHeight;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self.filteredEventsController countOfList] > 0) {
        return [self.filteredEventsController countOfList];
    }

    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    
    if ([self.filteredEventsController countOfList] > 0) { // events loaded
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"eventCell"];
        
        CCEvent *eventAtIndex = [self.filteredEventsController objectInListAtIndex:(unsigned)indexPath.row];
        
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
        
        CGRect currentFrame = titleLabel.frame;
        CGSize max = CGSizeMake(currentFrame.size.width, 500);
        CGSize expected = [eventAtIndex.title sizeWithFont:titleLabel.font constrainedToSize:max lineBreakMode:titleLabel.lineBreakMode];
        currentFrame.size.height = expected.height;
        titleLabel.frame = currentFrame;
                
        [titleLabel setText:eventAtIndex.title];
                
        // Show Date
                
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
        CGRect dateFrame = dateLabel.frame;
        dateFrame.origin.y = currentFrame.size.height + 16;
        dateLabel.frame = dateFrame;
                
        UILabel *dateValue = (UILabel *)[cell viewWithTag:3];
        CGRect dateValueFrame = dateValue.frame;
        dateValueFrame.origin.y = currentFrame.size.height + 16;
        dateValue.frame = dateValueFrame;
                
        // Show Time
        
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:4];
        CGRect timeFrame = timeLabel.frame;
        timeFrame.origin.y = currentFrame.size.height + 32;
        timeLabel.frame = timeFrame;
        
        UILabel *timeValue = (UILabel *)[cell viewWithTag:5];
        CGRect timeValueFrame = timeValue.frame;
        timeValueFrame.origin.y = currentFrame.size.height + 32;
        timeValue.frame = timeValueFrame;
                
        // Show Type
        
        UILabel *typeLabel = (UILabel *)[cell viewWithTag:8];
        CGRect typeFrame = typeLabel.frame;
        typeFrame.origin.y = currentFrame.size.height + 48;
        typeLabel.frame = typeFrame;
        
        UILabel *typeValue = (UILabel *)[cell viewWithTag:7];
        CGRect typeValueFrame = typeValue.frame;
        typeValueFrame.origin.y = currentFrame.size.height + 48;
        typeValue.frame = typeValueFrame;
        
        [dateValue setText:eventAtIndex.displayDate];
        [timeValue setText:eventAtIndex.time];
        [typeValue setText:eventAtIndex.category];
        
    }
    else { // events not loaded
        if (self.loading) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"loadingCell"];
        }
        else {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"noEventsCell"];
        }
    }

    return cell;
}

@end
