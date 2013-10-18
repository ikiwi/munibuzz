//
//  BuzzViewController.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL isEdit;
NSInteger currentTrip;
NSMutableArray *buzzList;

@interface BuzzViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *buzzArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBuzz;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *buzzTableView;
@property (weak, nonatomic) IBOutlet UILabel *slabel;
@property (weak, nonatomic) IBOutlet UILabel *dlabel;
@property BOOL canRefresh;
-(IBAction)editTrip:(id)sender;
-(void)addRow:(UITableViewCell*)sender;

@end
