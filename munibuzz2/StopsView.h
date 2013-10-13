//
//  StopsView.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/12/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopsView : UIView
@property (strong,nonatomic) NSArray *stopsArray;
@property (strong,nonatomic) NSMutableArray *filteredStopsArray;
@property IBOutlet UISearchBar *stopsSearchBar;
@end
