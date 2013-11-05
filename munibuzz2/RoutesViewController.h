//
//  RoutesViewController.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopsTableViewController.h"
#import "Data.h"

Data *data;
NSString *filename;
NSArray *routesArray;
NSArray *stopsArray;
NSMutableArray *rarray1;
NSMutableArray *rarray2;
NSMutableArray *filteredStopsArray;
NSMutableArray *directionArray;
BOOL skipGetData;
@interface RoutesViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong,nonatomic) NSArray *tripArray;
@property (strong,nonatomic) UITableViewCell *startCell;
@property (strong,nonatomic) UITableViewCell *destCell;
@property (strong,nonatomic) UITableViewCell *routeCell;
@property (strong,nonatomic) UITableViewCell *remindCell;
#ifdef REPEAT
@property (strong,nonatomic) UITableViewCell *repeatCell;
#endif
#ifdef USEDEFAULT
@property (strong,nonatomic) UITableViewCell *useDefaultCell;
#endif
@property (nonatomic, retain) UIBarButtonItem *reminderDoneButton;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIBarButtonItem *repeatDoneButton;
@property (nonatomic, retain) UIPickerView *repeatPickerView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveRoute;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backToBuzz;

@end
