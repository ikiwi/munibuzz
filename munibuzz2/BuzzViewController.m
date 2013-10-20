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
#import "customCell.h"

@interface BuzzViewController ()

@end

NSString *predictionString = @"prediction";
NSInteger STARTLABELTAG = 5;
NSInteger DESTLABELTAG = 6;
@implementation BuzzViewController
@synthesize buzzArray;
@synthesize scrollView;
@synthesize buzzTableView;
@synthesize canRefresh;
@synthesize slabel;
@synthesize dlabel;

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
//    self.buzzArray = [NSMutableArray new];
    buzzList = [NSMutableArray new];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style: UIBarButtonItemStyleBordered target:self action:@selector(addOrDeleteRows:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteringForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [scrollView addSubview:buzzTableView];
    [self.view addSubview:scrollView];

//    [self refreshTime];
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
    if (totalTrip < MAXTRIPS) {
        self.canRefresh = FALSE;
        RoutesViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"routesController"];
        [self.navigationController pushViewController:rvc animated:YES];
     } else {
             NSLog(@"max trip reached!");

     }
}

- (void)addOrDeleteRows:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [buzzTableView setEditing:NO animated:NO];
        [buzzTableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [buzzTableView setEditing:YES animated:YES];
        [buzzTableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
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

    if (FALSE) {
        /* TO BE IMPLEMENTED */
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
    if (canRefresh) {
        [buzzTableView beginUpdates];
        [buzzTableView reloadRowsAtIndexPaths:[buzzTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
        [buzzTableView endUpdates];
        [self refresh];
     }
    [buzzTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalTrip;
}

- (void)refresh
{
    for (NSInteger ii = 0; ii < totalTrip; ii++)
    {
        data = [Data getData:[NSString stringWithFormat:@"data%ld.model",ii]];
        NSArray *newTime = [self refreshTime];
        customCell *cell = [buzzList objectAtIndex:ii];
        for (NSInteger jj = 0; jj < 5; jj++)
        {
            [(customButton*)[[cell.contentView subviews] objectAtIndex:jj]
             setTitle:[NSString stringWithFormat:@"%@",[newTime objectAtIndex:jj]] forState:UIControlStateNormal];
        }
        cell.startLabel.text = data.startLabel;
        cell.destLabel.text = data.destLabel;
    }
}

- (NSArray*)refreshTime
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&r=%@&s=%@",data.routeId, data.startStopTag]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    // this will perform a synchronous GET operation passing the values you specified in the header (typically you want asynchrounous, but for simplicity of answering the question it works)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSMutableArray *pred = [[NSMutableArray alloc] init];
    NSScanner *theScanner = [NSScanner scannerWithString:responseString];
    NSInteger firstPred = 0;
    NSInteger idx = 0;
    NSString *tmp;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [theScanner scanUpToString:predictionString intoString:NULL];
    [theScanner scanString:predictionString intoString:NULL];
    [theScanner scanUpToString:predictionString intoString:NULL];
    [theScanner scanString:predictionString intoString:NULL];
    [theScanner scanUpToString:@"minutes" intoString:NULL];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanString:@"minutes=\"" intoString:NULL];
        [theScanner scanInteger:&firstPred];
        [pred setObject:pred atIndexedSubscript:idx];
        [theScanner scanUpToString:@"dirTag=\"" intoString:NULL];
        [theScanner scanString:@"dirTag=\"" intoString:NULL];
        [theScanner scanUpToString:@"\"" intoString:&tmp];
        if ([tmp length] > 0) {
            idx++;
            [result addObject:[NSString stringWithFormat:@"%ld", firstPred]];
        }
        [theScanner scanUpToString:@"minutes" intoString:NULL];
    }
    while ([result count] < 5) {
        //if there no more predictions, pad the rest of the array
        [result addObject:@"-"];
    }
    return result;
}

- (customCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"buzzCell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    data = [Data getData:[NSString stringWithFormat:@"data%ld.model",indexPath.row]];
    cell.startLabel.text = data.startLabel;
    cell.destLabel.text = data.destLabel;
    [cell insertSubview:cell.startLabel atIndex:STARTLABELTAG];
    [cell insertSubview:cell.destLabel atIndex:DESTLABELTAG];

    [buzzList setObject:cell atIndexedSubscript:indexPath.row];
    if (indexPath.row == totalTrip-1) {
        self.canRefresh = TRUE;
        [self refresh];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoutesViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"routesController"];
    isEdit = TRUE;
    currentTrip = indexPath.row;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [Data removeData:indexPath.row];
        [buzzTableView reloadData];
//        [buzzTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end
