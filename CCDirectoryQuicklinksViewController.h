//
//  CCDirectoryQuicklinksViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPersonController.h"

@interface CCDirectoryQuicklinksViewController : UIViewController

@property (nonatomic, strong) CCPersonController *quickLinksPeopleController;
@property (nonatomic, strong) CCPersonController *recentPeopleController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
