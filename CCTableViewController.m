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

@end
