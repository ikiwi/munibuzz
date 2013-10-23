//
//  customCell.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/17/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "customCell.h"
#import "customButton.h"

@implementation customCell
@synthesize startLabel;
@synthesize destLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,5,200,20)];
        self.destLabel = [[UILabel alloc] initWithFrame:CGRectMake(55,25,200,20)];
        self.startLabel.textColor = [UIColor redColor];
        self.startLabel.backgroundColor = [UIColor whiteColor];
        self.destLabel.textColor = [UIColor redColor];
        self.destLabel.backgroundColor = [UIColor whiteColor];
        NSInteger xx = 0;
        for (NSInteger idx = 0; idx < 5; idx++)
        {
            customButton *button = [[customButton alloc] initWithFrame:CGRectMake(xx,50,64,64)];
            button.titleLabel.text = [NSString stringWithFormat:@"%ld", idx];
            [self.contentView insertSubview:button atIndex:idx];
            xx += 64;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
