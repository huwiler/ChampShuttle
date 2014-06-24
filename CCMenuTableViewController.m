//
//  CCMenuTableViewController.m
//  ChampShuttle
//
//  Created by Matt Huwiler on 6/23/14.
//  Copyright (c) 2014 Champlain College. All rights reserved.
//

#import "CCMenuTableViewController.h"
#import "CCWebViewController.h"
#import "CCMenuDetailTableViewController.h"
#import "AFNetworking.h"

@interface CCMenuTableViewController ()

@end

@implementation CCMenuTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDiningWebsite"]) {
        CCWebViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.url = @"https://cosmosweb.champlain.edu/menu/WeeklyMenu.htm";
    }
    else if ([[segue identifier] isEqualToString:@"showitems"]) {
        CCMenuDetailTableViewController *detailViewController = [segue destinationViewController];
        
        CCMenuDay *day = [self.days objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        detailViewController.day = day;
        detailViewController.weekTitle = self.weekTitle;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     // Set up navigation activity indicator
     if (self.navActivityIndicator == nil) {
     self.navActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
     UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.navActivityIndicator];
     [self navigationItem].rightBarButtonItem = barButton;
     }
     */
    
    //self.menuItemController = [[MenuItemController alloc] init];
    
    if ([self.days count] == 0) {
        
        self.loading = YES;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        // [self.searchBar startActivity];
        [manager GET:@"http://search.champlain.edu/js/menu.js" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (self.days == nil) {
                self.days = [[NSMutableArray alloc] init];
            }
            
            CCMenuDay *monday = [[CCMenuDay alloc] initWithTitle:@"Monday"];
            CCMenuDay *tuesday = [[CCMenuDay alloc] initWithTitle:@"Tuesday"];
            CCMenuDay *wednesday = [[CCMenuDay alloc] initWithTitle:@"Wednesday"];
            CCMenuDay *thursday = [[CCMenuDay alloc] initWithTitle:@"Thursday"];
            CCMenuDay *friday = [[CCMenuDay alloc] initWithTitle:@"Friday"];
            CCMenuDay *saturday = [[CCMenuDay alloc] initWithTitle:@"Saturday"];
            CCMenuDay *sunday = [[CCMenuDay alloc] initWithTitle:@"Sunday"];
            
            self.weekTitle = [responseObject objectForKey:@"date"];
            
            id menu = [responseObject objectForKey:@"menu"];
            
            // Get Monday items
            if ([menu objectForKey:@"monday"] != [NSNull null]) {
                
                id day = [menu objectForKey:@"monday"];
                id lunch = [day objectForKey:@"lunch"];
                id dinner = [day objectForKey:@"lunch"];
                
                // Get lunch
                if (lunch != [NSNull null]) {
                    for (id item in lunch) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [monday addMenuItemWithTitle:title badges:badges day:@"monday" station:station type:@"lunch"];
                    }
                }
                
                // Get dinner
                if (lunch != [NSNull null]) {
                    for (id item in dinner) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [monday addMenuItemWithTitle:title badges:badges day:@"monday" station:station type:@"dinner"];
                    }
                }
            }
            
            // Get Tuesday items
            if ([menu objectForKey:@"tuesday"] != [NSNull null]) {
                
                id day = [menu objectForKey:@"tuesday"];
                id lunch = [day objectForKey:@"lunch"];
                id dinner = [day objectForKey:@"lunch"];
                
                // Get lunch
                if (lunch != [NSNull null]) {
                    for (id item in lunch) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [tuesday addMenuItemWithTitle:title badges:badges day:@"tuesday" station:station type:@"lunch"];
                    }
                }
                
                // Get dinner
                if (lunch != [NSNull null]) {
                    for (id item in dinner) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [tuesday addMenuItemWithTitle:title badges:badges day:@"tuesday" station:station type:@"dinner"];
                    }
                }
            }
            
            // Get Wednesday items
            if ([menu objectForKey:@"wednesday"] != [NSNull null]) {
                
                id day = [menu objectForKey:@"wednesday"];
                id lunch = [day objectForKey:@"lunch"];
                id dinner = [day objectForKey:@"lunch"];
                
                // Get lunch
                if (lunch != [NSNull null]) {
                    for (id item in lunch) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [wednesday addMenuItemWithTitle:title badges:badges day:@"wednesday" station:station type:@"lunch"];
                    }
                }
                
                // Get dinner
                if (lunch != [NSNull null]) {
                    for (id item in dinner) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [wednesday addMenuItemWithTitle:title badges:badges day:@"wednesday" station:station type:@"dinner"];
                    }
                }
            }
            
            // Get Thursday items
            if ([menu objectForKey:@"thursday"] != [NSNull null]) {
                
                id day = [menu objectForKey:@"thursday"];
                id lunch = [day objectForKey:@"lunch"];
                id dinner = [day objectForKey:@"lunch"];
                
                // Get lunch
                if (lunch != [NSNull null]) {
                    for (id item in lunch) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [thursday addMenuItemWithTitle:title badges:badges day:@"thursday" station:station type:@"lunch"];
                    }
                }
                
                // Get dinner
                if (lunch != [NSNull null]) {
                    for (id item in dinner) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [thursday addMenuItemWithTitle:title badges:badges day:@"thursday" station:station type:@"dinner"];
                    }
                }
            }
            
            // Get Friday items
            if ([menu objectForKey:@"friday"] != [NSNull null]) {
                
                id day = [menu objectForKey:@"friday"];
                id lunch = [day objectForKey:@"lunch"];
                id dinner = [day objectForKey:@"lunch"];
                
                // Get lunch
                if (lunch != [NSNull null]) {
                    for (id item in lunch) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [friday addMenuItemWithTitle:title badges:badges day:@"friday" station:station type:@"lunch"];
                    }
                }
                
                // Get dinner
                if (lunch != [NSNull null]) {
                    for (id item in dinner) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [friday addMenuItemWithTitle:title badges:badges day:@"friday" station:station type:@"dinner"];
                    }
                }
            }
            
            // Get Saturday items
            if ([menu objectForKey:@"saturday"] != [NSNull null]) {
                
                id day = [menu objectForKey:@"saturday"];
                id lunch = [day objectForKey:@"lunch"];
                id dinner = [day objectForKey:@"lunch"];
                
                // Get lunch
                if (lunch != [NSNull null]) {
                    for (id item in lunch) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [saturday addMenuItemWithTitle:title badges:badges day:@"saturday" station:station type:@"lunch"];
                    }
                }
                
                // Get dinner
                if (lunch != [NSNull null]) {
                    for (id item in dinner) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [saturday addMenuItemWithTitle:title badges:badges day:@"saturday" station:station type:@"dinner"];
                    }
                }
            }
            
            // Get Friday items
            if ([menu objectForKey:@"sunday"] != [NSNull null]) {
                
                id day = [menu objectForKey:@"sunday"];
                id lunch = [day objectForKey:@"lunch"];
                id dinner = [day objectForKey:@"lunch"];
                
                // Get lunch
                if (lunch != [NSNull null]) {
                    for (id item in lunch) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        
                        [sunday addMenuItemWithTitle:title badges:badges day:@"sunday" station:station type:@"lunch"];
                    }
                }
                
                // Get dinner
                if (lunch != [NSNull null]) {
                    for (id item in dinner) {
                        NSString *title = [item objectForKey:@"name"];
                        NSString *station = [item objectForKey:@"station"];
                        NSMutableArray *badges = [[item objectForKey:@"badges"] mutableCopy];
                        [sunday addMenuItemWithTitle:title badges:badges day:@"sunday" station:station type:@"dinner"];
                    }
                }
            }
            
            if ([[monday menuItems] countOfList] > 0) {
                [self.days addObject:monday];
            }
            if ([[tuesday menuItems] countOfList] > 0) {
                [self.days addObject:tuesday];
            }
            if ([[wednesday menuItems] countOfList] > 0) {
                [self.days addObject:wednesday];
            }
            if ([[thursday menuItems] countOfList] > 0) {
                [self.days addObject:thursday];
            }
            if ([[friday menuItems] countOfList] > 0) {
                [self.days addObject:friday];
            }
            if ([[saturday menuItems] countOfList] > 0) {
                [self.days addObject:saturday];
            }
            if ([[sunday menuItems] countOfList] > 0) {
                [self.days addObject:sunday];
            }
            
            self.loading = NO;
            
            // Refresh Table UI
            
            // non-animated version
            [self.tableView reloadData];
            
            // animated
            //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
    else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setViewWebsiteButton:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.days != nil && [self.days count] > 1) {
        return [self.days count];
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (self.days != nil && [self.days count] > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"day"];
        
        CCMenuDay *day = [self.days objectAtIndex:indexPath.row];
        
        UILabel *dayLabel = (UILabel *)[cell viewWithTag:2];
        dayLabel.text = [day title];
    }
    else if (self.days == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"loading"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"error"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([self.days count] > 0) {
        return self.weekTitle;
    }
    else {
        return @"";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
