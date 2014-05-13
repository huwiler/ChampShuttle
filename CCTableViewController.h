//
//  CCTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/29/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCTableViewController : UITableViewController

@property (nonatomic, strong) UIView *overlayView;

-(void)showLoading;
-(void)hideLoading;

@end
