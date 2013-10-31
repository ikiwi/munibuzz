//
//  StopsTableViewController.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "StopsTableViewController.h"
#import "Stops.h"
#import "RoutesViewController.h"
#import "AppDelegate.h"
#import "RoutesDatabase.h"

@interface StopsTableViewController ()

@end

@implementation StopsTableViewController
@synthesize stopsArray;
@synthesize filteredStopsArray;
@synthesize stopsSearchBar;
@synthesize operation;

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
    
    stopsArray = [[RoutesDatabase database] RoutesInfo];


    self.filteredStopsArray = [NSMutableArray arrayWithCapacity:[stopsArray count]];
    
    [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredStopsArray removeAllObjects];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView || filtered == TRUE) {
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        stop = [filteredStopsArray objectAtIndex:indexPath.row];
    } else {
        stop = [stopsArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = stop.title;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

/* this function saves the user selected stop info which will be displayed in routes view */
- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *__strong)indexPath
{
    Stops *stop;
    if (tableView == self.searchDisplayController.searchResultsTableView || filtered == TRUE) {
        stop = [filteredStopsArray objectAtIndex:indexPath.row];
    } else {
        stop = [stopsArray objectAtIndex:indexPath.row];
    }
    
    if ([self.operation  isEqual: @"Start"]) {
        [data.startLabel setString:stop.title];
        
        [self.filteredStopsArray removeAllObjects];
        
        self.filteredStopsArray = [NSMutableArray arrayWithArray:[stopsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.dTag contains[c] %@",stop.dTag]]];
        filtered = TRUE;
        
        if (![data.destLabel isEqualToString:@"location"]) {
            //destination has already been selected, so now use the dTag and route from
            // the start stop, and get the stop tag and stop id.
            self.filteredStopsArray = [NSMutableArray arrayWithArray:[stopsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",data.startLabel]]];
            [data.startStopTag setString:[[self.filteredStopsArray objectAtIndex:0] sTag]];
            [data.startStopId setString:[[self.filteredStopsArray objectAtIndex:0] sId]];
            [data.routeLabel setString:[[self.filteredStopsArray objectAtIndex:0] rId]];
        }
    } else if ([self.operation  isEqual: @"End"]) {
        [data.destLabel setString:stop.title];
        [self.filteredStopsArray removeAllObjects];
        
        self.filteredStopsArray = [NSMutableArray arrayWithArray:[stopsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.dTag contains[c] %@",stop.dTag]]];
        if (![data.startLabel isEqualToString:@"location"]) {
            //start has been selected, now what we have to do is to use the dTag and route from
            // the destination stop, go through the origin array for the start location, and get
            // the stop tag and stop id with matching direction tag and start title.
            self.filteredStopsArray = [NSMutableArray arrayWithArray:[filteredStopsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",data.startLabel]]];
            [data.startStopTag setString:[[self.filteredStopsArray objectAtIndex:0] sTag]];
            [data.startStopId setString:[[self.filteredStopsArray objectAtIndex:0] sId]];
            [data.routeLabel setString:[[self.filteredStopsArray objectAtIndex:0] rId]];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
