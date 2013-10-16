//
//  PickerView.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/15/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerView : UIPickerView {
    NSMutableDictionary *labels;
}

- (void) addLabel:(NSString *)labeltext;
//- (void) updateLabel:(NSString *)labeltext forComponent:(NSUInteger)component;
@end
