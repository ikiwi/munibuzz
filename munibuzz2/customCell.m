//
//  customCell.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/17/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "customCell.h"
#import "customButton.h"
#import "AppDelegate.h"

@implementation customCell
@synthesize startLabel;
@synthesize destLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSInteger offset = 0;
        if (!IS_IPHONE_5) {
            offset = 5;
        }
        self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,5+offset,200,20)];
        self.destLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,25+offset,200,20)];
        self.routeId = [[UILabel alloc] initWithFrame:CGRectMake(25,7+offset,30,15)];
        [self.routeId setTextAlignment:NSTextAlignmentRight];
        self.startLabel.textColor = [UIColor redColor];
        self.startLabel.backgroundColor = [UIColor whiteColor];
        self.destLabel.textColor = [UIColor redColor];
        self.destLabel.backgroundColor = [UIColor whiteColor];
        NSInteger xx = 0;
        for (int idx = 0; idx < 5; idx++)
        {
            customButton *button;
            button = [[customButton alloc] initWithFrame:CGRectMake(xx,50,64,64)];
            button.titleLabel.text = @"-";
            [self.contentView insertSubview:button atIndex:idx];
            xx += 64;
        }
        
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0.2);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = .8;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
