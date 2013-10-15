//
//  RoutesViewController.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "RoutesViewController.h"
#import "StopsViewController.h"
#import "AppDelegate.h"
#import "Trip.h"

@interface RoutesViewController ()

@end

@implementation RoutesViewController
@synthesize tripArray;
@synthesize startCell;
@synthesize destCell;

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
                 [Trip tripId:@"Destination" desc:destLabel], nil];
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
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    if ([trip.name  isEqual: @"Start"]) {
        startCell = cell;
    } else if ([trip.name  isEqual: @"Destination"]) {
        destCell = cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StopsViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"stopsViewController"];
    Trip *trip = [self.tripArray objectAtIndex:indexPath.row];
    svc.operation = trip.name;
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    startCell.detailTextLabel.text = startLabel;
    destCell.detailTextLabel.text = destLabel;
}

@end
