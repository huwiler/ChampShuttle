//
//  CCDirectoryDetailTableViewController.h
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPerson.h"

@interface CCDirectoryDetailTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *personTitle;
//@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *department;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) CCPerson *person;
//@property (weak, nonatomic) IBOutlet UILabel *name;
//@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (weak, nonatomic) IBOutlet UILabel *department;
//@property (weak, nonatomic) IBOutlet UILabel *location;
//@property (weak, nonatomic) IBOutlet UITableViewCell *phoneCell;
//@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;

@end
