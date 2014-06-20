//
//  CCCourseSearchTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCCourseSearchTableViewController.h"
#import "CCCourseDetailTableViewController.h"
#import "CCCourseBrowseTableViewController.h"
#import "CCCourseOptionsModalViewController.h"
#import "AFNetworking.h"

@interface CCCourseSearchTableViewController ()

@end

@implementation CCCourseSearchTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    /* courseDetail segue happens when a user searches (using the search bar) and clicks
     *  on one of the courses returned.  The destination view controller is past the course
     *  that the user has selected. */
    
    if ([[segue identifier] isEqualToString:@"courseDetail"]) {
        CCCourseDetailTableViewController *detailViewController = [segue destinationViewController];
        detailViewController.course = [self.filteredCourseController objectInListAtIndex:(unsigned int)[self.tableView indexPathForSelectedRow].row];
        detailViewController.loading = NO;
        detailViewController.error = NO;
    }
    
    /* courseBrowse segue happens when user toggles to Browse courses by subject and clicks
     * on a subject in the list.  As segue occurs, an asyncronous HTTP request for courses
     * in that subject is executed. */
    
    else if ([[segue identifier] isEqualToString:@"courseBrowse"]) {
        CCCourseBrowseTableViewController __block *detailViewController = [segue destinationViewController];
        detailViewController.subject = [self.filteredSubjectController objectInListAtIndex:(unsigned int)[self.tableView indexPathForSelectedRow].row];
        
        NSString *apiURLString = [NSString stringWithFormat:@"http://classlist.champlain.edu/api3/courses/subject/%@/filter/ug", detailViewController.subject.code];
        
        if ([detailViewController.subject.courseController countOfList] == 0) {
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // [self.searchBar startActivity];
            [manager GET:apiURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // Sort courses
                NSMutableArray *courses = [[responseObject objectForKey:@"items"] mutableCopy];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
                [courses sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                
                // Populate courseController of detail view
                for (id course in courses) {
                    [detailViewController.subject.courseController
                     addCourseWithNumber:[course objectForKey:@"number"]
                     title:[course objectForKey:@"title"]
                     description:[course objectForKey:@"description"]
                     prereq:[course objectForKey:@"prereq"]
                     subject:[course objectForKey:@"subject"]
                     credits:-1
                     sections:[NSMutableArray array]
                     ];
                }
                
                // Refresh Table UI
                //[detailViewController.tableView reloadData];
                [detailViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                
                // Turn off activity indicator in SearchBarWithActivity
                //[detailViewController.navActivityIndicator stopAnimating];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                //detailViewController.error = YES;
                //[detailViewController.tableView reloadData];
                //[detailViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                // [detailViewController.navActivityIndicator stopAnimating];
            }];
            
        }
    }
    
    else if ([[segue identifier] isEqualToString:@"showOptions"]) {
        CCCourseOptionsModalViewController *detailViewController = [segue destinationViewController];
        detailViewController.delegate = self;
    }
}

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

/*  User preferences are stored using NSUserDefaults in keys corresponding to view ids
 *  in options modals.  ChamplainShuttleCourseSearch and ChamplainShuttleDirectorySearch
 *  apply filters to query results based on these preferences.  setFiltersFromUserPrefs
 *  sets these filters when the controller is loaded and when user preferences are updated
 *  in a modal which uses the controller as a delegate.
 *
 *  TODO: Currently adding filters requires manually making updates to the following:
 *   - add filter to setFiltersFromUserPrefs
 *   - in modal, add corresponding property to UISwitch and synthesize it
 *   - edit modal's save method
 *   - edit modal's viewDidUnload method
 *   - edit modal's numberOfRowsInSection method
 *   - edit modal's cellForRowAtIndexPath method
 *   - edit home screen's default value settings
 *
 *  Ideally updating should occur from configuration plists structured similar to this:
 *
 *  Settings
 *    Courses
 *      Filters
 *        <filter type>
 *          Filter: regex
 *          on: yes|no
 *        ...
 *    Directory
 *      Departments
 *        <dept name>
 *        ...
 */
- (void) setFiltersFromUserPrefs {
    
    // Build array of filters (regexes) applied to each element of course and subjects controller
    //  before display based on what the user has selected.
    
    if (self.filters != nil) {
        self.filters = nil;
    }
    
    self.filters = [[NSMutableArray alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IncludeGraduate"] == NO) {
        [self.filters addObject:[NSRegularExpression regularExpressionWithPattern:@"(?:MBA|MIT|EMM)" options:0 error:0]];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IncludeCPS"] == NO) {
        [self.filters addObject:[NSRegularExpression regularExpressionWithPattern:@"(?:ACCT|ARTS|MGMT|COMM|CFDI|CMIT|CAPS|NETW|CRIM|ECON|EBUS|ENGL|HITS|HCMT|HIST|BLAW|LEAD|MATH|MKTG|PHIL|PSYC|SCIE|SWRK|SOCI|SDEV|WEBD|WRIT)" options:0 error:0]];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IncludeUndergraduate"] == NO) {
        [self.filters addObject:[NSRegularExpression regularExpressionWithPattern:@"^(?:(?!ACCT|ARTS|MGMT|COMM|CFDI|CMIT|CAPS|NETW|CRIM|ECON|EBUS|ENGL|HITS|HCMT|HIST|BLAW|LEAD|MATH|MKTG|PHIL|PSYC|SCIE|SWRK|SOCI|SDEV|WEBD|WRIT|MBA|MIT|EMM).)+" options:0 error:0]];
    }
    
    // Build filteredCourseController and filteredSubjectController which contain a subset of
    //   the courseController and subjectController based on filters user applied.
    
    self.filteredCourseController = [[CCCourseController alloc] init];
    self.filteredSubjectController = [[CCSubjectController alloc] init];
    
    for (int i = 0; i < [self.courseController countOfList]; i++) {
        CCCourse *course = [self.courseController objectInListAtIndex:i];
        
        BOOL filterOut = NO;
        
        for (int i = 0; i < [self.filters count]; i++) {
            if ([[self.filters objectAtIndex:i] numberOfMatchesInString:course.number options:0 range:NSMakeRange(0, [course.number length])] > 0) {
                filterOut = YES;
            }
        }
        if (!filterOut) {
            [self.filteredCourseController addCourse:course];
        }
    }
    
    for (int i = 0; i < [self.subjectController countOfList]; i++) {
        CCSubject *subject = [self.subjectController objectInListAtIndex:i];
        
        BOOL filterOut = NO;
        
        for (int i = 0; i < [self.filters count]; i++) {
            if ([[self.filters objectAtIndex:i] numberOfMatchesInString:subject.code options:0 range:NSMakeRange(0, [subject.code length])] > 0) {
                filterOut = YES;
            }
        }
        if (!filterOut) {
            [self.filteredSubjectController addSubject:subject];
        }
    }
}

// UISearchBarDelegate methods
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Build API query request url string
    self.query = searchBar.text;
    NSString *escapedQuery = [self.query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *apiURLString = [NSString stringWithFormat:@"http://classlist.champlain.edu/api2/search/filter/ug/delimit/and/query/%@", escapedQuery];
    
    NSLog(@"Searching %@...", apiURLString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // [self.searchBar startActivity];
    [manager GET:apiURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Reset courseController (model)
        self.courseController = [[CCCourseController alloc] init];
        
        NSDictionary *data = responseObject;
        NSLog(@"%@", data);
        
        for (id courseDictionary in [responseObject objectForKey:@"items"]) {
            [self.courseController addCourseSectionFromDictionary:courseDictionary];
        }
        
        NSLog(@"self.courseController.countOfList = %lu", self.courseController.countOfList);
        
        // Apply filters set in "Options" modal by user
        [self setFiltersFromUserPrefs];
        
        // Refresh Table UI
        [self.tableView reloadData];
        
        //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        // Turn off activity indicator in SearchBarWithActivity
        // [self.searchBar finishActivity];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        // [self.searchBar finishActivity];
    }];
    
    // Hide keyboard
    [searchBar resignFirstResponder];
}

// UITableView Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.courseMode = SEARCH;
    
    if (self.navActivityIndicator == nil) {
        self.navActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.navActivityIndicator];
        [self navigationItem].rightBarButtonItem = barButton;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CourseBrowseMode"]) {
        [self setToBrowseMode];
    }
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setSearchButton:nil];
    [self setBrowseButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.courseMode == SEARCH) {
        if (self.courseController != nil && [self.filteredCourseController countOfList] > 0) {
            return [self.filteredCourseController countOfList];
        }
    }
    else if (self.courseMode == BROWSE) {
        if ([self.filteredSubjectController countOfList] > 0) {
            return [self.filteredSubjectController countOfList];
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (self.courseMode == SEARCH) {
        if (self.courseController != nil && [self.filteredCourseController countOfList] > 0) {
            static NSString *CellIdentifier = @"courseCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            CCCourse *courseAtIndex = [self.filteredCourseController objectInListAtIndex:(unsigned int)indexPath.row];
            
            [[cell textLabel] setText:courseAtIndex.title];
            [[cell detailTextLabel] setText:courseAtIndex.number];
        }
        else if (self.courseController == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"noQueryCell"];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"noResultsCell"];
        }
    }
    else if (self.courseMode == BROWSE) {
        if ([self.filteredSubjectController countOfList] > 0) {
            static NSString *BrowseCellIdentifier = @"subjectCell";
            cell = [tableView dequeueReusableCellWithIdentifier:BrowseCellIdentifier];
            
            CCSubject *subjectAtIndex = [self.filteredSubjectController objectInListAtIndex:(unsigned int)indexPath.row];
            
            [[cell textLabel] setText:subjectAtIndex.title];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"noSubjectsCell"];
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

- (IBAction)browse:(id)sender {
    [self setToBrowseMode];
}

- (IBAction)search:(id)sender {
    [self setToSearchMode];
}

- (void)setToBrowseMode {
    self.courseMode = BROWSE;
    
    [self.searchBar setUserInteractionEnabled:NO];
    self.searchBar.alpha = .5f;
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, +45) animated:YES];
    
    self.searchButton.enabled = YES;
    self.browseButton.enabled = NO;
    
    if ([self.subjectController countOfList] == 0) {
        
        //[self.navActivityIndicator startAnimating];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://classlist.champlain.edu/api3/subjects/filter/ug" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (self.subjectController == nil) {
                self.subjectController = [[CCSubjectController alloc] init];
            }
            
            // Sort subjects
            NSMutableArray *subjects = [[responseObject objectForKey:@"items"] mutableCopy];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];
            [subjects sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
            // Apply filters set in user prefs and populate courseController
            for (id subjectDictionary in subjects) {
                [self.subjectController
                 addSubjectWithTitle:[subjectDictionary objectForKey:@"subject"]
                 code:[subjectDictionary objectForKey:@"id"]
                 ];
            }
            
            [self setFiltersFromUserPrefs];
            
            // Refresh Table UI
            //[self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
            // [self.navActivityIndicator stopAnimating];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            // [self.navActivityIndicator stopAnimating];
        }];
    }
    else {
        //[self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [[NSUserDefaults standardUserDefaults]
     setBool:YES
     forKey:@"CourseBrowseMode"
     ];
};

- (void)setToSearchMode {
    [self.searchBar setUserInteractionEnabled:YES];
    self.searchBar.alpha = 1.0f;
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, 0) animated:YES];
    
    self.courseMode = SEARCH;
    self.searchBar.hidden = NO;
    self.searchButton.enabled = NO;
    self.browseButton.enabled = YES;
    //[self.tableView reloadData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    [[NSUserDefaults standardUserDefaults]
     setBool:NO
     forKey:@"CourseBrowseMode"
     ];
};

@end
