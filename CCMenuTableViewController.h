//
//  CCMenuTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCMenuTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, copy) NSString *weekTitle;
@property (nonatomic) BOOL loading;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewWebsiteButton;

@end
