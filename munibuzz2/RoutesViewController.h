//
//  RoutesViewController.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopsTableViewController.h"

@interface RoutesViewController : UIViewController
@property (strong,nonatomic) NSArray *tripArray;
@property (strong,nonatomic) UITableViewCell *startCell;
@property (strong,nonatomic) UITableViewCell *destCell;
@property (strong,nonatomic) UITableViewCell *routeCell;
@property (strong,nonatomic) UITableViewCell *remindCell;
@property (strong,nonatomic) UITableViewCell *repeatCell;
@property (strong,nonatomic) UITableViewCell *includeReturnCell;
@property (strong,nonatomic) UITableViewCell *useDefaultCell;
@end
