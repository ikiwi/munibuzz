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
{
    NSArray *_tripArray;
    UITableViewCell *_startCell;
    UITableViewCell *_destCell;
    UITableViewCell *_routeCell;
    UITableViewCell *_remindCell;
#ifdef REPEAT
    UITableViewCell *_repeatCell;
    UIPickerView *_repeatPickerView;
#endif
#ifdef USEDEFAULT
    UITableViewCell *_useDefaultCell;
#endif
    UIPickerView *_pickerView;

}

@property (strong,nonatomic) NSArray *tripArray;
@property (strong,nonatomic) UITableViewCell *startCell;
@property (strong,nonatomic) UITableViewCell *destCell;
@property (strong,nonatomic) UITableViewCell *routeCell;
@property (strong,nonatomic) UITableViewCell *remindCell;
#ifdef REPEAT
@property (strong,nonatomic) UITableViewCell *repeatCell;
@property (nonatomic, retain) UIPickerView *repeatPickerView;
#endif
#ifdef USEDEFAULT
@property (strong,nonatomic) UITableViewCell *useDefaultCell;
#endif
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *saveRoute;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backToBuzz;

@end
