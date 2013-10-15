//
//  RoutesViewController.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "RoutesViewController.h"
#import "StopsTableViewController.h"
#import "RepeatTableViewController.h"
#import "ReminderTableViewController.h"
#import "AppDelegate.h"
#import "Trip.h"

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
    tripArray = [NSArray arrayWithObjects:
                 [Trip tripId:@"Start" desc:startLabel],
                 [Trip tripId:@"End" desc:destLabel],
                 [Trip tripId:@"Route" desc:routeLabel],
                 [Trip tripId:@"Include return journey" desc:@""],
                 [Trip tripId:@"Use default" desc:@""],
                 [Trip tripId:@"Remind me" desc:@"None"],
                 [Trip tripId:@"Repeat reminder" desc:@"Never"], nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // If you're serving data from an array, return the length of the array:
    return [tripArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Trip *trip = [self.tripArray objectAtIndex:indexPath.row];

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
        useDefaultCell = cell;
        [switchView addTarget:self action:@selector(updateSwitch:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([trip.name isEqual: @"Include return journey"]) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0,0,0,0)];
        cell.accessoryView = switchView;
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
    } else if (sender == includeReturnCell.accessoryView) {
        [sender setOn:!includeReturnSwitch animated:YES];
        includeReturnSwitch = !includeReturnSwitch;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Trip *trip = [self.tripArray objectAtIndex:indexPath.row];
    
    if ([trip.name  isEqual: @"Start"] || [trip.name  isEqual: @"End"]) {
        StopsTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"stopsTableViewController"];
        Trip *trip = [self.tripArray objectAtIndex:indexPath.row];
        svc.operation = trip.name;
    
        [self.navigationController pushViewController:svc animated:YES];
    } else if ([trip.name isEqual: @"Remind me"]) {
        ReminderTableViewController *reminder = [[ReminderTableViewController alloc] init];
        [self.navigationController pushViewController:reminder animated:YES];
    } else if ([trip.name isEqual: @"Repeat reminder"]) {
        RepeatTableViewController *repeat = [[RepeatTableViewController alloc] init];
        [self.navigationController pushViewController:repeat animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    startCell.detailTextLabel.text = startLabel;
    destCell.detailTextLabel.text = destLabel;
    routeCell.detailTextLabel.text = routeLabel;
    remindCell.detailTextLabel.text = remindLabel;
    repeatCell.detailTextLabel.text = repeatLabel;
}

@end
