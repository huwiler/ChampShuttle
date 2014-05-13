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

@interface CCSearchMasterTableViewController ()

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

// This method uses our blog instances to determine the corresponding Table Cell
// height.  We use our custom getLabelRectForString method to calculate the height
// of each Label and add them together along with the image (if one is present)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    CGFloat imageHeight = blog.image ? 130.0 : 0.0;
    CGFloat titleHeight = [self getLabelRectForString:blog.title withFontSize:12.0].size.height;
    CGFloat descriptionHeight = [self getLabelRectForString:blog.description withFontSize:11.0].size.height;
    CGFloat authorHeight = [self getLabelRectForString:blog.author withFontSize:11.0].size.height;
    return (imageHeight + titleHeight + authorHeight + descriptionHeight + 20.0);*/
    return 50.0;
}

// This function is used to calculate the size of our Labels which is required
// by our Table View delegate methods in order to calculate the height of each cell
// as well as positioning labels relative to one another.
- (CGRect)getLabelRectForString:(NSString *)string withFontSize:(CGFloat)fontSize {
    
    // Max width and height of our Labels.  We are saying that at most labels
    // can have a 273 width; however, they can grow infinitely high depending
    // on content.
    CGSize constraint = CGSizeMake(273.0, CGFLOAT_MAX);
    
    // Attributed Strings manage NSStrings and their associated set of attributes.
    // It also has useful CGRect calculator functions that we can use to determine
    // the size of a label within our constraint.  This will be our key to
    // positioning and sizing our UILabels as well as calculating our Table Cell
    // height.
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: fontSize], NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    // This is were the calculation happens.  Using the Attributed string's
    // boundingRectWithSize and the bounding box constraint, we generate a rect
    // with an accurate height for a UILabel containing our text.
    CGRect rect = [attrString boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    // Here we set some defaults.  Origin represents (x,y) coordinates within
    // the parent view (the Table View Cell).  Size represents the width.
    // Our rect calculation above set width to the minimum size required to hold
    // our content.  Instead, we want to reset this back to the full width
    // of the original Label.
    rect.origin.x = 7;
    rect.size.width = constraint.width;
    
    return rect;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CCSearchResult *searchResult = [self.searchResults objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    
    NSLog(@"type: %@", searchResult.type);
    
    if ([searchResult.type isEqualToString:@"directory"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"directory" forIndexPath:indexPath];
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
