//
//  redButton.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/14/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "buzzData.h"

@interface redButton : UIButton

@property (nonatomic, strong) buzzData *buzz;

+ (void)setBuzz:(buzzData*)buzz;

@end
