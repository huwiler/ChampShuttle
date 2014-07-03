//
//  CCSearchMasterTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/28/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCSearchMasterTableViewController.h"
#import "CCDirectoryDetailTableViewController.h"
#import "AFNetworking.h"
#import "CCSearchResult.h"
#import "CCWebViewController.h"
#import "CCPerson.h"

// Used to indicate amount of space between each view in a cell
#define CELL_VIEW_MARGIN 2.0

// Used to set fonts on search results
#define HEADER_FONT [UIFont fontWithName:@"HelveticaNeue" size:14.0]
#define NORMAL_FONT [UIFont fontWithName:@"HelveticaNeue-Thin" size:13.0]

@interface CCSearchMasterTableViewController ()

// Helper functions to reduce amount of redundant code required in cellForRowAtIndexPath and heightForRowAtIndexPath
- (NSArray *) getDirectoryFramesAtIndexPath:(NSIndexPath *)indexPath;
- (CGRect)getLabelRectForString:(NSString *)string font:(UIFont *)font constraint:(CGSize)constraint xPosition:(CGFloat)x yPosition:(CGFloat)y;

@end

@implementation CCSearchMasterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"Getting to search with %@", self.query);
    
    // Show activity indicator animation in self.overlayView.  This will then
    // be removed once blog summaries have been downloaded.
    [self showLoading];
    
    // If blogs NSMutableArray property is nil, initialize it
    if (! self.searchResults) {
        self.searchResults = [NSMutableArray new];
    }
    
    // Remove table cell separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // URL encode user's query
    NSString *escapedQuery = [self.query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    // Retrieve blogs from blogs API
    // See https://github.com/AFNetworking/AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *searchAPIURL = [NSString stringWithFormat:@"http://searchapi.champlain.edu/search.php?pagesize=50&highlight=1&q=%@&i=pages%%2Cdirectory%%2Ccourses%%2Cevents&nofeatured=0&pageindex=0", escapedQuery];
    
    //NSLog(@"Getting to AFHTTPRequestOperation with %@", searchAPIURL);
    
    self.navigationItem.title = @"...";
    
    [manager GET:searchAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Getting to response handler.");
        
        NSDictionary *response = (NSDictionary *)responseObject;
        NSArray *hits = response[@"hits"][@"hits"];
        
        self.navigationItem.title = [NSString stringWithFormat:@"%lu Results", [hits count]];
        
        //NSLog(@"hits: %@", hits);
        
        for (NSDictionary *result in hits) {
            
            NSDictionary *data;
            NSDictionary *obj = result[@"_source"];
            
            //NSLog(@"obj: %@", obj);
            
            if ([result[@"_type"] isEqualToString:@"directory"]) {
                
                // Find headshot for directory result
                NSString *headShotURL = obj[@"headshot"];
                UIImage *headShotImage;
                
                if (headShotURL) {
                    if ([headShotURL rangeOfString:@"generic"].location == NSNotFound && [headShotURL rangeOfString:@"shield"].location == NSNotFound) {
                        headShotURL = [NSString stringWithFormat:@"http://www.champlain.edu/assets/images/%@", headShotURL];
                        headShotImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:headShotURL]]];
                    }
                    else {
                        headShotURL = nil;
                        headShotImage = nil;
                    }
                }
                
                // Create array of titles
                NSMutableArray *titles = [NSMutableArray new];
                if (obj[@"api_title"]) {
                    if ([obj[@"api_title"] length] != 0) {
                        [titles addObject:obj[@"api_title"]];
                    }
                }
                if (obj[@"api_title2"]) {
                    if ([obj[@"api_title2"] length] != 0) {
                        [titles addObject:obj[@"api_title2"]];
                    }
                }
                
                // Create array of degrees
                NSArray *degrees = [obj[@"api_degrees"] componentsSeparatedByString:@"; "];
                
                data = @{
                         @"firstName": obj[@"firstName"] ? [obj[@"firstName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"lastName": obj[@"lastName"] ? [obj[@"lastName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"email": obj[@"email"] ? [obj[@"email"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"headShot": headShotImage ? headShotImage : [NSNull null],
                         @"department": obj[@"api_department"] ? [obj[@"api_department"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"office": obj[@"api_office"] ? [obj[@"api_office"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"phone": obj[@"api_phone"] ? [obj[@"api_phone"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"title": titles,
                         @"degrees": degrees,
                         @"homepage": obj[@"api_homepage"] ? [obj[@"api_homepage"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @""
                         };
                
                //NSLog(@"Data received from search: %@", data);
                
            }
            else if ([result[@"_type"] isEqualToString:@"featured"]) {
                
                if (!obj[@"loc"] || [obj[@"loc"] length] == 0 || !obj[@"featured_title"] || [obj[@"featured_title"] length] == 0 || !obj[@"featured_abstract"] || [obj[@"featured_abstract"] length] == 0) {
                    continue;
                }
                
                data = @{
                         @"url": [obj[@"loc"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"title": [obj[@"featured_title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"description": [obj[@"featured_abstract"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                         };
                
                //NSLog(@"Data received from search: %@", data);
                
            }
            else if ([result[@"_type"] isEqualToString:@"pages"]) {
                
                if (!obj[@"loc"] || [obj[@"loc"] length] == 0 || !obj[@"title"] || [obj[@"title"] length] == 0 || !obj[@"description"] || [obj[@"description"] length] == 0) {
                    continue;
                }
                
                data = @{
                         @"url": [obj[@"loc"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"title": [obj[@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"description": [obj[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                         };
                
                NSLog(@"Data received from search: %@", data);
            }
            else if ([result[@"_type"] isEqualToString:@"courses"]) {
                if (!obj[@"loc"] || [obj[@"loc"] length] == 0 || !obj[@"title"] || [obj[@"title"] length] == 0 || !obj[@"description"] || [obj[@"description"] length] == 0) {
                    continue;
                }

                data = @{
                        @"url": [obj[@"loc"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                        @"title": [obj[@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                        @"description": [obj[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                };

                NSLog(@"Data received from search: %@", data);
            }
            else {
                NSLog(@"Ignoring unknown result type %@", obj[@"_type"]);
                continue;
            }
            
            CCSearchResult *searchResult = [[CCSearchResult alloc] initWithID:result[@"_id"] type:result[@"_type"] score:result[@"_score"] data:data];
            
            [self.searchResults addObject:searchResult];
            
        }
        
        [self.tableView reloadData];
        
        [self hideLoading];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.searchResults count] > 0 ? [self.searchResults count] : 1;

}

- (CGRect)getLabelRectForString:(NSString *)string font:(UIFont *)font constraint:(CGSize)constraint xPosition:(CGFloat)x yPosition:(CGFloat)y {
    
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    CGRect rect = [attrString boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    rect.origin.y = y;
    rect.origin.x = x;
    rect.size.width = constraint.width;
    
    return rect;
}

- (UILabel *) getPageLabelForSearchResult:(CCSearchResult *)searchResult string:(NSString *)string font:(UIFont *)font yPosition:(CGFloat)yPosition {
    
    CGSize constraint;
    CGFloat xPosition;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    // Useful for debuging - allows you to visualize exactually how label frames are positioned
    //label.layer.borderColor = [UIColor blackColor].CGColor;
    //label.layer.borderWidth = 1.0f;
    
    label.font = font;
    label.text = string;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    constraint = CGSizeMake(275.0, CGFLOAT_MAX);
    xPosition = 9.0;
    
    label.frame = [self getLabelRectForString:string font:font constraint:constraint xPosition:xPosition yPosition:yPosition];
    
    return label;
    
}

- (UILabel *) getDirectoryLabelForSearchResult:(CCSearchResult *)searchResult string:(NSString *)string font:(UIFont *)font yPosition:(CGFloat)yPosition {
    
    CGSize constraint;
    CGFloat xPosition;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    // Useful for debuging - allows you to visualize exactually how label frames are positioned
    //label.layer.borderColor = [UIColor blackColor].CGColor;
    //label.layer.borderWidth = 1.0f;
    
    label.font = font;
    label.text = string;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (![searchResult.data[@"headShot"] isEqual:[NSNull null]] && yPosition <= 130.0) {
        constraint = CGSizeMake(175.0, CGFLOAT_MAX);
        xPosition = 109.0;
    }
    else {
        constraint = CGSizeMake(275.0, CGFLOAT_MAX);
        xPosition = 9.0;
    }
    
    label.frame = [self getLabelRectForString:string font:font constraint:constraint xPosition:xPosition yPosition:yPosition];
    
    return label;
    
}

- (NSArray *) getPageFramesAtIndexPath:(NSIndexPath *)indexPath
{
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    
    CGFloat nextViewYPosition = 9.0;
    NSMutableArray *viewList = [NSMutableArray new];
    
    if ([searchResult.data[@"title"] length] > 0) {
        UILabel *titleLabel = [self getPageLabelForSearchResult:searchResult string:searchResult.data[@"title"] font:HEADER_FONT yPosition:nextViewYPosition];
        [viewList addObject:titleLabel];
        nextViewYPosition = titleLabel.frame.origin.y + titleLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    if ([searchResult.data[@"description"] length] > 0) {
        //NSLog(@"Description: %@", searchResult.data[@"description"]);
        UILabel *descriptionLabel = [self getPageLabelForSearchResult:searchResult string:searchResult.data[@"description"] font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:descriptionLabel];
    }
    
    return viewList;
    
}

- (NSArray *) getDirectoryFramesAtIndexPath:(NSIndexPath *)indexPath
{
    
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    
    CGFloat nextViewYPosition = 9.0;
    NSMutableArray *viewList = [NSMutableArray new];
    
    if (![searchResult.data[@"headShot"] isEqual:[NSNull null]]) {
        
        UIImageView *headShot = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 12.0, 93.0, 119.0)];
        
        headShot.image = searchResult.data[@"headShot"];
        headShot.contentMode = UIViewContentModeScaleAspectFill;
        headShot.clipsToBounds = YES;
        
        // Useful for debuging - allows you to visualize exactually how label frames are positioned
        //headShot.layer.borderColor = [UIColor blackColor].CGColor;
        //headShot.layer.borderWidth = 1.0f;
        
        [viewList addObject:headShot];
    }
    
    // Set Name
    NSString *name = [NSString stringWithFormat:@"%@ %@", searchResult.data[@"firstName"], searchResult.data[@"lastName"]];
    UILabel *nameLabel = [self getDirectoryLabelForSearchResult:searchResult string:name font:HEADER_FONT yPosition:nextViewYPosition];
    [viewList addObject:nameLabel];
    nextViewYPosition = nameLabel.frame.origin.y + nameLabel.frame.size.height + CELL_VIEW_MARGIN;
    
    for (NSString *title in searchResult.data[@"title"]) {
        UILabel *titleLabel = [self getDirectoryLabelForSearchResult:searchResult string:title font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:titleLabel];
        nextViewYPosition += titleLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    if ([searchResult.data[@"department"] length] > 0) {
        UILabel *departmentLabel = [self getDirectoryLabelForSearchResult:searchResult string:searchResult.data[@"department"] font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:departmentLabel];
        nextViewYPosition = departmentLabel.frame.origin.y + departmentLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    if ([searchResult.data[@"office"] length] > 0) {
        UILabel *officeLabel = [self getDirectoryLabelForSearchResult:searchResult string:searchResult.data[@"office"] font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:officeLabel];
        nextViewYPosition = officeLabel.frame.origin.y + officeLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    if ([searchResult.data[@"email"] length] > 0) {
        UILabel *emailLabel = [self getDirectoryLabelForSearchResult:searchResult string:searchResult.data[@"email"] font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:emailLabel];
        nextViewYPosition = emailLabel.frame.origin.y + emailLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    if ([searchResult.data[@"phone"] length] > 0) {
        UILabel *phoneLabel = [self getDirectoryLabelForSearchResult:searchResult string:searchResult.data[@"phone"] font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:phoneLabel];
        nextViewYPosition = phoneLabel.frame.origin.y + phoneLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    for (NSString *degree in searchResult.data[@"degrees"]) {
        UILabel *degreeLabel = [self getDirectoryLabelForSearchResult:searchResult string:degree font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:degreeLabel];
        nextViewYPosition += degreeLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    if ([searchResult.data[@"homepage"] length] > 0) {
        UILabel *homepageLabel = [self getDirectoryLabelForSearchResult:searchResult string:searchResult.data[@"homepage"] font:NORMAL_FONT yPosition:nextViewYPosition];
        [viewList addObject:homepageLabel];
        nextViewYPosition = homepageLabel.frame.origin.y + homepageLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    
    return viewList;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.searchResults count] == 0) {
        return 70.0;
    }
    
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    CGFloat height;
    
    if ([searchResult.type isEqualToString:@"directory"]) {
        NSArray *labels = [self getDirectoryFramesAtIndexPath:indexPath];
        UILabel *lastLabel = (UILabel *)[labels lastObject];
        height = lastLabel.frame.origin.y + lastLabel.frame.size.height + CELL_VIEW_MARGIN;
    }
    else if ([searchResult.type isEqualToString:@"featured"] || [searchResult.type isEqualToString:@"pages"]) {
        NSArray *labels = [self getPageFramesAtIndexPath:indexPath];
        UILabel *lastLabel = (UILabel *)[labels lastObject];
        height = lastLabel.frame.origin.y + lastLabel.frame.size.height + CELL_VIEW_MARGIN;
        if (searchResult.data[@"headShot"] && ![searchResult.data[@"headShot"] isEqual:[NSNull null]]) {
            if (height < 125.0) {
                height = 125.0;
            }
        }
    }
    else {
        return 70.0;
    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    NSArray *views;
    
    if ([self.searchResults count] > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchResult" forIndexPath:indexPath];
    }
    else { // No results returned for query
        cell = [tableView dequeueReusableCellWithIdentifier:@"noResults" forIndexPath:indexPath];
        return cell;
    }
    
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    
    if ([searchResult.type isEqualToString:@"directory"]) {
        views = [self getDirectoryFramesAtIndexPath:indexPath];
    }
    else if ([searchResult.type isEqualToString:@"pages"] || [searchResult.type isEqualToString:@"featured"]) {
        views = [self getPageFramesAtIndexPath:indexPath];
    }
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (UIView *view in views) {
        [[cell contentView] addSubview:view];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchResults count] == 0) {
        return;
    }

    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];

    if ([searchResult.type isEqualToString:@"pages"] || [searchResult.type isEqualToString:@"featured"]) {
        [self performSegueWithIdentifier:@"page" sender:self];
    }
    else if ([searchResult.type isEqualToString:@"directory"]) {
        // TODO: Create new directory detail controller, perform segue to it
        [self performSegueWithIdentifier:@"directory" sender:self];
    }

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CCSearchResult *searchResult = [self.searchResults objectAtIndex: indexPath.row];
    
    
    if ([searchResult.type isEqualToString:@"pages"]) {
        CCWebViewController *detail = [segue destinationViewController];
        detail.url = searchResult.data[@"url"];
    }
    else if ([searchResult.type isEqualToString:@"directory"]) {
        
        CCDirectoryDetailTableViewController *detail = [segue destinationViewController];
        
        NSString *name = [NSString stringWithFormat:@"%@ %@", [searchResult.data objectForKey:@"firstName"], [searchResult.data objectForKey:@"lastName"]];
        NSString *title = [(NSArray *)[searchResult.data objectForKey:@"title"] objectAtIndex:0];
        NSString *department = [searchResult.data objectForKey:@"department"];
        NSString *email = [searchResult.data objectForKey:@"email"];
        NSString *phone = [searchResult.data objectForKey:@"phone"];
        NSString *building = [searchResult.data objectForKey:@"office"];
        
        CCPerson *person = [[CCPerson alloc] initWithName:name title:title department:department email:email phone:phone building:building];
        
        NSLog(@"person: %@, data: %@", person, searchResult.data);
        
        detail.person = person;
        
    }
}


@end
