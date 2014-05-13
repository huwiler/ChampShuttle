//
//  CCSearchMasterTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 4/28/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTableViewController.h"

@interface CCSearchMasterTableViewController : CCTableViewController

@property (copy, nonatomic) NSString *query;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end
