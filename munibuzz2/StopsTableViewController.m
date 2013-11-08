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
    
    [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
//    [filteredStopsArray removeAllObjects];
    
    //save each keyword as a separate object in keyword array
    NSArray *keywordsList = [searchText componentsSeparatedByString:@" "];
    filteredStopsArray = [NSMutableArray arrayWithArray:stopsArray];

    //search stops array for each keyword object
    for (NSInteger idx=0; idx<[keywordsList count]; idx++) {
        NSString *keyword = [keywordsList objectAtIndex:idx];
        if ([keyword isEqual:@""]) {
            continue;
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",keyword];        filteredStopsArray = [NSMutableArray arrayWithArray:[filteredStopsArray filteredArrayUsingPredicate:predicate]];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredStopsArray count];
    } else {
        return [stopsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
- (void)tableView:(UITableView *) tableView
didSelectRowAtIndexPath:(NSIndexPath *__strong)indexPath
{
    Stops *stop;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        stop = [filteredStopsArray objectAtIndex:indexPath.row];
    } else {
        stop = [stopsArray objectAtIndex:indexPath.row];
    }
    
    if ([self.operation  isEqual: @"End"]) {
        // setting end will also reset start
        data.destLabel = [NSMutableString stringWithString:stop.title];
        data.startLabel = [NSMutableString stringWithString:DEFAULTLABEL];
        skipGetData = TRUE;
        
    } else if ([self.operation  isEqual: @"Start"]) {
        data.startLabel = [NSMutableString stringWithString:stop.title];
        if (![data.destLabel isEqualToString:data.startLabel]) {
            [rarray1 removeAllObjects];
            
            NSString *queryStr = [NSMutableString stringWithFormat:@"SELECT * FROM stops group by direction,stopid,route having title=\"%@\"", data.startLabel];
            [rarray1 setArray:[[RoutesDatabase database] RoutesInfo:[queryStr UTF8String]]];
            
            [self.class refreshDirectionArray:rarray1 rarray2:rarray2];
        }
        //change the start stop info
        if ([rarray1 count] > 0) {
            data.startStopTag = [NSMutableString stringWithString:[[rarray1 objectAtIndex:0] sTag]];
            data.startStopId = [NSMutableString stringWithString:[[rarray1 objectAtIndex:0] sId]];
            data.dirTag = [NSMutableString stringWithString:[[rarray1 objectAtIndex:0] dTag]];
        }
        if ([directionArray count] > 0) {
            data.routeId = [NSMutableString stringWithString:[[directionArray objectAtIndex:0] valueForKey:@"rId"]];
            data.dirTag = [NSMutableString stringWithString:[[directionArray objectAtIndex:0] valueForKey:@"dTag"]];
        } else {
            data.routeId = [NSMutableString stringWithString:@"-"];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//input:
//rarray1 contains all possible route directions for start stop
//rarray2 contains all possible route directions for end stop
//output:
//DirectionArray contains all possible routes for start and end stops
+ (void)refreshDirectionArray:(NSMutableArray*)rarray1
                      rarray2:(NSMutableArray*)rarray2
{
    [directionArray removeAllObjects];
    NSMutableString *queryStr = [[NSMutableString alloc] init];

    //find routes that contain both start and end stops, and put into NSArray routes
    Stops *stop1;
    Stops *stop2;
    for (NSInteger ii=0; ii < [rarray1 count]; ii++) {
        stop1 = [rarray1 objectAtIndex:ii];
        for (NSInteger jj=0; jj < [rarray2 count]; jj++) {
            stop2 = [rarray2 objectAtIndex:jj];
            if ([stop1.dTag isEqual:stop2.dTag]) {
                [queryStr setString:[NSString stringWithFormat:@"SELECT * FROM route_%@ group by key,tag having title=\"%@\"", stop1.dTag, stop1.title]];
                NSArray *tmp1 = [[RoutesDatabase database] DirectionsInfo:[queryStr UTF8String] direction:stop1.dTag route:stop1.rId];
                [queryStr setString:[NSString stringWithFormat:@"SELECT * FROM route_%@ group by key,tag having title=\"%@\"", stop2.dTag, stop2.title]];
                NSArray *tmp2 = [[RoutesDatabase database] DirectionsInfo:[queryStr UTF8String] direction:stop2.dTag route:stop2.rId];
                if ([tmp1 count] > 0 && [tmp2 count] > 0) {
                    stop1 = [tmp1 objectAtIndex:0];
                    stop2 = [tmp2 objectAtIndex:0];
                    if (stop1.key < stop2.key) {
                        NSDictionary *stopID = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:stop1.rId,stop1.dTag,nil] forKeys:[NSArray arrayWithObjects:@"rId",@"dTag",nil]];
                        [directionArray addObject:stopID];
                    }
                }
            }
        }
    }
    // remove duplicates
    [directionArray setArray:[[NSSet setWithArray:directionArray] allObjects]];
}

@end
