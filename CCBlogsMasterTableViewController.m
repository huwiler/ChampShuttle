//
//  CCBlogsMasterTableViewController.m
//  ChampShuttle
//
//  Created by Matthew Huwiler on 4/15/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCBlogsMasterTableViewController.h"
#import "CCWebViewController.h"
#import "AFNetworking.h"
#import "CCBlog.h"

@interface CCBlogsMasterTableViewController ()

@property (nonatomic, strong) NSMutableArray *blogs;
@property (nonatomic, strong) UIView *overlayView;

- (CGRect)getLabelRectForString:(NSString *)string withFontSize:(CGFloat)fontSize andStyle:(NSString *)style;

@end

@implementation CCBlogsMasterTableViewController

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
    if (! self.blogs) {
        self.blogs = [NSMutableArray new];
    }
    
    // Remove table cell separator
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Retrieve blogs from blogs API
    // See https://github.com/AFNetworking/AFNetworking
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *getBlogsAPIURL = @"https://forms.champlain.edu/pipes/blogs/limit/30/ios/true";
    [manager GET:getBlogsAPIURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *obj in responseObject) {
            
            // Load image
            UIImage *featuredImage = [obj[@"image"] length] > 0 ? [
                UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj[@"image"]]]
            ] : nil;
            
            CCBlog *blog = [[CCBlog alloc] initWithID:obj[@"_id"] title:obj[@"title"] type:obj[@"type"] link:obj[@"link"] author:obj[@"author"] description:obj[@"description"] published:obj[@"published"] image:featuredImage];
            
            [self.blogs addObject:blog];
            
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
}

#pragma mark - Web View

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoading];
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
    return [self.blogs count];
}

// This function is used to calculate the size of our Labels which is required
// by our Table View delegate methods in order to calculate the height of each cell
// as well as positioning labels relative to one another.
- (CGRect)getLabelRectForString:(NSString *)string withFontSize:(CGFloat)fontSize andStyle:(NSString *)style {
    
    // Max width and height of our Labels.  We are saying that at most labels
    // can have a 273 width; however, they can grow infinitely high depending
    // on content.
    CGSize constraint = CGSizeMake(273.0, CGFLOAT_MAX);
    
    // Attributed Strings manage NSStrings and their associated set of attributes.
    // It also has useful CGRect calculator functions that we can use to determine
    // the size of a label within our constraint.  This will be our key to
    // positioning and sizing our UILabels as well as calculating our Table Cell
    // height.
    UIFont *font;
    
    if ([style isEqualToString:@"thin"]) {
        font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:fontSize];
    }
    else {
        font = [UIFont systemFontOfSize: fontSize];
    }
    
    NSDictionary *fontAttributes = @{
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: [UIColor lightGrayColor]
        };
    NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:fontAttributes];
    
    //NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    //NSAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: fontSize], NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
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

// This method uses our blog instances to determine the corresponding Table Cell
// height.  We use our custom getLabelRectForString method to calculate the height
// of each Label and add them together along with the image (if one is present)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCBlog *blog = [self.blogs objectAtIndex:indexPath.row];
    CGFloat imageHeight = blog.image ? 135.0 : 0.0;
    CGFloat titleHeight = [self getLabelRectForString:blog.title withFontSize:12.0 andStyle:nil].size.height;
    CGFloat blogTypeHeight = [self getLabelRectForString:blog.type withFontSize:11.0 andStyle:nil].size.height;
    CGFloat descriptionHeight = [self getLabelRectForString:blog.description withFontSize:12.0 andStyle:@"thin"].size.height;
    CGFloat authorHeight = [self getLabelRectForString:blog.author withFontSize:11.0 andStyle:nil].size.height;
    return (imageHeight + titleHeight + blogTypeHeight + authorHeight + descriptionHeight + 30.0);
}

- (void)tableView: (UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Alternate cell background colors
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];;
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Here we get a copy of our prototype cell using the Identifier we set for it in
    // Attributes Inspector
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blogCell" forIndexPath:indexPath];
    
    // Here we're grabbing references to our label and image views using tags set in
    // Attributes Inspector for the labels and image view inside our custom table cell
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *blogTypeLabel = (UILabel *)[cell viewWithTag:5];
    UILabel *authorLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:3];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:4];
    
    // Get a reference to the blog object corresponding to this Table cell
    CCBlog *blog = [self.blogs objectAtIndex:indexPath.row];
    
    NSDate *published = [NSDate dateWithTimeIntervalSince1970:[blog.published doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *publishedString = [dateFormatter stringFromDate:published];
    
    // Set Label text
    titleLabel.text = blog.title;
    descriptionLabel.text = blog.description;
    authorLabel.text = [NSString stringWithFormat:@"by %@ on %@", blog.author, publishedString];
    blogTypeLabel.text = [NSString stringWithFormat:@"from %@", blog.type];
    
    // Calculate new frames for our Labels using our CGRect calculator
    CGRect titleRect = [self getLabelRectForString:blog.title withFontSize:12.0 andStyle:nil];
    CGRect descriptionRect = [self getLabelRectForString:blog.description withFontSize:12.0 andStyle:@"thin"];
    CGRect authorRect = [self getLabelRectForString:blog.author withFontSize:11.0 andStyle:nil];
    CGRect blogTypeRect = [self getLabelRectForString:blog.type withFontSize:11.0 andStyle:nil];
    
    // An arbitrary amount of space that we're placing between Views so they aren't
    // stacked flush on top of each other
    CGFloat topBottomMargin = 3.0;
    
    // Here we calculate the vertical position of our Labels based on the size of
    // views before them, whether or not there was an image associated with the blog,
    // and an arbitrary margin.
    CGFloat imageHieght = blog.image ? 130.0 + topBottomMargin : 5.0;
    titleRect.origin.y = imageHieght + topBottomMargin * 2.0;
    blogTypeRect.origin.y = imageHieght + titleRect.size.height + topBottomMargin * 3.0;
    authorRect.origin.y = imageHieght + titleRect.size.height + blogTypeRect.size.height + topBottomMargin * 4.0;
    descriptionRect.origin.y = imageHieght + authorRect.size.height + titleRect.size.height + blogTypeRect.size.height + topBottomMargin * 5.0;
    
    titleLabel.frame = titleRect;
    authorLabel.frame = authorRect;
    descriptionLabel.frame = descriptionRect;
    blogTypeLabel.frame = blogTypeRect;
    
    imageView.image = blog.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CCBlog *blog = [self.blogs objectAtIndex: indexPath.row];
        CCWebViewController *detail = [segue destinationViewController];
        detail.url = blog.link;
        detail.titleMessage = @"Loading blog ...";
        //detail.title = @"Blog";
    }
}


@end
