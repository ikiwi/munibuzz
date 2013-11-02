//
//  StopsTableViewController.h
//  munibuzz_search
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutesViewController.h"

@interface StopsTableViewController : UITableViewController  <UISearchBarDelegate, UISearchDisplayDelegate>
@property NSString *operation;
@property IBOutlet UISearchBar *stopsSearchBar;
+(void)refreshDirectionArray:(NSArray*)rarray1 rarray2:(NSArray*)rarray2;
@end

