//
//  PickerView.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/15/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        labels = [[NSMutableDictionary alloc] initWithCapacity:15];
    }
    return self;
}


- (void) addLabel:(NSString *)labeltext index:(NSInteger)index
{
//    [labels setObject:labeltext forKey:[NSNumber numberWithInt:amount]];
    
    NSString *keyName = [NSString stringWithFormat:@"%@", labeltext];
    
    [labels setValue:labeltext forKey:keyName];
}

@end
