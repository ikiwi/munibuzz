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
@end
