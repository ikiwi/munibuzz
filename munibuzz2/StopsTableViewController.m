//
//  StopsTableViewController.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "StopsTableViewController.h"
#import "Stops.h"

@interface StopsTableViewController ()

@end

@implementation StopsTableViewController
@synthesize stopsArray;
@synthesize filteredStopsArray;
@synthesize stopsSearchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stopsArray = [NSArray arrayWithObjects:
                  [Stops stopsId:@"4883" name:@"Geneva Ave & Madrid St"],
                  [Stops stopsId:@"4891" name:@"Geneva Ave & Naples St"],
                  [Stops stopsId:@"4888" name:@"Geneva Ave & Munich St"],
                  [Stops stopsId:@"4796" name:@"1650 Geneva Ave"],
                  [Stops stopsId:@"4799" name:@"1701 Geneva Ave"],
                  [Stops stopsId:@"7304" name:@"Geneva Ave & Carter"],
                  [Stops stopsId:@"6343" name:@"Santos St & Geneva Ave"],
                  [Stops stopsId:@"6345" name:@"Santos St & Velasco Ave"],
                  [Stops stopsId:@"6340" name:@"Santos St & Brookdale Ave"],
                  [Stops stopsId:@"6578" name:@"Sunnydale Ave & Santos St"],
                  [Stops stopsId:@"4937" name:@"Hahn St & Sunnydale Ave"],
                  [Stops stopsId:@"6853" name:@"Visitacion Ave & Sawyer St"],
                  [Stops stopsId:@"6846" name:@"Visitacion Ave & Britton St"],
                  [Stops stopsId:@"6855" name:@"Visitacion Ave & Schwerin St"],
                  [Stops stopsId:@"6848" name:@"Visitacion Ave & Cora St"],
                  [Stops stopsId:@"6851" name:@"Visitacion Ave & Rutland St"], nil];
    
    self.filteredStopsArray = [NSMutableArray arrayWithCapacity:[stopsArray count]];
    
    [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredStopsArray removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    filteredStopsArray = [NSMutableArray arrayWithArray:[stopsArray filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredStopsArray count];
    } else {
        return [stopsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Stops *stop = nil;
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        stop = [filteredStopsArray objectAtIndex:indexPath.row];
    } else {
        stop = [stopsArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = stop.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}


@end
