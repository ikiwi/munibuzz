//
//  BuzzViewController.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "BuzzViewController.h"
#import "buzzData.h"
#import "RoutesViewController.h"
#import "customButton.h"
#import "AppDelegate.h"
#import "Data.h"

@interface BuzzViewController ()

@end

customButton *gloButton;
@implementation BuzzViewController
@synthesize buzzArray;
@synthesize editBuzz;
@synthesize scrollView;
@synthesize buzzTableView;
@synthesize canRefresh;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    canRefresh = FALSE;
    self.buzzArray = [NSMutableArray new];
    buzzList = [NSMutableArray new];
    [self.editBuzz setAction:@selector(editTrip:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteringForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [scrollView addSubview:buzzTableView];
    [self.view addSubview:scrollView];
}

-(void)addRow:(UITableViewCell*)sender
{
    float xx = 0;
    float yy = 128;
    float hh = 64;
    float ww = 64;
    customButton *button;

    for (NSInteger num = 0; num < 5; num++) {
        button = [[customButton alloc] initWithFrame:CGRectMake(xx,yy,hh,ww)];
        button.backgroundColor = [UIColor redColor];
        [sender addSubview:button];
        xx += ww;
    }
}

- (IBAction)checkMax:(id)sender {
    if (totalTrip < 20) {
        self.canRefresh = FALSE;
        RoutesViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"routesController"];
        [self.navigationController pushViewController:rvc animated:YES];
     } else {
             NSLog(@"max trip reached!");

     }
}

- (IBAction)editTrip:(id)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)enteringForeground {
    dataArray = [Data getAll];
}

- (void)viewWillAppear:(BOOL)animated
{
    dataArray = [Data getAll];

    isEdit = FALSE;

    Data *data = [dataArray objectAtIndex:0];
    if (!([data.startLabel isEqualToString:@"location"] || [data.destLabel isEqualToString:@"location"])) {
        UIApplication* app = [UIApplication sharedApplication];
        NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
        // Clear out the old notification before scheduling a new one.
        if ([oldNotifications count] > 0)
            [app cancelAllLocalNotifications];

        UILocalNotification *alarm = [[UILocalNotification alloc] init];
        if (alarm) {
            alarm.fireDate =[[NSDate alloc] initWithTimeIntervalSinceNow:60];
            alarm.alertBody = @"Your muni is arriving.";
            alarm.applicationIconBadgeNumber = 1;
            alarm.soundName = UILocalNotificationDefaultSoundName;
            alarm.alertAction = @"View Details";
        
            [app scheduleLocalNotification:alarm];
        }
    }
    if (canRefresh == TRUE)
        [self refresh];
    [buzzTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return totalTrip;
}

- (void)refresh
{
    for (NSInteger ii = 0; ii < totalTrip; ii++)
    {
        for (NSInteger jj = 0; jj < 5; jj++)
        {
            UITableViewCell *cell = [buzzList objectAtIndex:ii];
            customButton *button = [[cell.contentView subviews] objectAtIndex:jj];
            [button setTitle:@"update" forState:UIControlStateNormal];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];

    NSInteger xx = 0;
    customButton *button;
    for (NSInteger idx = 0; idx < 5; idx++)
    {
        button = [[customButton alloc] initWithFrame:CGRectMake(xx,50,64,64)];
        button.minute = indexPath.row;
        [button setTitle:[NSString stringWithFormat:@"a-%ld",indexPath.row] forState:UIControlStateNormal];
        [cell.contentView insertSubview:button atIndex:idx];
        xx += 64;
    }
    [buzzList setObject:cell atIndexedSubscript:indexPath.row];
    if (indexPath.row == totalTrip-1)
        self.canRefresh = TRUE;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoutesViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"routesController"];
    isEdit = TRUE;
    currentTrip = indexPath.row;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.buzzArray removeObjectAtIndex:indexPath.row];
    }
}

@end
