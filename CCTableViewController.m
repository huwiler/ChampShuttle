//
//  CCTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/29/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCTableViewController.h"

@implementation CCTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showLoading {
    //UIApplication* app = [UIApplication sharedApplication];
    //app.networkActivityIndicatorVisible = YES;
    
    CGRect frame = self.tableView.bounds;
    frame.origin.y = 60;
    
    self.overlayView = [[UIView alloc] initWithFrame:frame];
    self.overlayView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:1];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //spinner.center = self.overlayView.center;
    spinner.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.view.bounds.size.height / 2.0f);
    spinner.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin);
    
    //CGRect spinnerFrame = spinner.bounds;
    //spinnerFrame.origin.y -= 50;
    //spinner.frame = spinnerFrame;
    
    [self.overlayView addSubview:spinner];
    [spinner startAnimating];
    //[self.tableView addSubview:self.overlayView];
    //[self.tableView bringSubviewToFront:self.overlayView];
    [self.navigationController.view addSubview:self.overlayView];
    [self.navigationController.view bringSubviewToFront:self.overlayView];

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

@end
