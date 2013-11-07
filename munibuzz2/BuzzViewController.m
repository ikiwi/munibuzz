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
NSInteger LINEIDX = 8;
NSInteger SECPERMIN = 60;
NSArray *newTime;
NSInteger defaultRowHeight = 114;
NSInteger collapsedRowHeight = 50;
UIBarButtonItem *editButton;
BOOL initialized = FALSE;
@implementation BuzzViewController
@synthesize buzzArray;
@synthesize scrollView;
@synthesize buzzTableView;
@synthesize slabel;
@synthesize dlabel;
@synthesize rid;
@synthesize alarmArray;
@synthesize addRouteButton;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    if (initialized == FALSE) {
        [super viewDidLoad];
        
        self.alarmArray = [[NSMutableArray alloc] initWithCapacity:MAXTRIPS];
        self.rowTimer = [[NSMutableArray alloc] initWithCapacity:MAXTRIPS];
        newTime = [[NSArray alloc] init];
        buzzList = [NSMutableArray new];
        editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style: UIBarButtonItemStyleBordered target:self action:@selector(addOrDeleteRows:)];
        self.navigationItem.leftBarButtonItem = nil;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteringForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        //adjust add button for different iPhone version
        
        if (IS_IPHONE_5) {
            [addRouteButton setFrame:CGRectMake(140, 524, 40, 40)];
            [buzzTableView setFrame:CGRectMake(0,32,320,488)];
            [scrollView setFrame:CGRectMake(0,32,320,488)];
            buzzTableView.rowHeight = 114;
        } else {
            [addRouteButton setFrame:CGRectMake(140,435,40,40)];
            [buzzTableView setFrame:CGRectMake(0,32,320,403)];
            [scrollView setFrame:CGRectMake(0,32,320,403)];
            buzzTableView.rowHeight = 124;
        }
        [self.view addSubview:addRouteButton];
        [scrollView addSubview:buzzTableView];
        [self.view addSubview:scrollView];
        
    
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 20
                                                          target: self
                                                        selector: @selector(autoRefresh:)
                                                        userInfo: nil
                                                         repeats: YES];
    }
}

- (IBAction)checkMax:(id)sender
{
    if (totalTrip < MAXTRIPS) {
        canRefresh = FALSE;
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
        [self exitEditingMode];
    }
    else
    {
        [self enterEditingMode];
    }
}

- (void)exitEditingMode
{
    for (NSInteger idx = 0; idx < totalTrip; idx++) {
        customCell *cell = [buzzList objectAtIndex:idx];
        UILabel *line = [[cell.contentView subviews] objectAtIndex:LINEIDX];
        [line removeFromSuperview];
    }

    [buzzTableView setRowHeight:defaultRowHeight];
    [super setEditing:NO animated:NO];
    [buzzTableView setEditing:NO animated:NO];
    [buzzTableView reloadData];
    [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
}

- (void)enterEditingMode
{
    for (NSInteger idx = 0; idx < totalTrip; idx++) {
        customCell *cell = [buzzList objectAtIndex:idx];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(-35,collapsedRowHeight-1,315,1)];
        [line setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView insertSubview:line atIndex:LINEIDX];
    }

    [buzzTableView setRowHeight:collapsedRowHeight];
    [super setEditing:YES animated:YES];
    [buzzTableView setEditing:YES animated:YES];
    [buzzTableView reloadData];
    [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
    [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
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
    
    if (totalTrip > 0) {
        [self.navigationItem setLeftBarButtonItem:editButton];
    }

    if (isEdit == TRUE) {
        [self refresh];
        if (checkAlarm == TRUE) {
            // default reminder time has been changed, check if
            // any of the alarms is affected
            checkAlarm = FALSE;
            customCell *cell = [buzzList objectAtIndex:currentTrip];
            data = [Data getData:[NSString stringWithFormat:@"data%ld.model",currentTrip]];
            for (NSInteger idx = 0; idx < 5; idx++) {
                customButton *button = [[cell.contentView subviews] objectAtIndex:idx];
                if (button.isOn) {
                    NSInteger minute = [self getReminderMinutes:[[[alarmArray objectAtIndex:currentTrip] objectAtIndex:idx] integerValue]];
                    if (minute < 0) {
                        NSLog(@"set alarm off");

                        [self setAlarmOff: button];
                    }
                }
            }
        }
    }

    if (self.editing) {
        [self exitEditingMode];
    }
    
    [buzzTableView reloadData];
}

// automatically refresh MUNI time according to timer
- (void)autoRefresh:(BOOL)animated
{
    if (canRefresh) {
        [buzzTableView beginUpdates];
        [self refresh];
        [buzzTableView endUpdates];
    }
}

// alarms testing function, used during debug only
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
#ifdef USEDEFAULT
    if ([data.useDefault isEqualToString:@"YES"]) {
        reminder = [data.remind_default_label integerValue];
    } else {
#endif
        reminder = [data.remindLabel integerValue];
#ifdef USEDEFAULT
    }
#endif

    return (alarmTime - reminder);
}

#ifdef REPEAT
#ifdef USEDEFAULT
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
#endif
#endif

- (void)setAlarm:(id)sender
{
    NSInteger tmp = ((UIControl*)sender).tag;
    NSInteger ii = tmp / 100;
    NSInteger jj = tmp % 5;
    
    // switch alarm on or off
    customCell *cell = [buzzList objectAtIndex:ii];
    customButton *button = [[cell.contentView subviews] objectAtIndex:jj];
    
    data = [Data getData:[NSString stringWithFormat:@"data%ld.model",ii]];
    if (button.isOn) {
        [self setAlarmOff:button];
        
    } else {
        if ([button.titleLabel.text isEqualToString:@"-"]) {
            return;
        }
        NSDictionary *alarmID = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%ld",ii,jj] forKey:@"id"];
        NSInteger minute = [self getReminderMinutes:[[[alarmArray objectAtIndex:ii] objectAtIndex:jj] integerValue]];
        if (minute <= 0) {
            return;
        }
        [self setAlarmInternal:button.alarm ii:ii jj:jj seconds:(minute * SECPERMIN) alarmID:alarmID];
#ifdef REPEAT
        if ([data.repeatLabel integerValue] > 0) {
            button.alarm2On = TRUE;
            alarmID = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld-%ld-2",ii,jj] forKey:@"id"];
            minute = [self getRepeatMinutes:[[[alarmArray objectAtIndex:ii] objectAtIndex:jj] integerValue]];
            if (minute <= 0) {
                return;
            }
            [self setAlarmInternal:button.alarm2 ii:ii jj:jj seconds:(minute * SECPERMIN) alarmID:alarmID];
        }
        button.alarmOn = TRUE;
#endif
        button.isOn = TRUE;
    }
    [button setBackground];
}

- (void)setAlarmOff:(customButton*)button
{
    UIApplication *app = [UIApplication sharedApplication];

    button.isOn = FALSE;
    [button setBackground];
#ifdef REPEAT
    if (button.alarmOn) {
        button.alarmOn = FALSE;
#endif
        [app cancelLocalNotification:button.alarm];
#ifdef REPEAT
    }
    if (button.alarm2On) {
        button.alarm2On = FALSE;
        [app cancelLocalNotification:button.alarm2];
    }
#endif
}

- (void)setAlarmInternal:(UILocalNotification*)alarm
                      ii:(NSInteger)ii
                      jj:(NSInteger)jj
                 seconds:(NSInteger)seconds
                 alarmID:(NSDictionary*)alarmID
{
    UIApplication *app = [UIApplication sharedApplication];
    [alarm setFireDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];
    alarm.alertBody = @"Your muni is arriving.";
    alarm.applicationIconBadgeNumber = 1;
    alarm.soundName = @"/System/Library/Audio/UISounds/alarm.caf";
    alarm.alertAction = @"View details";
    alarm.hasAction = YES;
    alarm.userInfo = alarmID;
    
    [app scheduleLocalNotification:alarm];
}

// class method called from AppDelegate to turn off a specific alarm after notification is received
+(void)turnOffAlarm:(UILocalNotification*)oneEvent
{
    NSLog(@"turning off alarm");

    NSDictionary *userInfoCurrent = oneEvent.userInfo;
    NSString *str = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"id"]];
    NSScanner *theScanner = [NSScanner scannerWithString:str];
    NSInteger ii = 0;
    NSInteger jj = 0;
#ifdef REPEAT
    NSInteger repeat;
#endif
    [theScanner scanInteger:&ii];
    [theScanner scanString:@"-" intoString:NULL];
    [theScanner scanInteger:&jj];
#ifdef REPEAT
    [theScanner scanString:@"-" intoString:NULL];
    [theScanner scanInteger:&repeat];
#endif
    if (ii < 0 || ii > 5 || jj < 0 || jj > 5) {
        NSLog(@"turning off alarm failed %d %d", ii, jj);
        return;
    }
    UITableViewCell *cell = [buzzList objectAtIndex:ii];
    customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
#ifdef REPEAT
    if ([data.repeatLabel integerValue] == 0) {
        // no repeat, turn off everything
        button.alarmOn = FALSE;
#endif
        button.isOn = FALSE;
        [button setBackground];
        NSLog(@"turn off alarm");
#ifdef REPEAT
    } else if (repeat == 2) {
        // this is the repeat alarm, turn off everything
        NSLog(@"turning off repeat");
        button.alarm2On = FALSE;
        button.isOn = FALSE;
        [button setBackground];
    } else {
        // has unnotified repeat, just turn off first alarm but keep the indication
        button.alarmOn = FALSE;
    }
#endif
}

+(void) recalAlarms:(NSInteger)alarmCount
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    if (alarmCount != [eventArray count]) {
        app.applicationIconBadgeNumber = 0;

        // alarm has been triggered when the app was running in background
        // what this means is that the notification did not go through
        // didReceiveLocalNotification.  This causes a discrepancy in alarm
        // count.  To fix this, we'll turn off all the alarm indicators,
        // and turn on one by one the buttons that has pending notifications
        for (int ii = 0; ii < totalTrip; ii++) {
            for (int jj = 0; jj < 5; jj++) {
                customCell *cell = [buzzList objectAtIndex:ii];
                customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
                button.isOn = FALSE;
                [button setBackground];
            }
        }
        for (int i = 0; i < [eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *slot = [NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"id"]];
            NSScanner *theScanner = [NSScanner scannerWithString:slot];
            NSInteger ii = 0;
            NSInteger jj = 0;
            [theScanner scanInteger:&ii];
            [theScanner scanString:@"-" intoString:NULL];
            [theScanner scanInteger:&jj];
            customCell *cell = [buzzList objectAtIndex:ii];
            customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
            button.isOn = TRUE;
            [button setBackground];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return totalTrip;
}

- (void)refresh
{
    for (NSInteger ii = 0; ii < totalTrip; ii++)
    {
        data = [Data getData:[NSString stringWithFormat:@"data%ld.model",ii]];
#ifdef REPEAT
        BOOL hasRepeat = ([data.repeatLabel integerValue] > 0) ? TRUE : FALSE;
#else
        BOOL hasRepeat = FALSE;
#endif
        newTime = [[self class] refreshTime];
        NSArray *alarmSubarray = [[NSArray alloc] initWithArray:newTime];
        [alarmArray setObject:alarmSubarray atIndexedSubscript:ii];
        customCell *cell = [buzzList objectAtIndex:ii];
        
        // for the first button, refresh everything
        customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:0];
        NSString *newtime = [newTime objectAtIndex:0];
        if (isEdit == TRUE) {
            // clear out the alarm from the previous routes
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
        [self refreshEach:button ii:ii jj:0 hasRepeat:hasRepeat newtime:newtime];
        // for the rest, refresh everything except alarm
        for (NSInteger jj = 1; jj < 5; jj++)
        {
            
            customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
            NSString *newtime = [newTime objectAtIndex:jj];

            [button setTitle:[NSString stringWithFormat:@"%@",newtime] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(setAlarm:) forControlEvents:UIControlEventTouchUpInside];
            // to make the button retrievable, set tag to the schedule #
            // decimal number: xx0y, where xx ranges from 0 to 19 (max trips)
            // and y ranges from 0 to 4 (max alarms per row is 5)
            [self refreshEach:button ii:ii jj:jj hasRepeat:hasRepeat newtime:newtime];


        }
        cell.startLabel.text = data.startLabel;
        cell.destLabel.text = data.destLabel;
    }
    clearAlarms = FALSE;
}

- (void) refreshEach:(customButton*) button
                  ii:(NSInteger)ii
                  jj:(NSInteger)jj
           hasRepeat:(BOOL)hasRepeat
             newtime:(NSString*)newtime
{
    NSInteger reminder = [self getReminderMinutes:[newtime integerValue]];
    button.tag = ii*100+jj;
    if (reminder <= 0 && clearAlarms == FALSE) {
        [button setBackground];
        return;
    }
    if (button.isOn == TRUE) {
#ifdef REPEAT
        if (button.alarmOn) {
#endif
            [[UIApplication sharedApplication] cancelLocalNotification:button.alarm];
#ifdef REPEAT
        }
        if (button.alarm2On) {
            [[UIApplication sharedApplication] cancelLocalNotification:button.alarm2];
            if (!hasRepeat)
                button.alarm2On = FALSE;
        }
#endif
        if (clearAlarms == TRUE) {
            button.isOn = FALSE;
#ifdef REPEAT
            button.alarmOn = FALSE;
            button.alarm2On = FALSE;
#endif
        } else {
#ifdef REPEAT
            if (button.alarmOn) {
#endif
                [button.alarm setFireDate:[NSDate dateWithTimeIntervalSinceNow:(reminder * SECPERMIN)]];
                [[UIApplication sharedApplication] scheduleLocalNotification:button.alarm];
#ifdef REPEAT
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
#endif
        }
    }
    [button setBackground];
}

// this function parses nextbus API
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

// this function shifts the alarms in row #ii by one
+ (void)refreshAlarm:(NSInteger)ii
{
    UITableViewCell *cell = [buzzList objectAtIndex:ii];

    customButton *button = (customButton*)[[cell.contentView subviews] objectAtIndex:0];
    for (int jj = 1; jj < 5; jj++)
    {
        customButton *button2 = (customButton*)[[cell.contentView subviews] objectAtIndex:jj];
        button.alarm = button2.alarm;
        button.titleLabel.text = button2.titleLabel.text;
        button.isOn = button2.isOn;
#ifdef REPEAT
        button.alarmOn = button2.alarmOn;
        button.alarm2 = button2.alarm2;
        button.alarm2On = button2.alarm2On;
#endif
        [button setBackground];
        button = button2;
    }
    button.alarm = [[UILocalNotification alloc] init];
#ifdef REPEAT
    button.alarmOn = FALSE;
    button.alarm2 = [[UILocalNotification alloc] init];
    button.alarm2On = FALSE;
#endif
    button.isOn = FALSE;
    [button setBackground];
}

- (customCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"buzzCell";
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    data = [Data getData:[NSString stringWithFormat:@"data%ld.model",indexPath.row]];
    cell.startLabel.text = data.startLabel;
    cell.destLabel.text = data.destLabel;
    cell.routeId.text = data.routeId;

    [cell.contentView insertSubview:cell.startLabel atIndex:STARTLABELTAG];
    [cell.contentView insertSubview:cell.destLabel atIndex:DESTLABELTAG];
    [cell.contentView insertSubview:cell.routeId atIndex:ROUTEIDTAG];
 
    [buzzList setObject:cell atIndexedSubscript:indexPath.row];

    if (indexPath.row == totalTrip-1) {
        canRefresh = TRUE;
        if (initialized == FALSE) {
            initialized = TRUE;
            [self refresh];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoutesViewController *rvc = [self.storyboard instantiateViewControllerWithIdentifier:
                                 @"routesController"];
    isEdit = TRUE;
    currentTrip = indexPath.row;
    [self.navigationController pushViewController:rvc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        customCell *cell = [buzzList objectAtIndex:indexPath.row];

        //deactivate existing alarms
        for (NSInteger idx=0; idx < 5; idx++) {
            customButton *button = [[cell.contentView subviews] objectAtIndex:idx];
            if (button.isOn) {
                [self setAlarmOff:button];
            }
        }
        
        [Data removeData:indexPath.row];
        [buzzTableView reloadData];
        
        if (totalTrip == 0) {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

@end
