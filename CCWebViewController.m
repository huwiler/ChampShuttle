//
//  CCWebViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/26/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCWebViewController.h"

@interface CCWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIView *overlayView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CCWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoading];
    
    self.titleLabel.text = self.titleMessage ? self.titleMessage : @"Loading ...";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showLoading {
    self.webView.alpha = 0.0;
}

- (void)hideLoading {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    self.webView.alpha = 1.0;
    [UIView commitAnimations];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    [self hideLoading];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    [self hideLoading];
}

@end
