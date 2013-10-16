//
//  Data.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/15/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject <NSCoding>
@property (strong, nonatomic) NSString *startLabel;
@property (strong, nonatomic) NSString *destLabel;
@property (strong, nonatomic) NSString *routeLabel;
@property (strong, nonatomic) NSString *useDefault;
@property (strong, nonatomic) NSString *includeReturn;
@property (strong, nonatomic) NSString *repeatLabel;
@property (strong, nonatomic) NSString *repeat_default_label;
@property (strong, nonatomic) NSString *remindLabel;
@property (strong, nonatomic) NSString *remind_default_label;

-(Data*)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)anEncoder;
+ (NSString *)getPathToArchive;
@end
