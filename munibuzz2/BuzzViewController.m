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
NSInteger ROUTEIDTAG = 7;
NSInteger SECPERMIN = 60;
NSArray *newTime;
NSInteger defaultRowHeight = 114;
NSInteger collapsedRowHeight = 50;
@implementation BuzzViewController
@synthesize buzzArray;
@synthesize scrollView;
@synthesize buzzTableView;
@synthesize canRefresh;
@synthesize slabel;
@synthesize dlabel;
@synthesize rid;
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
    self.rowTimer = [[NSMutableArray alloc] initWithCapacity:MAXTRIPS];
    newTime = [[NSArray alloc] init];
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
        [buzzTableView setRowHeight:defaultRowHeight];
        [super setEditing:NO animated:NO];
        [buzzTableView setEditing:NO animated:NO];
        [buzzTableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [buzzTableView setRowHeight:collapsedRowHeight];
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

    if (canRefresh) {
        [buzzTableView beginUpdates];
        [self refresh];
        [buzzTableView endUpdates];
     }
        
    [buzzTableView reloadData];
}

- (void)showAllEvents
{
     UIApplication *app = [UIApplication sharedApplication];
     NSArray *eventArray = [app scheduledLocalNotifications];
     NSLog(@"current alarm #: %ld", [eventArray count]);
     for (int i=0; i<[eventArray count]; i++)
     {
         UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
         NSDictionary *userInfoCurrent = oneEvent.userInfo;
         NSString *slot = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"id"]];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"h:mm"];
         NSString *str = [formatter stringFromDate:oneEvent.fireDate];
         NSLog(@"#%d %@ %@", i, slot, str);
     }
}

- (NSInteger)getReminderMinutes:(NSInteger)alarmTime
{
    NSInteger reminder;
    if ([data.useDefault isEqualToString:@"YES"]) {
        reminder = [data.remind_default_label integerValue];
    } else {
        reminder = [data.remindLabel integerValue];
    }
    if ((alarmTime - reminder) <= 0) {
        NSLog(@"alarm cannot be set");
    }
    return (alarmTime - reminder);
}

- (NSInteger)getRepeatMinutes:(NSInteger)alarmTime
{
    NSInteger repeat;
    if ([data.useDefault isEqualToString:@"YES"]) {
        repeat = [data.repeat_default_label integerValue];
    } else {
        repeat = [data.repeatLabel integerValue];
    }
    if ((alarmTime - repeat) <= 0) {
        NSLog(@"repeat alarm cannot be set");
    }
    return (alarmTime - repeat);
}


- (void)setAlarm:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    NSInteger tmp = ((UIControl*)sender).tag;
    NSInteger ii = tmp / 100;
    NSInteger jj = tmp % 5;
    
    if ([[[alarmArray objectAtIndex:ii] objectAtIndex:jj] isEqual:@"-"]) {
        return;
    }
    // switch alarm on or off
    customCell *cell = [buzzList objectAtIndex:ii];
    customButton *button = [[cell.contentView subviews] objectAtIndex:jj];
    if (button.isOn) {
        button.isOn = FALSE;
        [button setBackground];
        if (button.alarmOn) {
            NSLog(@"setting alarm off");
            button.alarmOn = FALSE;
            [app cancelLocalNotification:button.alarm];
        }
        if (button.alarm2On) {
            NSLog(@"setting alarm2 off");
            button.alarm2On = FALSE;
            [app cancelLocalNotification:button.alarm2];
        }
    } else {
        button.isOn = TRUE;
        button.alarmOn = TRUE;
        [button setBackground];
        NSLog(@"turning %ld %ld on", ii, jj);
        NSDictionary *alarmID = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%ld",ii,jj] forKey:@"id"];
        [self setAlarmInternal:button.alarm ii:ii jj:jj seconds:([self getReminderMinutes:[[[alarmArray objectAtIndex:ii] objectAtIndex:jj] integerValue]] * SECPERMIN) alarmID:alarmID];
        if ([data.repeatLabel integerValue] > 0) {
            button.alarm2On = TRUE;
            alarmID = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%ld-2",ii,jj] forKey:@"id"];
            [self setAlarmInternal:button.alarm2 ii:ii jj:jj seconds:([self getRepeatMinutes:[[[alarmArray objectAtIndex:ii] objectAtIndex:jj] integerValue]] * SECPERMIN) alarmID:alarmID];
        }
    }
}

- (void)setAlarmInternal:(UILocalNotification*)alarm ii:(NSInteger)ii jj:(NSInteger)jj seconds:(NSInteger)seconds alarmID:(NSDictionary*)alarmID
{
    UIApplication *app = [UIApplication sharedApplication];
    NSLog(@"setting alarm for %ld", seconds);
    [alarm setFireDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
    alarm.alertBody = @"Your muni is arriving.";
    alarm.applicationIconBadgeNumber = 1;
    alarm.soundName = UILocalNotificationDefaultSoundName;
    alarm.alertAction = @"View details";
    alarm.hasAction = YES;
    alarm.userInfo = alarmID;
    
    [app scheduleLocalNotification:alarm];
}

+(void)turnOffAlarm:(UILocalNotification*)oneEvent
{
    NSDictionary *userInfoCurrent = oneEvent.userInfo;
    NSString *str = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"id"]];
    NSScanner *theScanner = [NSScanner scannerWithString:str];
    NSInteger ii = 0;
    NSInteger jj = 0;
    NSInteger repeat;
    [theScanner scanInteger:&ii];
    [theScanner scanString:@"-" intoString:NULL];
    [theScanner scanInteger:&jj];
    [theScanner scanString:@"-" intoString:NULL];
    [theScanner scanInteger:&repeat];
    if (ii < 0 || ii > 5 || jj < 0 || jj > 5) {
        NSLog(@"turning off alarm failed %ld %ld", ii, jj);
        return;
    }
    UITableViewCell *cell = [buzzList objectAtIndex:ii];
    customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
    if ([data.repeatLabel integerValue] == 0) {
        // no repeat, turn off everything
        NSLog(@"turn off alarm %ld", [data.repeatLabel integerValue]);
        button.alarmOn = FALSE;
        button.isOn = FALSE;
        [button setBackground];
    } else if (repeat == 2) {
        // this is the repeat alarm, turn off everything
        NSLog(@"turning of repeat");
        button.alarm2On = FALSE;
        button.isOn = FALSE;
        [button setBackground];
    } else {
        // has unnotified repeat, just turn off first alarm but keep the indication
        button.alarmOn = FALSE;
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
    BOOL clearAlarms = FALSE;

    for (NSInteger ii = 0; ii < totalTrip; ii++)
    {
        data = [Data getData:[NSString stringWithFormat:@"data%ld.model",ii]];
        BOOL hasRepeat = ([data.repeatLabel integerValue] > 0) ? TRUE : FALSE;

        newTime = [[self class] refreshTime];
        NSArray *alarmSubarray = [[NSArray alloc] initWithArray:newTime];
        [alarmArray setObject:alarmSubarray atIndexedSubscript:ii];
        customCell *cell = [buzzList objectAtIndex:ii];
        
        // for the first button, refresh everything
        customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:0];
        NSString *newtime = [newTime objectAtIndex:0];
        if (isEdit == TRUE) {
            NSLog(@"clearing alarms");
            // clear out the alarm from the previous routes
            clearAlarms = TRUE;
            isEdit = FALSE;
        } else if ([button.titleLabel.text isEqualToString:@"0"] && (![newtime isEqualToString:@"0"])) {
            // muni has arrived and predictions queue has shifted, now we can shift the alarms
            [[self class] refreshAlarm:ii];
        }
        [button setTitle:[NSString stringWithFormat:@"%@",newtime] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(setAlarm:) forControlEvents:UIControlEventTouchUpInside];
        // to make the button retrievable, set tag to the schedule #
        // decimal number: xx0y, where xx ranges from 0 to 19 (max trips)
        // and y ranges from 0 to 4 (max alarms)
        [self refreshEach:button ii:ii jj:0 hasRepeat:hasRepeat clearAlarms:clearAlarms newtime:newtime];
        // for the rest, refresh everything except alarm
        for (NSInteger jj = 1; jj < 5; jj++)
        {
            
            customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
            NSString *newtime = [newTime objectAtIndex:jj];
            
            [button setTitle:[NSString stringWithFormat:@"%@",newtime] forState:UIControlStateNormal];

            [button addTarget:self action:@selector(setAlarm:) forControlEvents:UIControlEventTouchUpInside];
            // to make the button retrievable, set tag to the schedule #
            // decimal number: xx0y, where xx ranges from 0 to 19 (max trips)
            // and y ranges from 0 to 4 (max alarms)
            [self refreshEach:button ii:ii jj:jj hasRepeat:hasRepeat clearAlarms:clearAlarms newtime:newtime];

        }
        cell.startLabel.text = data.startLabel;
        cell.destLabel.text = data.destLabel;
    }
}

- (void) refreshEach:(customButton*) button
                  ii:(NSInteger)ii
                  jj:(NSInteger)jj
           hasRepeat:(BOOL)hasRepeat
         clearAlarms:(BOOL)clearAlarms
             newtime:(NSString*)newtime
{
    button.tag = ii*100;
    if (button.isOn == TRUE) {
        if (button.alarmOn) {
            [[UIApplication sharedApplication] cancelLocalNotification:button.alarm];
        }
        if (button.alarm2On) {
            [[UIApplication sharedApplication] cancelLocalNotification:button.alarm2];
            if (!hasRepeat)
                button.alarm2On = FALSE;
        }
        if (clearAlarms == TRUE) {
            button.isOn = FALSE;
            button.alarmOn = FALSE;
            button.alarm2On = FALSE;
        } else {
            if (button.alarmOn) {
                NSInteger reminder = [self getReminderMinutes:[newtime integerValue]];
                [button.alarm setFireDate:[NSDate dateWithTimeIntervalSinceNow:(reminder * SECPERMIN)]];
                [[UIApplication sharedApplication] scheduleLocalNotification:button.alarm];
            }
            if (hasRepeat) {
                if (button.alarm2On == FALSE) {
                    NSDictionary *alarmID = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%ld-2",ii,jj] forKey:@"id"];
                    [self setAlarmInternal:button.alarm2 ii:ii jj:jj seconds:([self getRepeatMinutes:[[[alarmArray objectAtIndex:ii] objectAtIndex:jj] integerValue]] * SECPERMIN) alarmID:alarmID];
                } else {
                    NSInteger repeat = [self getRepeatMinutes:[newtime integerValue]];
                    [button.alarm2 setFireDate:[NSDate dateWithTimeIntervalSinceNow:(repeat * SECPERMIN)]];
                    [[UIApplication sharedApplication] scheduleLocalNotification:button.alarm2];
                }
                button.alarm2On = TRUE;
            }
        }
    }
    [button setBackground];
}

+ (NSMutableArray*)refreshTime
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
    NSInteger count = [result count];
    while (count < 5) {
        //if there no more predictions, pad the rest of the array
        [result addObject:@"-"];
        count++;
    }

    return result;
}

-(void)refreshRowAlarms:(NSTimer*)sender
{
    NSDictionary *dict = [sender userInfo];
    NSInteger row = [[dict objectForKey:@"row"] integerValue];

    data = [Data getData:[NSString stringWithFormat:@"data%ld.model",row]];
}

+ (void)refreshAlarm:(NSInteger)ii
{
    UITableViewCell *cell = [buzzList objectAtIndex:ii];

    customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:0];
    for (int jj = 1; jj < 5; jj++)
    {
        customButton *button2 = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
        button.alarm = button2.alarm;
        button.alarm2 = button2.alarm2;
        button.titleLabel.text = button2.titleLabel.text;
        button.isOn = button2.isOn;
        button.alarmOn = button2.alarmOn;
        button.alarm2On = button2.alarm2On;
        [button setBackground];
        button = button2;
    }
    button.alarm = [[UILocalNotification alloc] init];
    button.alarm2 = [[UILocalNotification alloc] init];
    button.alarmOn = FALSE;
    button.alarm2On = FALSE;
    button.isOn = FALSE;
    [button setBackground];
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
    cell.routeId.text = data.routeId;
    [cell insertSubview:cell.startLabel atIndex:STARTLABELTAG];
    [cell insertSubview:cell.destLabel atIndex:DESTLABELTAG];
    [cell insertSubview:cell.routeId atIndex:ROUTEIDTAG];

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
