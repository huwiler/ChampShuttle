//
//  CCMenuDetailTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMenuDay.h"
#import "CCMenuItemController.h"

@interface CCMenuDetailTableViewController : UITableViewController

@property (nonatomic, strong) CCMenuDay *day;

// Populated when initially loaded
@property (nonatomic, strong) CCMenuItemController *lunch;
@property (nonatomic, strong) CCMenuItemController *dinner;
@property (nonatomic, copy) NSString *weekTitle;

@end
