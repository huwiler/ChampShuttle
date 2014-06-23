//
//  CCDirectoryBrowseTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDirectoryBrowseItem.h"

@interface CCDirectoryBrowseTableViewController : UITableViewController

@property (nonatomic, strong) CCDirectoryBrowseItem *browseItem;
@property (strong, nonatomic) UIActivityIndicatorView *navActivityIndicator;
@property (nonatomic) BOOL error;

@end
