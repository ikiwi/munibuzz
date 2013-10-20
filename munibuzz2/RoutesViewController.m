//
//  RoutesViewController.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//
/*
1. load all the route files in its corresponding routeDataArray
2. search each routeDataArray file for the stop title
3. save inbound and outbound stop tags and stop ids, in routesArray
routeTag,
{stop tag, stop title, stop id, direction tag},
{stop tag, stop title, stop id, direction tag},...
4. if the stop title is found in a route file,
for start label, add all the stops into stop search array
for destination label, filter stops to only include stops after start title
5. repeat 1, 2, 3 for each route, and save it into the routesArray
6. once destination is selected, save the route id,
search for the stopId for the matching routeTag and directionTag
*/

#import "RoutesViewController.h"
#import "StopsTableViewController.h"
#import "RepeatTableViewController.h"
#import "ReminderTableViewController.h"
#import "AppDelegate.h"
#import "Trip.h"
#import "BuzzViewController.h"

@interface RoutesViewController ()

@end

@implementation RoutesViewController
@synthesize tripArray;
@synthesize startCell;
@synthesize destCell;
@synthesize routeCell;
@synthesize remindCell;
@synthesize repeatCell;
@synthesize useDefaultCell;
@synthesize includeReturnCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Routes";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isEdit == TRUE) {
        filename = [NSString stringWithFormat:@"data%ld.model",currentTrip];
        data = [Data getData:filename];
    } else {
        currentTrip = totalTrip;
        filename = [NSString stringWithFormat:@"data%ld.model",currentTrip];
        data = [[Data alloc] init];
    }
    [data.routeId setString:@"8X"];
    [data.routeLabel setString:@"8X-BayshoreExpress"];

    NSArray *subArray1 = [NSArray arrayWithObjects:
                 [Trip tripId:@"Start" desc:data.startLabel],
                 [Trip tripId:@"End" desc:data.destLabel],
                 [Trip tripId:@"Route" desc:data.routeLabel],
                 [Trip tripId:@"Include return journey" desc:@""], nil];
    NSArray *subArray2 = [NSArray arrayWithObjects:
                 [Trip tripId:@"Use default" desc:@""],
                 [Trip tripId:@"Remind me" desc:@"None"],
                 [Trip tripId:@"Repeat reminder" desc:@"Never"], nil];
    
    tripArray = [NSArray arrayWithObjects:subArray1,subArray2,nil];

    if ([data.useDefault isEqual:@"NO"]) {
        useDefaultSwitch = FALSE;
    } else {
        useDefaultSwitch = TRUE;
        [data.useDefault setString:@"YES"];
    }
    if ([data.includeReturn isEqual:@"YES"]) {
        includeReturnSwitch = TRUE;
    } else {
        includeReturnSwitch = FALSE;
        [data.includeReturn setString:@"NO"];
    }
    
//    [Data saveData:data filename:filename];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tripArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [[tripArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Trip *trip = [[self.tripArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = trip.name;
    cell.detailTextLabel.text = trip.desc;
    
    if ([trip.name  isEqual: @"Start"]) {
        startCell = cell;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    } else if ([trip.name  isEqual: @"End"]) {
        destCell = cell;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    } else if ([trip.name isEqual: @"Route"]) {
        routeCell = cell;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    } else if ([trip.name isEqual: @"Use default"]) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0,0,0,0)];
        cell.accessoryView =  switchView;
        useDefaultSwitch == YES? switchView.On = YES : NO;
        useDefaultCell = cell;
        [switchView addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([trip.name isEqual: @"Include return journey"]) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0,0,0,0)];
        cell.accessoryView = switchView;
        includeReturnSwitch == YES ? switchView.On = YES : NO;
        includeReturnCell = cell;
        [switchView addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([trip.name isEqual: @"Remind me"]) {
        remindCell = cell;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    } else if ([trip.name isEqual: @"Repeat reminder"]) {
        repeatCell = cell;
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (void)updateSwitch:(UISwitch*)sender
{
    if (sender == useDefaultCell.accessoryView) {
        [sender setOn:!useDefaultSwitch animated:YES];
        useDefaultSwitch = !useDefaultSwitch;
        if ([data.useDefault isEqual:@"YES"])
            [data.useDefault setString:@"NO"];
        else
            [data.useDefault setString:@"YES"];
    } else if (sender == includeReturnCell.accessoryView) {
        [sender setOn:!includeReturnSwitch animated:YES];
        includeReturnSwitch = !includeReturnSwitch;
        if ([data.includeReturn isEqual:@"YES"])
            [data.includeReturn setString:@"NO"];
        else
            [data.includeReturn setString:@"YES"];
    }

//    [Data saveData:data filename:filename];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Trip *trip = [[self.tripArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([trip.name  isEqual: @"Start"] || [trip.name  isEqual: @"End"]) {
        StopsTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"stopsTableViewController"];
        Trip *trip = [[self.tripArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        svc.operation = trip.name;
    
        [self.navigationController pushViewController:svc animated:YES];
    } else if ([trip.name isEqual: @"Remind me"]) {
        ReminderTableViewController *reminder = [[ReminderTableViewController alloc] init];
        [self.navigationController pushViewController:reminder animated:YES];
    } else if ([trip.name isEqual: @"Repeat reminder"]) {
        RepeatTableViewController *repeat = [[RepeatTableViewController alloc] init];
        [self.navigationController pushViewController:repeat animated:YES];
    }

//    [Data saveData:data filename:filename];
}

- (void)viewWillAppear:(BOOL)animated
{
    startCell.detailTextLabel.text = data.startLabel;
    destCell.detailTextLabel.text = data.destLabel;
    routeCell.detailTextLabel.text = data.routeLabel;
    remindCell.detailTextLabel.text = data.remindLabel;
    repeatCell.detailTextLabel.text = data.repeatLabel;
}

- (IBAction)savingRoute:(id)sender {
    [Data saveData:data filename:filename];
    if (isEdit == FALSE) {
        totalTrip++;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
