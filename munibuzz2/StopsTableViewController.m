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
    
    stopsArray = [NSArray arrayWithObjects:
                  [Stops stopsId:@"4883" title:@"Geneva Ave & Madrid St" sId:@"14883" dTag:@"08X__IB"],
                  [Stops stopsId:@"4891" title:@"Geneva Ave & Naples St" sId:@"14891" dTag:@"08X__IB"],
                  [Stops stopsId:@"4888" title:@"Geneva Ave & Munich St" sId:@"14888" dTag:@"08X__IB"],
                  [Stops stopsId:@"4796" title:@"1650 Geneva Ave" sId:@"14796" dTag:@"08X__IB"],
                  [Stops stopsId:@"4799" title:@"1701 Geneva Ave" sId:@"17304" dTag:@"08X__IB"],
                  [Stops stopsId:@"7304" title:@"Geneva Ave & Carter" sId:@"16343" dTag:@"08X__IB"],
                  [Stops stopsId:@"6343" title:@"Santos St & Geneva Ave" sId:@"16343" dTag:@"08X__IB"],
                  [Stops stopsId:@"6345" title:@"Santos St & Velasco Ave" sId:@"16345" dTag:@"08X__IB"],
                  [Stops stopsId:@"6340" title:@"Santos St & Brookdale Ave" sId:@"16340" dTag:@"08X__IB"],
                  [Stops stopsId:@"6578" title:@"Sunnydale Ave & Santos St" sId:@"16578" dTag:@"08X__IB"],
                  [Stops stopsId:@"4937" title:@"Hahn St & Sunnydale Ave" sId:@"14937" dTag:@"08X__IB"],
                  [Stops stopsId:@"6853" title:@"Visitacion Ave & Sawyer St" sId:@"16853" dTag:@"08X__IB"],
                  [Stops stopsId:@"6846" title:@"Visitacion Ave & Britton St" sId:@"16846" dTag:@"08X__IB"],
                  [Stops stopsId:@"6855" title:@"Visitacion Ave & Schwerin St" sId:@"16855" dTag:@"08X__IB"],
                  [Stops stopsId:@"6848" title:@"Visitacion Ave & Cora St" sId:@"16848" dTag:@"08X__IB"],
                  [Stops stopsId:@"6851" title:@"Visitacion Ave & Rutland St" sId:@"16851" dTag:@"08X__IB"], nil];
    
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        stop = [filteredStopsArray objectAtIndex:indexPath.row];
    } else {
        stop = [stopsArray objectAtIndex:indexPath.row];
    }
    
    if ([self.operation  isEqual: @"Start"]) {
        [data.startLabel setString:stop.title];
        if (![data.destLabel isEqualToString:@"location"]) {
            //destination has already been selected, so now use the dTag and route from
            // the start stop, and get the stop tag and stop id.
            [self.filteredStopsArray removeAllObjects];
            
            filteredStopsArray = [NSMutableArray arrayWithArray:[stopsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",data.startLabel]]];
            [data.startStopTag setString:[[filteredStopsArray objectAtIndex:0] sTag]];
            [data.startStopId setString:[[filteredStopsArray objectAtIndex:0] sId]];
        }
    } else if ([self.operation  isEqual: @"End"]) {
        [data.destLabel setString:stop.title];
        if (![data.startLabel isEqualToString:@"location"]) {
            //start has been selected, now what we have to do is to use the dTag and route from
            // the destination stop, go through the origin array for the start location, and get
            // the stop tag and stop id with matching direction tag and start title.
            [self.filteredStopsArray removeAllObjects];

            filteredStopsArray = [NSMutableArray arrayWithArray:[stopsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.dTag contains[c] %@",stop.dTag]]];
            filteredStopsArray = [NSMutableArray arrayWithArray:[filteredStopsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",data.startLabel]]];
            [data.startStopTag setString:[[filteredStopsArray objectAtIndex:0] sTag]];
            [data.startStopId setString:[[filteredStopsArray objectAtIndex:0] sId]];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
