//
//  CCDirectorySearchTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/20/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCDirectorySearchTableViewController.h"
#import "CCDirectoryDetailTableViewController.h"
#import "CCDirectoryModalViewController.h"
#import "CCDirectoryBrowseTableViewController.h"

#import "AFNetworking.h"

@interface CCDirectorySearchTableViewController ()

@end

@implementation CCDirectorySearchTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPerson"]) {
        CCDirectoryDetailTableViewController *detailViewController = [segue destinationViewController];
        detailViewController.person = [self.personController objectInListAtIndex:(unsigned)[self.tableView indexPathForSelectedRow].row];
    }
    else if ([[segue identifier] isEqualToString:@"showOptions"]) {
        CCDirectoryModalViewController *detailViewController = [segue destinationViewController];
        detailViewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"browsePeople"]) {
        
        CCDirectoryBrowseTableViewController __block *detailViewController = [segue destinationViewController];
        
        if (self.directoryMode == BROWSE_DEPARTMENT) {
            detailViewController.browseItem = [self.departmentController objectInListAtIndex:(unsigned)[self.tableView indexPathForSelectedRow].row];
        }
        else if (self.directoryMode == BROWSE_LOCATION){
            detailViewController.browseItem = [self.locationController objectInListAtIndex:(unsigned)[self.tableView indexPathForSelectedRow].row];
        }
        
        NSString *apiURLString = [NSString stringWithFormat:@"https://my.champlain.edu/page_search/search/type/people/query/%@", [detailViewController.browseItem.query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        if ([detailViewController.browseItem.personController countOfList] == 0) {
            
            
            //[detailViewController.navActivityIndicator startAnimating];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            // [self.searchBar startActivity];
            [manager GET:apiURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                // Sort results
                NSMutableArray *people = [[responseObject objectForKey:@"items"] mutableCopy];
                
                // Check for errors returned in API
                if ([[[people objectAtIndex:0] objectForKey:@"id"] isKindOfClass:[NSString class]] &&
                    [[[people objectAtIndex:0] objectForKey:@"id"] isEqualToString:@"error"]) {
                    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[[people objectAtIndex:0] objectForKey:@"error_message"] delegate:self cancelButtonTitle:@"Alright" otherButtonTitles:nil, nil];
                    //[alert show];
                    NSLog(@"Error: %@", [[people objectAtIndex:0] objectForKey:@"error_message"]);
                    //[detailViewController.navActivityIndicator stopAnimating];
                    return;
                }
                
                // Finely, if all looks good, sort and display results
                else {
                    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
                    [people sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    
                    // Populate courseController
                    for (id personDictionary in people) {
                        [detailViewController.browseItem.personController addPersonFromDictionary:personDictionary];
                    }
                }
                
                // Refresh Table UI
                //[detailViewController.tableView reloadData];
                [detailViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                
                // Turn off activity indicator in SearchBarWithActivity
                //[detailViewController.navActivityIndicator stopAnimating];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                detailViewController.error = YES;
                //[detailViewController.tableView reloadData];
                [detailViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                //[detailViewController.navActivityIndicator stopAnimating];
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[JSONAPI makeErrorPretty:error] delegate:self cancelButtonTitle:@"Alright" otherButtonTitles:nil, nil];
                //[alert show];
                NSLog(@"Error: %@", error);
                //detailViewController.error = YES;
                //[detailViewController.tableView reloadData];
                //[detailViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                // [detailViewController.navActivityIndicator stopAnimating];
            }];
            
        }
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

// UISearchBarDelegate methods
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Build API query request url string
    self.query = searchBar.text;
    NSString *escapedQuery = [self.query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *apiURLString = [NSString stringWithFormat:@"https://my.champlain.edu/page_search/search/type/people/query/%@", escapedQuery];
    
    //[self.searchBar startActivity];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // [self.searchBar startActivity];
    [manager GET:apiURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Reset courseController (model)
        self.personController = [[CCPersonController alloc] init];
        
        // Sort results
        NSMutableArray *people = [[responseObject objectForKey:@"items"] mutableCopy];
        
        // If error did not occur
        if ([[[people objectAtIndex:0] objectForKey:@"id"] isKindOfClass:[NSString class]] &&
            [[[people objectAtIndex:0] objectForKey:@"id"] isEqualToString:@"error"]) {
            NSLog(@"Error %@", [[people objectAtIndex:0] objectForKey:@"id"]);
        }
        else {
            NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            [people sortUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
            
            // Populate courseController
            for (id personDictionary in people) {
                [self.personController addPersonFromDictionary:personDictionary];
            }
        }
        
        // Refresh Table UI
        //[self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        // Turn off activity indicator in SearchBarWithActivity
        //[self.searchBar finishActivity];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
    // Hide keyboard
    [searchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.directoryMode = SEARCH;
    
    // Populate department and location controllers
    // Currently, this is done with static data due to lack of corresponding API calls
    //   TODO: Build api for this!
    self.departmentController = [[CCDepartmentController alloc] init];
    
    [self.departmentController addDepartmentWithTitle:@"Academic Coaching" query:@"Academic Coaching"];
    [self.departmentController addDepartmentWithTitle:@"Admissions" query:@"Admission"];
    [self.departmentController addDepartmentWithTitle:@"Advising and Registration" query:@"Advising"];
    [self.departmentController addDepartmentWithTitle:@"Academic Affairs" query:@"Academic Affairs"];
    [self.departmentController addDepartmentWithTitle:@"Career Services" query:@"Career Services"];
    [self.departmentController addDepartmentWithTitle:@"Center for Instructional Practice" query:@"Center for Instructional Practice"];
    [self.departmentController addDepartmentWithTitle:@"Center for Service & Civic Engagement" query:@"Center for Service"];
    [self.departmentController addDepartmentWithTitle:@"Core Division" query:@"Core"];
    [self.departmentController addDepartmentWithTitle:@"Diversity and Inclusion" query:@"Diversity"];
    [self.departmentController addDepartmentWithTitle:@"Division of Business" query:@"Division of Business"];
    [self.departmentController addDepartmentWithTitle:@"Division of Continuing Professional Studies" query:@"Division of Continuing"];
    [self.departmentController addDepartmentWithTitle:@"Division of Communication & Creative Media" query:@"Division of Communication"];
    [self.departmentController addDepartmentWithTitle:@"Division of Education & Human Studies" query:@"Division of Education"];
    [self.departmentController addDepartmentWithTitle:@"Division of Enrollment & Student Life" query:@"Division of Enrollment"];
    [self.departmentController addDepartmentWithTitle:@"Division of Information Technology & Sciences" query:@"Division of Information"];
    [self.departmentController addDepartmentWithTitle:@"Dublin Campus" query:@"Dublin"];
    [self.departmentController addDepartmentWithTitle:@"eLearning Department" query:@"eLearning"];
    [self.departmentController addDepartmentWithTitle:@"Emergent Media Center" query:@"Emergent"];
    [self.departmentController addDepartmentWithTitle:@"Event Center" query:@"Event Center"];
    [self.departmentController addDepartmentWithTitle:@"Finance" query:@"Finance"];
    [self.departmentController addDepartmentWithTitle:@"Financial Aid" query:@"Financial"];
    [self.departmentController addDepartmentWithTitle:@"Graduate  Admission & Customer Relations Management" query:@"Graduate Admission"];
    [self.departmentController addDepartmentWithTitle:@"Human Resources" query:@"human resources"];
    [self.departmentController addDepartmentWithTitle:@"Information Systems" query:@"Information Systems"];
    [self.departmentController addDepartmentWithTitle:@"Library" query:@"Library"];
    [self.departmentController addDepartmentWithTitle:@"Marketing" query:@"Marketing"];
    [self.departmentController addDepartmentWithTitle:@"Mailroom" query:@"Mailroom"];
    [self.departmentController addDepartmentWithTitle:@"Montreal Campus" query:@"Montreal"];
    [self.departmentController addDepartmentWithTitle:@"Office of Advancement" query:@"Office of Advancement"];
    [self.departmentController addDepartmentWithTitle:@"Office of International Programs" query:@"Office of Int"];
    [self.departmentController addDepartmentWithTitle:@"Physical Plant" query:@"Physical"];
    [self.departmentController addDepartmentWithTitle:@"President's Office" query:@"President"];
    [self.departmentController addDepartmentWithTitle:@"Security" query:@"Security"];
    [self.departmentController addDepartmentWithTitle:@"Sodexho" query:@"sodexho"];
    [self.departmentController addDepartmentWithTitle:@"Single Parents Program" query:@"Single Par"];
    [self.departmentController addDepartmentWithTitle:@"Student Accounts" query:@"Student Acc"];
    [self.departmentController addDepartmentWithTitle:@"Student Life Office" query:@"Student Lif"];
    
    // Populate department and location controllers
    // Currently, this is done with static data due to lack of corresponding API calls
    self.locationController = [[CCLocationController alloc] init];
    
    [self.locationController addLocationWithTitle:@"Aiken" query:@"Aiken"];
    [self.locationController addLocationWithTitle:@"Coolidge" query:@"Coolidge"];
    [self.locationController addLocationWithTitle:@"Cushing Hall" query:@"Cushing"];
    [self.locationController addLocationWithTitle:@"Dublin Campus" query:@"Dublin Campus"];
    [self.locationController addLocationWithTitle:@"Durick Hall" query:@"Durick Hall"];
    [self.locationController addLocationWithTitle:@"Freeman" query:@"Freeman"];
    [self.locationController addLocationWithTitle:@"Hauke" query:@"Hauke"];
    [self.locationController addLocationWithTitle:@"IDX Student Life Center" query:@"IDX Student"];
    [self.locationController addLocationWithTitle:@"Ireland" query:@"Ireland"];
    [self.locationController addLocationWithTitle:@"Lakeside" query:@"Lakeside"];
    [self.locationController addLocationWithTitle:@"Miller Information Commons" query:@"Miller Information"];
    [self.locationController addLocationWithTitle:@"Montreal Campus" query:@"Montreal Campus"];
    [self.locationController addLocationWithTitle:@"Perry Hall" query:@"Perry Hall"];
    [self.locationController addLocationWithTitle:@"Sears Lane" query:@"Sears Lane"];
    [self.locationController addLocationWithTitle:@"Skiff" query:@"Skiff"];
    [self.locationController addLocationWithTitle:@"Skiff Annex" query:@"Skiff Annex"];
    [self.locationController addLocationWithTitle:@"West Hall" query:@"West Hall"];
    
    // Setting browse/search mode to last active mode
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"DirectoryBrowseMode"]) {
        [self setToBrowseMode];
    }
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setDepartmentController:nil];
    [self setLocationController:nil];
    [self setPersonController:nil];
    [self setSearchButton:nil];
    [self setBrowseButton:nil];
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
    
    if (self.directoryMode == SEARCH) {
        if (self.personController != nil && [self.personController countOfList] > 0) {
            return [self.personController countOfList];
        }
    }
    else if (self.directoryMode == BROWSE_DEPARTMENT) {
        if ([self.departmentController countOfList] > 0) {
            return [self.departmentController countOfList];
        }
    }
    else if (self.directoryMode == BROWSE_LOCATION) {
        if ([self.locationController countOfList] > 0) {
            return [self.locationController countOfList];
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (self.directoryMode == SEARCH) {
        if (self.personController != nil && [self.personController countOfList] > 0) {
            static NSString *CellIdentifier = @"personCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            CCPerson *personAtIndex = [self.personController objectInListAtIndex:(unsigned)indexPath.row];
            
            [[cell textLabel] setText:personAtIndex.name];
            [[cell detailTextLabel] setText:personAtIndex.department];
        }
        else if (self.personController == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"noQueryCell"];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"noResultsCell"];
        }
    }
    else if (self.directoryMode == BROWSE_DEPARTMENT) {
        static NSString *CellIdentifier = @"basicCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CCDepartment *departmentAtIndex = [self.departmentController objectInListAtIndex:(unsigned)indexPath.row];
        
        [[cell textLabel] setText:departmentAtIndex.title];
    }
    else if (self.directoryMode == BROWSE_LOCATION) {
        static NSString *CellIdentifier = @"basicCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CCLocation *locationtAtIndex = [self.locationController objectInListAtIndex:(unsigned)indexPath.row];
        
        [[cell textLabel] setText:locationtAtIndex.title];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) setToBrowseMode {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BrowseByDepartment"] == YES) {
        self.directoryMode = BROWSE_DEPARTMENT;
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BrowseByLocation"] == YES) {
        self.directoryMode = BROWSE_LOCATION;
    }
    
    self.searchBar.alpha = 0.5f;
    [self.searchBar setUserInteractionEnabled:NO];
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, +45) animated:YES];
    self.searchButton.enabled = YES;
    self.browseButton.enabled = NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    [[NSUserDefaults standardUserDefaults]
     setBool:YES
     forKey:@"DirectoryBrowseMode"
     ];
}

- (void) setToSearchMode {
    self.directoryMode = SEARCH;
    self.searchBar.alpha = 1.0f;
    [self.searchBar setUserInteractionEnabled:YES];
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, 0) animated:YES];
    self.searchButton.enabled = NO;
    self.browseButton.enabled = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    [[NSUserDefaults standardUserDefaults]
     setBool:NO
     forKey:@"DirectoryBrowseMode"
     ];
}

- (IBAction)browse:(id)sender {
    [self setToBrowseMode];
}

- (IBAction)search:(id)sender {
    [self setToSearchMode];
}

- (IBAction)quicklinks:(id)sender {
    
}

@end
