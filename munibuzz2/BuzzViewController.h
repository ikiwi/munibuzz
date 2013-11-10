//
//  BuzzViewController.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Data.h"

BOOL isEdit;
BOOL checkAlarm;
BOOL clearAlarms;
BOOL canRefresh;
BOOL refreshNow;
NSInteger routeToDelete;
NSInteger currentTrip;
UILocalNotification *notification;

@interface BuzzViewController : UIViewController {
    NSMutableArray *_buzzArray;
    NSMutableArray *_alarmArray;
}

@property (strong, nonatomic) NSMutableArray *buzzArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *buzzTableView;
@property (weak, nonatomic) IBOutlet UILabel *slabel;
@property (weak, nonatomic) IBOutlet UILabel *dlabel;
@property (weak, nonatomic) IBOutlet UILabel *rid;
@property (strong, nonatomic) IBOutlet UIButton *addRouteButton;
@property (strong, nonatomic) NSMutableArray *alarmArray;

-(void)addOrDeleteRows:(id)sender;
-(void)setAlarm:(id)sender;
-(void)setAlarm:(id)sender force:(BOOL)force;
-(void)setAlarmInternal:(UILocalNotification*)alarm
                     ii:(NSInteger)ii
                     jj:(NSInteger)jj
                seconds:(NSInteger)seconds
                alarmID:(NSDictionary*)alarmID;
- (NSMutableArray*)nextbusAPIWithData:(Data*)data;
- (void)autoRefresh:(BOOL)animated;
+(void)refreshAlarmInRow:(NSInteger)index;
+(void)turnOffAlarm:(UILocalNotification*)notification;
+(void)recalAlarms:(NSInteger)alarmCount;
-(void)adjustAlarmsInRow:(NSInteger)ii;

@end
