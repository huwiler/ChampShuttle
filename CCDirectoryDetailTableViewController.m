//
//  CCDirectoryDetailTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/21/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCDirectoryDetailTableViewController.h"
#import "CCPerson.h"

@interface CCDirectoryDetailTableViewController ()

@end

@implementation CCDirectoryDetailTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.name.text = self.person.name;
    self.personTitle.text = self.person.title;
    self.department.text = self.person.department;
    self.location.text = self.person.building;
    self.emailCell.textLabel.text = @"Email";
    self.emailCell.detailTextLabel.text = self.person.email;
    self.phoneCell.textLabel.text = @"Phone";
    self.phoneCell.detailTextLabel.text = self.person.phone;
    
    
    // Each time the person detail page is loaded, save him/her to recents so they appear
    //  in quicklinks.
    NSMutableArray *newRecentPeopleArray;
    NSData *oldRecentPeopleData = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentPeople"];
    
    if (oldRecentPeopleData != nil) {
        NSArray *oldRecentPeopleArray = [NSKeyedUnarchiver unarchiveObjectWithData:oldRecentPeopleData];
        if (oldRecentPeopleArray != nil) {
            newRecentPeopleArray = [[NSMutableArray alloc] initWithArray:oldRecentPeopleArray];
        }
    }
    if (newRecentPeopleArray == nil) {
        newRecentPeopleArray = [[NSMutableArray alloc] init];
    }
    
    // Remove person from list if already exists.
    for (int i = 0; i < [newRecentPeopleArray count]; i++) {
        CCPerson *oldPerson = (CCPerson *)[newRecentPeopleArray objectAtIndex:i];
        if ([oldPerson.name isEqualToString:self.person.name]) {
            [newRecentPeopleArray removeObjectAtIndex:i];
            i--;
        }
    }
    
    // Add new element to recent people array
    [newRecentPeopleArray addObject:self.person];
    
    // Shorten the array to be only 10 elements big.
    if ([newRecentPeopleArray count] > 10) {
        [newRecentPeopleArray removeObjectAtIndex:0];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newRecentPeopleArray] forKey:@"recentPeople"];
}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setTitle:nil];
    [self setDepartment:nil];
    [self setLocation:nil];
    [self setPhoneCell:nil];
    [self setEmailCell:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *phone = self.person.phone;
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[1\\D]*(\\d{3})\\D*(\\d{3})\\D*(\\d{4}).*" options:0 error:&error];
        NSString *formattedNumber = [regex stringByReplacingMatchesInString:phone options:0 range:NSMakeRange(0, [phone length]) withTemplate:@"tel:1-$1-$2-$3"];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:formattedNumber]];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        NSString *email = [NSString stringWithFormat:@"mailto:%@", self.person.email];
        NSURL* emailURL = [NSURL URLWithString:email];
        [[UIApplication sharedApplication] openURL:emailURL];
    }
}

@end
