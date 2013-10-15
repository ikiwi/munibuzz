//
//  BuzzViewController.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "BuzzViewController.h"
#import "buzzData.h"

@interface BuzzViewController ()

@end

@implementation BuzzViewController
@synthesize buzzArray;
@synthesize redButton1;
@synthesize redButton2;
@synthesize redButton3;
@synthesize redButton4;
@synthesize redButton5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    buzzData *buzz;
    buzzArray = [NSArray arrayWithObjects:
                 [buzzData buzzId:redButton1 buzzMinute:@"-"],
                 [buzzData buzzId:redButton2 buzzMinute:@"-"],
                 [buzzData buzzId:redButton3 buzzMinute:@"-"],
                 [buzzData buzzId:redButton4 buzzMinute:@"-"],
                 [buzzData buzzId:redButton5 buzzMinute:@"-"], nil];

    buzz = [buzzArray objectAtIndex:0];
    [buzz.buzzButton setTitle:@"12" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
