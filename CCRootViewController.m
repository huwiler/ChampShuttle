//
//  CCRootViewController.m
//  ChampShuttle
//
//  Created by Matthew Huwiler on 4/11/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"

@interface CCRootViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogCountLabel;

@end

@implementation CCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Change the style of the status bar to be white
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Add a Search Bar to the Navigation Controller on this page
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search Champlain";
    searchBar.showsBookmarkButton = NO;
    [searchBar sizeToFit];
    self.navigationItem.titleView = searchBar;
    
    // Set frame of our ScrollView to the size of the screen then adjust to accomodate
    // Navigation Bar (44pts) and Status Bar (20pts) (64pts total)
    CGRect scrollViewRect = [UIScreen mainScreen].bounds;
    scrollViewRect.size.height -= 64.0;
    scrollViewRect.origin.y = 64;
    self.scrollView.frame = scrollViewRect;
    
    // Our Scroll View isn't automatically aware of the height of content added via the
    // Storyboard, so we must tell it explicitly here.
    [self.scrollView setContentSize:CGSizeMake(320, 504)];
    
    // Here we customize the badge-like labels for blogs and tweets buttons.
    self.blogCountLabel.alpha = 0;
    self.tweetCountLabel.alpha = 0;
    
    // Get only _id property of blogs since a certain date
    // https://forms.champlain.edu/pipes/blogs/nocontent/true/since/1397067089
    // NSDate *lastWeek  = [today dateByAddingTimeInterval: -1209600.0];
    
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
    
    // Check for new Blog posts
    [manager GET:getBlogsAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        // Draw label with rounded corners
        self.blogCountLabel.text = [NSString stringWithFormat:@"%i", [responseObject count]];
        self.blogCountLabel.layer.cornerRadius = 8;
        [self.blogCountLabel sizeToFit];
        CGRect blogCountLabelRect = self.blogCountLabel.frame;
        blogCountLabelRect.size.height = 25;
        blogCountLabelRect.size.width += 15;
        blogCountLabelRect.origin.x = 275 - blogCountLabelRect.size.width;
        self.blogCountLabel.frame = blogCountLabelRect;
        
        // Fade Label in
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ self.blogCountLabel.alpha = 1;} completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    // Check for new Twitter posts
    [manager GET:getTwitterAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Draw label with rounded corners
        self.tweetCountLabel.text = [NSString stringWithFormat:@"%i", [responseObject count]];
        self.tweetCountLabel.layer.cornerRadius = 8;
        [self.tweetCountLabel sizeToFit];
        CGRect tweetCountLabelRect = self.tweetCountLabel.frame;
        tweetCountLabelRect.size.height = 25;
        tweetCountLabelRect.size.width += 15;
        tweetCountLabelRect.origin.x = 275 - tweetCountLabelRect.size.width;
        self.tweetCountLabel.frame = tweetCountLabelRect;
        
        // Fade Label in
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{ self.tweetCountLabel.alpha = 1;} completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
