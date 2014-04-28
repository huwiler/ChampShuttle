//
//  CCTweetsMasterTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/25/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCTweetsMasterTableViewController.h"
#import "AFNetworking.h"
#import "CCWebViewController.h"
#import "CCTweet.h"

@interface CCTweetsMasterTableViewController ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIView *overlayView;

- (CGRect)getLabelRectForText:(NSString *)string;

@end


@implementation CCTweetsMasterTableViewController

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
    
    // Show activity indicator animation in self.overlayView.  This will then
    // be removed once blog summaries have been downloaded.
    [self showLoading];
    
    // If blogs NSMutableArray property is nil, initialize it
    if (! self.tweets) {
        self.tweets = [NSMutableArray new];
    }
    
    // Remove table cell separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Retrieve blogs from blogs API
    // See https://github.com/AFNetworking/AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *getTweetsAPIURL = @"https://forms.champlain.edu/twitterapi/all/limit/50";
    [manager GET:getTweetsAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *obj in responseObject) {
            
            if (!([obj[@"screen_name"] isEqualToString:@"ChamplainEdu"] || [obj[@"screen_name"] isEqualToString:@"ChamplainNews"] || [obj[@"screen_name"] isEqualToString:@"champlib"] || [obj[@"screen_name"] isEqualToString:@"champlainonline"])) {
                NSLog(@"Unknown screen name: %@", obj[@"screen_name"]);
                continue;
            }
            
            CCTweet *tweet = [[CCTweet alloc] initWithID:obj[@"_id"] twitterID:obj[@"twitter_id"] link:obj[@"link"] screenName:obj[@"screen_name"] text:obj[@"text"] createdAt:obj[@"created_at"]];
            
            [self.tweets addObject:tweet];
            
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

#pragma mark - Activity Indicator

- (void)showLoading {
    //UIApplication* app = [UIApplication sharedApplication];
    //app.networkActivityIndicatorVisible = YES;
    self.overlayView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.overlayView.center;
    [self.overlayView addSubview:spinner];
    [spinner startAnimating];
    [self.tableView addSubview:self.overlayView];
    [self.tableView bringSubviewToFront:self.overlayView];
}

- (void)hideLoading {
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.overlayView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self.overlayView removeFromSuperview];
                     }
     ];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tweets count];
}

// The text field in table cells corresponding to the text of the tweet varies in height;
// this function calculates the height of that label and returns its frame.  This is used
// in heightForRowAtIndexPath as well as cellForRowAtIndexPath.
- (CGRect)getLabelRectForText:(NSString *)string {
    
    CGSize constraint = CGSizeMake(235.0, CGFLOAT_MAX);
    
    NSDictionary *fontAttributes = @{
                                     NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor]
                                     };
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:fontAttributes];
    
    CGRect rect = [attrString boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    rect.origin.x = 53;
    rect.origin.y = 32;
    
    rect.size.width = constraint.width;
    
    return rect;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    CGFloat textHeight = [self getLabelRectForText:tweet.text].size.height;
    CGFloat rowHeight = 32.0 + textHeight;
    return rowHeight > 70.0 ? rowHeight : 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CCTweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tweet.screenName forIndexPath:indexPath];
    
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1];
    
    // Display date like m/d e.g. "Apr 23"
    NSDate *createdAt = [NSDate dateWithTimeIntervalSince1970:[tweet.createdAt doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *format = [dateFormatter dateFormat];
    format = [format stringByReplacingOccurrencesOfString:@"," withString:@""];
    format = [format stringByReplacingOccurrencesOfString:@"y" withString:@""];
    [dateFormatter setDateFormat:format];
    NSString *createdAtString = [dateFormatter stringFromDate:createdAt];
    
    dateLabel.text = createdAtString;
    textLabel.text = tweet.text;
    
    // Calculate new frames for our Labels using our CGRect calculator
    textLabel.frame = [self getLabelRectForText:tweet.text];
    
    return cell;
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CCTweet *tweet = [self.tweets objectAtIndex: indexPath.row];
    CCWebViewController *detail = [segue destinationViewController];
    detail.url = tweet.link;
    detail.titleMessage = @"Loading tweet ...";
    detail.title = @"Twitter";
}


@end
