//
//  BuzzViewController.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL isEdit;
BOOL checkAlarm;
BOOL clearAlarms;
BOOL canRefresh;
NSInteger currentTrip;
NSMutableArray *buzzList;
UILocalNotification *notification;

@interface BuzzViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *buzzArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *buzzTableView;
@property (weak, nonatomic) IBOutlet UILabel *slabel;
@property (weak, nonatomic) IBOutlet UILabel *dlabel;
@property (weak, nonatomic) IBOutlet UILabel *rid;
@property (strong, nonatomic) IBOutlet UIButton *addRouteButton;
@property (strong, nonatomic) NSMutableArray *alarmArray;
@property (strong, nonatomic) NSMutableArray *rowTimer;

-(void)addOrDeleteRows:(id)sender;
-(void)setAlarm:(id)sender;
-(void)setAlarmInternal:(UILocalNotification*)alarm
                     ii:(NSInteger)ii
                     jj:(NSInteger)jj
                seconds:(NSInteger)seconds
                alarmID:(NSDictionary*)alarmID;
+(NSArray*)refreshTime;
- (void)autoRefresh:(BOOL)animated;
+(void)refreshAlarm:(NSInteger)index;
+(void)turnOffAlarm:(UILocalNotification*)notification;

@end
