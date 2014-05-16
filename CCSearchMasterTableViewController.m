//
//  CCSearchMasterTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/28/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCSearchMasterTableViewController.h"
#import "AFNetworking.h"
#import "CCSearchResult.h"

#define CELLSPACING 4.0

@interface CCSearchMasterTableViewController ()

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
    
    NSLog(@"Getting to search with %@", self.query);
    
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
    
    [manager GET:searchAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Getting to response handler.");
        
        NSDictionary *response = (NSDictionary *)responseObject;
        NSArray *hits = response[@"hits"][@"hits"];
        
        for (NSDictionary *result in hits) {
            
            NSDictionary *data;
            NSDictionary *obj = result[@"_source"];
            
            //NSLog(@"type: %@", result[@"_type"]);
            
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
                         @"deparment": obj[@"api_department"] ? [obj[@"api_department"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"office": obj[@"api_office"] ? [obj[@"api_office"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"phone": obj[@"api_phone"] ? [obj[@"api_phone"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"",
                         @"title": titles,
                         @"degrees": degrees,
                         @"homepage": obj[@"api_homepage"] ? [obj[@"api_homepage"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @""
                         };
            }
            else if ([result[@"_type"] isEqualToString:@"featured"]) {
                
                if (!obj[@"loc"] || !obj[@"featured_title"] || !obj[@"featured_abstract"]) {
                    continue;
                }
                
                data = @{
                         @"url": [obj[@"loc"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"title": [obj[@"featured_title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"description": [obj[@"featured_abstract"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                         };
            }
            else if ([result[@"_type"] isEqualToString:@"pages"]) {
                
                if (!obj[@"loc"] || !obj[@"title"] || !obj[@"description"]) {
                    continue;
                }
                
                data = @{
                         @"url": [obj[@"loc"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"title": [obj[@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                         @"description": [obj[@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                         };
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
    return [self.searchResults count];

}

- (CGRect)getLabelRectForString:(NSString *)string font:(UIFont *)font constraint:(CGSize)constraint xPosition:(CGFloat)x yPosition:(CGFloat)y {
    
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    CGRect rect = [attrString boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    rect.origin.y = y;
    rect.origin.x = x;
    rect.size.width = constraint.width;
    
    return rect;
}

- (NSArray *) getDirectoryFramesAtIndexPath:(NSIndexPath *)indexPath
{
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    UIFont *normalFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0];
    CGSize constraint;
    CGFloat nextViewYPosition = 0.0;
    NSMutableArray *labelList = [NSMutableArray new];
    
    // Set Name
    NSString *name = [NSString stringWithFormat:@"%@ %@", searchResult.data[@"firstName"], searchResult.data[@"lastName"]];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    nameLabel.font = headerFont;
    nameLabel.layer.borderColor = [UIColor blackColor].CGColor;
    nameLabel.layer.borderWidth = 1.0f;
    nameLabel.text = name;
    
    CGFloat yPosition = 5.0;
    CGFloat xPosition;
    
    if (![searchResult.data[@"headShot"] isEqual:[NSNull null]]) {
        constraint = CGSizeMake(143.0, CGFLOAT_MAX);
        xPosition = 109.0;
    }
    else {
        constraint = CGSizeMake(243.0, CGFLOAT_MAX);
        xPosition = 9.0;
    }
    nameLabel.frame = [self getLabelRectForString:name font:headerFont constraint:constraint xPosition:xPosition yPosition:yPosition];
    
    [labelList addObject:nameLabel];
    
    nextViewYPosition = nameLabel.frame.origin.y + nameLabel.frame.size.height + CELLSPACING;
    
    for (NSString *title in searchResult.data[@"title"]) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        titleLabel.font = normalFont;
        titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
        titleLabel.layer.borderWidth = 1.0f;
        titleLabel.text = title;
        
        CGSize constraint;
        CGFloat yPosition = nextViewYPosition;
        CGFloat xPosition;
        if (![searchResult.data[@"headShot"] isEqual:[NSNull null]]) {
            constraint = CGSizeMake(143.0, CGFLOAT_MAX);
            xPosition = 109.0;
        }
        else {
            constraint = CGSizeMake(243.0, CGFLOAT_MAX);
            xPosition = 9.0;
        }
        
        titleLabel.frame = [self getLabelRectForString:title font:normalFont constraint:constraint xPosition:xPosition yPosition:yPosition];
        
        [labelList addObject:titleLabel];
        
        nextViewYPosition += titleLabel.frame.size.height + CELLSPACING;
        
    }
    
    return labelList;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    
    if ([searchResult.type isEqualToString:@"directory"]) {
        
        NSArray *labels = [self getDirectoryFramesAtIndexPath:indexPath];
        UILabel *lastLabel = (UILabel *)[labels lastObject];
        
        return lastLabel.frame.origin.y + lastLabel.frame.size.height + CELLSPACING;
    }
    else {
        return 50.0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    
    if ([searchResult.type isEqualToString:@"directory"]) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"directory" forIndexPath:indexPath];
        
        NSArray *labels = [self getDirectoryFramesAtIndexPath:indexPath];
        
        for (UILabel *label in labels) {
            [[cell contentView] addSubview:label];
        }
        
    }
    else if ([searchResult.type isEqualToString:@"pages"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"pages" forIndexPath:indexPath];
    }
    else if ([searchResult.type isEqualToString:@"featured"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"featured" forIndexPath:indexPath];
    }
    
    return cell;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
