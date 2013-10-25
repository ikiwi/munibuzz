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

NSArray *reminderArray;
NSArray *repeatArray;
UIBarButtonItem *doneButton;
BOOL reminding;
@implementation RoutesViewController
@synthesize tripArray;
@synthesize startCell;
@synthesize destCell;
@synthesize routeCell;
@synthesize remindCell;
@synthesize repeatCell;
@synthesize useDefaultCell;
@synthesize includeReturnCell;
@synthesize backToBuzz;
@synthesize saveRoute;

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
        // edit existing trip
        filename = [NSString stringWithFormat:@"data%ld.model",currentTrip];
        data = [Data getData:filename];
        isEdit = FALSE;
    } else {
        // new trip
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
                 [Trip tripId:@"Remind me" desc:data.remindLabel],
                 [Trip tripId:@"Repeat reminder" desc:data.repeatLabel], nil];
    
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
    reminderArray = [NSArray arrayWithObjects:
                     @"None", @"1 min before", @"2 min before", @"3 min before", @"4 min before", @"5 min before", @"6 min before", @"7 min before", @"8 min before", @"9 min before", @"10 min before", nil];
    repeatArray = [NSArray arrayWithObjects:
                     @"Never", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 350, 0, 0)];
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerView.showsSelectionIndicator = YES;
    [backToBuzz setAction:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backToBuzz;
    
    // this view controller is the data source and delegate
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
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
        reminding = TRUE;
        if (self.pickerView.superview == nil) {
            
            [self.view.window addSubview: self.pickerView];
        }
        [self.pickerView selectRow:[data.remindLabel integerValue] inComponent:0 animated:YES];
        [self.pickerView reloadComponent:0];
        self.navigationItem.rightBarButtonItem = doneButton;
        
    } else if ([trip.name isEqual: @"Repeat reminder"]) {
        reminding = FALSE;
        if (self.pickerView.superview == nil) {
            
            [self.view.window addSubview: self.pickerView];
        }
        [self.pickerView selectRow:[data.repeatLabel integerValue] inComponent:0 animated:YES];
        [self.pickerView reloadComponent:0];
        self.navigationItem.rightBarButtonItem = doneButton;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    startCell.detailTextLabel.text = data.startLabel;
    destCell.detailTextLabel.text = data.destLabel;
    routeCell.detailTextLabel.text = data.routeLabel;
    remindCell.detailTextLabel.text = data.remindLabel;
    repeatCell.detailTextLabel.text = data.repeatLabel;
    doneButton = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                  target:self
                  action:@selector(doneAction:)];
}

- (void)doneAction:(id)sender
{
    [self.pickerView removeFromSuperview];
    
    // remove the "Done" button in the nav bar
    self.navigationItem.rightBarButtonItem = saveRoute;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if (reminding == TRUE) {
        data.remindLabel = [reminderArray objectAtIndex:row];
        remindCell.detailTextLabel.text = data.remindLabel;
    } else {
        data.repeatLabel = [repeatArray objectAtIndex:row];
        repeatCell.detailTextLabel.text = data.repeatLabel;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (reminding == TRUE)
        return [reminderArray count];
    else return [repeatArray count];
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.pickerView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

// Set the size of the component wheel on the picker
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 60.0;
    return componentWidth;
}

// Populate the picker
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    
    // note: custom picker doesn't care about titles, it
    // uses custom views
    if (reminding == TRUE) {
        returnStr = [NSString stringWithFormat:@"%@",
                     [reminderArray objectAtIndex:row]];
    } else {
        returnStr = [NSString stringWithFormat:@"%@",
                     [repeatArray objectAtIndex:row]];
    }
    
    return returnStr;
}

- (IBAction)savingRoute:(id)sender {
    Data *oldData = [Data getData:filename];
    if (currentTrip == totalTrip) {
        // this is a new route, so update the total
        totalTrip++;
    } else if (![oldData.startLabel isEqual:data.startLabel]
        || ![oldData.destLabel isEqual:data.destLabel]
        || ![oldData.routeLabel isEqual:data.routeLabel])
    {
        // isEdit flag indicates to buzz view controller
        // whether alarms need to be reset. e.g.
        // isEdit is TRUE will cause alarms to be reset
        // since start/end/route changes create a new route,
        // any other changes does not require the alarms to
        // be reset (isEdit is FALSE)
        isEdit = TRUE;
    }

    [Data saveData:data filename:filename];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
