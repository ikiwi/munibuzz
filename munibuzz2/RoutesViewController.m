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
#import "AppDelegate.h"
#import "Trip.h"
#import "Stops.h"
#import "BuzzViewController.h"
#import "RoutesDatabase.h"

@interface RoutesViewController ()

@end

NSArray *reminderArray;
NSArray *repeatArray;
UIBarButtonItem *doneButton;
BOOL reminding;
BOOL repeating;
BOOL selected;
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

    NSArray *subArray1 = [NSArray arrayWithObjects:
                 [Trip tripId:@"Start" desc:data.startLabel],
                 [Trip tripId:@"End" desc:data.destLabel],
                 [Trip tripId:@"Route" desc:data.routeId],
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
    reminderArray = @[@"None", @"1 min before", @"2 min before", @"3 min before", @"4 min before", @"5 min before", @"6 min before", @"7 min before", @"8 min before", @"9 min before", @"10 min before"];
    repeatArray = [NSMutableArray arrayWithCapacity:[reminderArray count]];
    directionArray = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM stops group by title";

    stopsArray = [[RoutesDatabase database] RoutesInfo:[query UTF8String]];
    
    filteredStopsArray = [NSMutableArray arrayWithCapacity:[stopsArray count]];
    rarray1 = [[NSMutableArray alloc] init];
    rarray2 = [[NSMutableArray alloc] init];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    [backToBuzz setAction:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backToBuzz;
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
    
    if (selected == TRUE) {
        // close existing picker view
        [self doneAction:self];
        selected = FALSE;
    }
    
    if ([trip.name  isEqual: @"Start"] || [trip.name  isEqual: @"End"]) {
        StopsTableViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"stopsTableViewController"];
        Trip *trip = [[self.tripArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        svc.operation = trip.name;
        if ([trip.name isEqual: @"Start"] || [rarray1 count] == 0) {
            NSString *query = @"SELECT * FROM stops group by title";
            stopsArray = [[RoutesDatabase database] RoutesInfo:[query UTF8String]];
        } else if ([trip.name isEqual: @"End"]) {
            NSMutableString *queryStr = [NSMutableString stringWithFormat:@"SELECT * FROM stops group by title having direction=\"%@\"", [[rarray1 objectAtIndex:0] dTag] ];
            for (NSInteger idx=1; idx < [rarray1 count]; idx++) {
                [queryStr appendString:
                 [NSString stringWithFormat:@" or direction=\"%@\"", [[rarray1 objectAtIndex:idx] dTag]]];
            }
            
            stopsArray = [[RoutesDatabase database] RoutesInfo:[queryStr UTF8String]];
        }
    
        [self.navigationController pushViewController:svc animated:YES];
    } else if ([trip.name isEqual: @"Route"]) {
        selected = TRUE;
        if (![data.startLabel isEqual:@"location"] && ![data.destLabel isEqual:@"location"]) {
            [rarray1 removeAllObjects];
            [rarray2 removeAllObjects];
            NSMutableString *queryStr = [NSMutableString stringWithFormat:@"SELECT * FROM stops group by direction,stopid having title=\"%@\"", data.startLabel];

            [rarray1 setArray:[[RoutesDatabase database] RoutesInfo:[queryStr UTF8String]]];

            [queryStr setString:[NSMutableString stringWithFormat:@"SELECT * FROM stops group by direction,stopid having title=\"%@\"", data.destLabel] ];
            
            [rarray2 setArray:[[RoutesDatabase database] RoutesInfo:[queryStr UTF8String]]];

            [StopsTableViewController refreshDirectionArray:rarray1 rarray2:rarray2];
        }
        reminding = FALSE;
        repeating = FALSE;
        if (self.pickerView.superview == nil) {
            [self.view.window addSubview: self.pickerView];
        }
        [self.pickerView reloadComponent:0];
        [self.pickerView setFrame: CGRectMake([[self view] frame].origin.x, [[self view] frame].origin.y + 300, [[self view] frame].size.width, 216)];
        [self.pickerView selectRow:[data.routeId integerValue] inComponent:0 animated:YES];
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.25];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView commitAnimations];
        self.navigationItem.rightBarButtonItem = doneButton;
        
    } else if ([trip.name isEqual: @"Remind me"]) {
        selected = TRUE;
        reminding = TRUE;
        repeating = FALSE;
        if (self.pickerView.superview == nil) {
            [self.view.window addSubview: self.pickerView];
        }
        [self.pickerView reloadComponent:0];
        [self.pickerView setFrame: CGRectMake([[self view] frame].origin.x, [[self view] frame].origin.y + 380, [[self view] frame].size.width, 216)];
        [self.pickerView selectRow:[data.remindLabel integerValue] inComponent:0 animated:YES];
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.25];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView commitAnimations];
        self.navigationItem.rightBarButtonItem = doneButton;
        
    } else if ([trip.name isEqual: @"Repeat reminder"]) {
        selected = TRUE;
        reminding = FALSE;
        repeating = TRUE;
        if (self.pickerView.superview == nil) {
            
            [self.view.window addSubview: self.pickerView];
        }
        
        if ([data.repeatLabel integerValue] >= [data.remindLabel integerValue]) {
            data.repeatLabel = [reminderArray objectAtIndex:0];
        }

        NSInteger end = [data.remindLabel integerValue] ;
        if (end == 0) {
            end = 1;
        }
        repeatArray = [reminderArray subarrayWithRange:NSMakeRange(0, end)];
        [self.pickerView reloadComponent:0];
        [self.pickerView setFrame: CGRectMake([[self view] frame].origin.x, [[self view] frame].origin.y + 420, [[self view] frame].size.width, 216)];
        [self.pickerView selectRow:[data.repeatLabel integerValue] inComponent:0 animated:YES];
        [UIView beginAnimations: nil context: NULL];
        [UIView setAnimationDuration: 0.25];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView commitAnimations];
        self.navigationItem.rightBarButtonItem = doneButton;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    startCell.detailTextLabel.text = data.startLabel;
    destCell.detailTextLabel.text = data.destLabel;
    routeCell.detailTextLabel.text = data.routeId;
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
    selected = TRUE;
    if (reminding == TRUE) {
        data.remindLabel = [reminderArray objectAtIndex:row];
        remindCell.detailTextLabel.text = data.remindLabel;
    } else if (repeating == TRUE) {
        data.repeatLabel = [repeatArray objectAtIndex:row];
        repeatCell.detailTextLabel.text = data.repeatLabel;
    } else {
        data.routeId = [directionArray objectAtIndex:row];
        data.routeId = [directionArray objectAtIndex:row];
        routeCell.detailTextLabel.text = data.routeId;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (reminding == TRUE)
        return [reminderArray count];
    else if (repeating == TRUE)
        return [repeatArray count];
    else
        return [directionArray count];
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
    } else if (repeating == TRUE) {
        returnStr = [NSString stringWithFormat:@"%@",
                     [repeatArray objectAtIndex:row]];
    } else {
        returnStr = [NSString stringWithFormat:@"%@",
                     [directionArray objectAtIndex:row]];
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
        || ![oldData.routeId isEqual:data.routeId])
    {
        // isEdit flag indicates to buzz view controller
        // whether alarms need to be reset. e.g.
        // isEdit is TRUE will cause alarms to be reset
        // since start/end/route changes create a new route,
        // any other changes does not require the alarms to
        // be reset (isEdit is FALSE)
        isEdit = TRUE;
    }

    //reset repeat if it's larger than reminder
    if ([data.repeatLabel integerValue] >= [data.remindLabel integerValue]) {
        data.repeatLabel = [reminderArray objectAtIndex:0];
    }
    [Data saveData:data filename:filename];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
