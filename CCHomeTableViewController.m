//
//  CCHomeTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/13/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCHomeTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "CCSearchMasterTableViewController.h"

@interface CCHomeTableViewController ()
    @property (nonatomic, strong) NSMutableArray *buttons;
    @property (strong, nonatomic) UISearchBar *searchBar;
    @property (nonatomic) BOOL isFeedbackFormDisplayed;
@end

@implementation CCHomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)cancelFeedback:(id)sender
{
    self.isFeedbackFormDisplayed = NO;
    [self refreshFooter];
}
- (IBAction)sendFeedback:(id)sender
{
    self.isFeedbackFormDisplayed = NO;
    [self refreshFooter];
}
- (void)showFeedback
{
    self.isFeedbackFormDisplayed = YES;
    [self refreshFooter];
}

- (void) refreshFooter
{
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.buttons count] + 1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*CGRect frameTop = self.tableView.bounds;
    CGRect frameBottom = self.tableView.bounds;
    frameTop.origin.y = -frameTop.size.height;
    frameBottom.origin.y = frameBottom.size.height;
    UIView* grayViewTop = [[UIView alloc] initWithFrame:frameTop];
    UIView* grayViewBottom = [[UIView alloc] initWithFrame:frameBottom];
    grayViewTop.backgroundColor = [UIColor darkGrayColor];
    grayViewBottom.backgroundColor = [UIColor darkGrayColor];
    [self.tableView addSubview:grayViewTop];
    [self.tableView addSubview:grayViewBottom];*/
    
    self.isFeedbackFormDisplayed = NO;

    // Change the style of the status bar to be white
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self initButtons];
    [self initSearchBar];
    [self initUserPreferences];

    // On the homepage we display the number of blogs and tweets.  The format of the API calls
    // to do this take a since parameter as a unix timestamp (number of seconds since midnight
    // 1970 UTC).  Here we compose our since parameter value for our API calls as a String.
    NSDate *today = [NSDate date];
    NSDate *twoWeeksAgo = [today dateByAddingTimeInterval: -1209600.0];
    NSString *twoWeeksAgoString = [NSString stringWithFormat:@"%f", [twoWeeksAgo timeIntervalSince1970]];

    // We're using Mattt Thompson's AFNetworking rather than iOS NSURLConnection/NSURLSession
    // APIs in order to keep the code clean and concise.  For documentation, see
    // https://github.com/AFNetworking/AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    // Both of these web services return JSON and take similar parameters:
    //  - nocontent/true: causes only the unique mongodb id to be returned
    //  - since/<timestamp>: causes the API to only return content published since <timestamp>
    NSString *getBlogsAPIURL = [NSString stringWithFormat:@"https://forms.champlain.edu/pipes/blogs/nocontent/true/since/%@", twoWeeksAgoString];
    NSString *getTwitterAPIURL = [NSString stringWithFormat:@"https://forms.champlain.edu/twitterapi/all/nocontent/true/since/%@", twoWeeksAgoString];

    // Check for new Blog posts. If new posts exist, update model and reload table
    [manager GET:getBlogsAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updateButton:@"Recent Blog Posts" key:@"count" value:[NSNumber numberWithLong:[responseObject count]]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    // Check for new Twitter posts.  If new posts exist, update model and reload table
    [manager GET:getTwitterAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self updateButton:@"Recent Tweets" key:@"count" value:[NSNumber numberWithLong:[responseObject count]]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];


}

- (void) initUserPreferences {
    // Set user preference defaults if app has not run before
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RanBefore"] != YES) {
        //if (YES) {
        
        // Courses default user preferences:
        
        [[NSUserDefaults standardUserDefaults]
         setBool:YES
         forKey:@"IncludeGraduate"
         ];
        
        [[NSUserDefaults standardUserDefaults]
         setBool:NO
         forKey:@"IncludeCPS"
         ];
        
        [[NSUserDefaults standardUserDefaults]
         setBool:YES
         forKey:@"IncludeUndergraduate"
         ];
        
        [[NSUserDefaults standardUserDefaults]
         setBool:NO
         forKey:@"CourseBrowseMode"
         ];
        
        // Directory default user preferences:
        
        [[NSUserDefaults standardUserDefaults]
         setBool:YES
         forKey:@"BrowseByDepartment"
         ];
        
        [[NSUserDefaults standardUserDefaults]
         setBool:NO
         forKey:@"BrowseByLocation"
         ];
        
        [[NSUserDefaults standardUserDefaults]
         setBool:NO
         forKey:@"DirectoryBrowseMode"
         ];
        
        // Events default user preferences
        
        [[NSUserDefaults standardUserDefaults]
         setBool:NO
         forKey:@"EventsBlogMode"
         ];
        [[NSUserDefaults standardUserDefaults]
         setBool:YES
         forKey:@"EventsEventsMode"
         ];
        
        // Event filters
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeAthletics"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeCampusCommunity"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeCampusWide"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeCareerServices"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeClass"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeDublin"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeExam"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeHousing"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeLead"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeMaintenance"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeMeeting"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeStudentAcademic"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EventsIncludeStudentSocial"];
    }
    [[NSUserDefaults standardUserDefaults]
     setBool:YES
     forKey:@"RanBefore"
     ];
}

// Initialize model for Table's buttons
- (void) initButtons {
    self.buttons = [@[
            [@{
                    @"label" : @"Shuttle Locations",
                    @"icon" : [UIImage imageNamed:@"icon-shuttles"],
                    @"count" : [NSNull null]
            } mutableCopy],
            [@{
                    @"label" : @"Recent Tweets",
                    @"icon" : [UIImage imageNamed:@"icon-twitter"],
                    @"count" : [NSNull null]
            } mutableCopy],
            [@{
                    @"label" : @"Recent Blog Posts",
                    @"icon" : [UIImage imageNamed:@"icon-blog"],
                    @"count" : [NSNull null]
            } mutableCopy],
            [@{
                    @"label" : @"Upcoming Events",
                    @"icon" : [UIImage imageNamed:@"icon-events"],
                    @"count" : [NSNull null]
            } mutableCopy],
            [@{
                    @"label" : @"Courses",
                    @"icon" : [UIImage imageNamed:@"icon-courses"],
                    @"count" : [NSNull null]
            } mutableCopy],
            [@{
                    @"label" : @"Directory",
                    @"icon" : [UIImage imageNamed:@"icon-directory"],
                    @"count" : [NSNull null]
            } mutableCopy],
            [@{
                    @"label" : @"Menu",
                    @"icon" : [UIImage imageNamed:@"icon-menu"],
                    @"count" : [NSNull null]
            } mutableCopy],
            [@{
                    @"label" : @"Contribute",
                    @"icon" : [UIImage imageNamed:@"icon-keyboard"],
                    @"count" : [NSNull null]
            } mutableCopy]
    ] mutableCopy];
}

- (void) updateButton:(NSString *)buttonLabel key:(NSString *)key value:(id)value {
    for (NSMutableDictionary *button in self.buttons) {
        if ([button[@"label"] isEqualToString:buttonLabel]) {
            [button setObject:value forKey:key];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of rows is equal to number of buttons + header and footer rows.
    return [self.buttons count] + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        return 165.0;
    }

    if (indexPath.row == [self.buttons count] + 1) {
        if (! self.isFeedbackFormDisplayed) {
            return 125.0;
        }
        else {
            return 300.0;
        }
    }

    return 75.0;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if (indexPath.row == 0) { // If first row, show header

        cell = [tableView dequeueReusableCellWithIdentifier:@"headercell" forIndexPath:indexPath];

        // remove separator from first row
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);

    }
    else if (indexPath.row == [self.buttons count] + 1) { // If last row, show footer
        if (!self.isFeedbackFormDisplayed) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"footercell" forIndexPath:indexPath];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"footercellexpanded" forIndexPath:indexPath];
        }
        
        // remove separator from last row
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
    }
    else { // Otherwise, show button

        long buttonIndex = indexPath.row - 1;
        NSDictionary *button = self.buttons[buttonIndex];

        cell = [tableView dequeueReusableCellWithIdentifier:@"buttoncell" forIndexPath:indexPath];
        UIImageView *icon = (UIImageView *)[cell viewWithTag:1];
        UILabel *label = (UILabel *)[cell viewWithTag:2];

        label.text = button[@"label"];
        icon.image = button[@"icon"];

        if (button[@"count"] != (id)[NSNull null]) {
            int count = [(NSNumber *)button[@"count"] intValue];
            UILabel *countLabel = (UILabel *)[cell viewWithTag:3];
            if (count > 0 && countLabel.alpha != 1) {
                UILabel *countLabel = (UILabel *)[cell viewWithTag:3];
                countLabel.text = [NSString stringWithFormat:@"%i", count];
                countLabel.layer.cornerRadius = 8;
                [countLabel sizeToFit];
                CGRect blogCountLabelRect = countLabel.frame;
                blogCountLabelRect.size.height = 25;
                blogCountLabelRect.size.width += 15;
                blogCountLabelRect.origin.x = 275 - blogCountLabelRect.size.width;
                countLabel.frame = blogCountLabelRect;

                // Fade Label in
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ countLabel.alpha = 1;} completion:nil];
            }
        }

    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    BOOL clickedButton = indexPath.row != [self.buttons count] + 1 && indexPath.row != 0 ? YES : NO;

    if (clickedButton) {
        NSMutableDictionary *button = [self.buttons objectAtIndex:(indexPath.row - 1)];

        if ([button[@"label"] isEqualToString:@"Shuttle Locations"]) {
            [self performSegueWithIdentifier:@"shuttles" sender:self];
        }
        else if ([button[@"label"] isEqualToString:@"Recent Blog Posts"]) {
            [self performSegueWithIdentifier:@"blogs" sender:self];
        }
        else if ([button[@"label"] isEqualToString:@"Recent Tweets"]) {
            [self performSegueWithIdentifier:@"twitter" sender:self];
        }
        else if ([button[@"label"] isEqualToString:@"Courses"]) {
            [self performSegueWithIdentifier:@"courses" sender:self];
        }
        else if ([button[@"label"] isEqualToString:@"Directory"]) {
            [self performSegueWithIdentifier:@"directory" sender:self];
        }
        else if ([button[@"label"] isEqualToString:@"Menu"]) {
            [self performSegueWithIdentifier:@"menu" sender:self];
        }
        else if ([button[@"label"] isEqualToString:@"Upcoming Events"]) {
            [self performSegueWithIdentifier:@"events" sender:self];
        }
    }

    else if (indexPath.row == 0) { // Header clicked
        
    }
    else { // Footer clicked
        
        // display feedback form in footer
        if (!self.isFeedbackFormDisplayed) {
            [self showFeedback];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    }
}

#pragma mark - Search Bar

- (void)initSearchBar {
    // Add a Search Bar to the Navigation Controller on this page
    self.searchBar = [UISearchBar new];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search Champlain";
    self.searchBar.showsBookmarkButton = NO;
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"search"]) {
        CCSearchMasterTableViewController *search = [segue destinationViewController];
        search.query = self.searchBar.text;
    }
}

@end
