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
NSInteger SECPERMIN = 60;
@implementation BuzzViewController
@synthesize buzzArray;
@synthesize scrollView;
@synthesize buzzTableView;
@synthesize canRefresh;
@synthesize slabel;
@synthesize dlabel;
@synthesize alarmArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.alarmArray = [[NSMutableArray alloc] initWithCapacity:MAXTRIPS];
    buzzList = [NSMutableArray new];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style: UIBarButtonItemStyleBordered target:self action:@selector(addOrDeleteRows:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteringForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [scrollView addSubview:buzzTableView];
    [self.view addSubview:scrollView];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 20
                                                      target: self
                                                    selector: @selector(viewWillAppear:)
                                                    userInfo: nil
                                                     repeats: YES];
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
    
    if (canRefresh) {
        [buzzTableView beginUpdates];
//        [buzzTableView reloadRowsAtIndexPaths:[buzzTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
        [self refresh];
        [buzzTableView endUpdates];
     }
    [buzzTableView reloadData];
}

- (void)setAlarm:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    NSInteger tmp = ((UIControl*)sender).tag;
    NSInteger ii = tmp / 100;
    NSInteger jj = tmp % 5;
    NSInteger seconds = [[[alarmArray objectAtIndex:ii] objectAtIndex:jj] integerValue] * SECPERMIN;
    
    // switch alarm on or off
    customCell *cell = [buzzList objectAtIndex:ii];
    customButton *button = [[cell.contentView subviews] objectAtIndex:jj];
    if ([button isAlarmOn]) {
        NSLog(@"turning %ld %ld off", ii, jj);
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *slot = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"id"]];
            if ([slot isEqualToString:[NSString stringWithFormat:@"%ld-%ld",ii,jj]])
            {
                [app cancelLocalNotification:oneEvent];
                // cancel alarm
                [button setBackgroundColor:[UIColor redColor]];
                break;
            }
        }
    } else {
        NSLog(@"turning %ld %ld on", ii, jj);
        // set alarm
        [button setBackgroundColor:[UIColor orangeColor]];
        UILocalNotification *alarm = [[UILocalNotification alloc] init];
        if (alarm) {
            alarm.fireDate =[[NSDate alloc] initWithTimeIntervalSinceNow:seconds];
            alarm.alertBody = @"Your muni is arriving.";
            alarm.applicationIconBadgeNumber = 1;
            alarm.soundName = UILocalNotificationDefaultSoundName;
            alarm.alertAction = @"View details";
            alarm.hasAction = YES;
            NSDictionary *alarmID = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%ld",ii,jj] forKey:@"id"];
            alarm.userInfo = alarmID;
            button.alarm = alarm;
            
            [app scheduleLocalNotification:alarm];
        }
    }
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
    NSMutableArray *alarmSubarray = [[NSMutableArray alloc] initWithCapacity:5];
    BOOL shiftAlarms = FALSE;
    
    for (NSInteger ii = 0; ii < totalTrip; ii++)
    {
        data = [Data getData:[NSString stringWithFormat:@"data%ld.model",ii]];
        NSArray *newTime = [[self class] refreshTime];
        customCell *cell = [buzzList objectAtIndex:ii];
        for (NSInteger jj = 0; jj < 5; jj++)
        {
            customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
            NSString *newtime = [newTime objectAtIndex:jj];
            if ([button.titleLabel.text isEqualToString:@"0"] && (![newtime isEqualToString:@"0"])) {
                // muni has arrived, removing the first time slot will cause the row to be shifted,
                // if alarms is set on one of the button, then reassign each alarm to its previous button
                shiftAlarms = TRUE;
            }
            [button setTitle:[NSString stringWithFormat:@"%@",newtime] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(setAlarm:) forControlEvents:UIControlEventTouchUpInside];
            [alarmSubarray setObject:newtime atIndexedSubscript:jj];
            // to make the button retrievable, set tag to the schedule #
            // decimal number: xx0y, where xx ranges from 0 to 19 (max trips)
            // and y ranges from 0 to 4 (max alarms)
            button.tag = ii*100 + jj;
            if ([button isAlarmOn]) {
                [button.alarm setFireDate:[NSDate dateWithTimeIntervalSinceNow:([newtime integerValue]*SECPERMIN)]];
                [[self class] refreshAlarm];
            }
        }
        [alarmArray setObject:alarmSubarray atIndexedSubscript:ii];
        cell.startLabel.text = data.startLabel;
        cell.destLabel.text = data.destLabel;
    }
}

+ (NSArray*)refreshTime
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

+ (void)refreshAlarm
{
    NSScanner *theScanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"%@",[alarmNotification.userInfo valueForKey:@"id"]]];
    NSInteger ii;
    NSInteger jj;
    [theScanner scanInteger:&ii];
    [theScanner scanString:@"-" intoString:NULL];
    [theScanner scanInteger:&jj];

    UITableViewCell *cell = [buzzList objectAtIndex:ii];

    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"switching alarm %ld %ld", ii, jj);
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSString *slot = [NSString stringWithFormat:@"%@",[oneEvent.userInfo valueForKey:@"id"]];
        if ([slot hasPrefix:[NSString stringWithFormat:@"%ld-",ii]])
        {
            NSInteger slotnum = [[slot substringFromIndex:[slot length] - 1] integerValue] - 1;
            oneEvent.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%ld",ii,slotnum] forKey:@"id"];
            break;
        }
    }
    customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
    jj++;
    while(jj < 5)
    {
        customButton *button2 = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
        [button setBackgroundColor:[button2 backgroundColor]];
        button.alarm = button2.alarm;
        button = button2;
        jj++;
    }
    button.alarm = nil;
    [button setBackgroundColor:[UIColor redColor]];
    [[self class] refreshTime];
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
