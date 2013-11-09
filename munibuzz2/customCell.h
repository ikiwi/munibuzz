//
//  customCell.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/17/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInteger LINEIDX;
NSInteger defaultRowHeight;
NSInteger collapsedRowHeight;

@interface customCell : UITableViewCell {
    UILabel *startLabel;
    UILabel *destLabel;
    UILabel *routeId;
    UILabel *line;
}

@property (strong, nonatomic) UILabel *startLabel;
@property (strong, nonatomic) UILabel *destLabel;
@property (strong, nonatomic) UILabel *routeId;
@property (strong, nonatomic) UILabel *line;

@end
