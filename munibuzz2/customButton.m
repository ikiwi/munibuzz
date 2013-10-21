//
//  customButton.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/16/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "customButton.h"

@implementation customButton
@synthesize minute;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self setTitle:@"-" forState:UIControlStateNormal];
        self.tintColor = [UIColor whiteColor];
        [self setTitle:[NSString stringWithFormat:@"%ld", self.minute] forState:UIControlStateNormal];
    }
    return self;
}

- (BOOL)isAlarmOn
{
    if ([self.backgroundColor isEqual:[UIColor redColor]])
        return FALSE;
    return TRUE;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
