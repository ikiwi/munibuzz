//
//  Data.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/15/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject <NSCoding>

@property (strong, nonatomic) NSMutableString *startLabel;
@property (strong, nonatomic) NSMutableString *startStopTag;
@property (strong, nonatomic) NSMutableString *startStopId;
@property (strong, nonatomic) NSMutableString *destLabel;
@property (strong, nonatomic) NSMutableString *routeId;
#ifdef USEDEFAULT
@property (strong, nonatomic) NSMutableString *useDefault;
#endif
#ifdef REPEAT
@property (strong, nonatomic) NSMutableString *repeatLabel;
@property (strong, nonatomic) NSMutableString *repeat_default_label;
#endif
@property (strong, nonatomic) NSMutableString *remindLabel;
#ifdef USEDEFAULT
@property (strong, nonatomic) NSMutableString *remind_default_label;
#endif
@property (strong, nonatomic) NSMutableString *filename;
@property (strong, nonatomic) NSMutableString *alarm;

-(Data*)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)anEncoder;
+ (NSString *)getPathToArchive:(NSString *)filename;
+(void)saveData:(Data *)aData filename:(NSString *)filename;
+(void)saveAll:(NSArray *)aArray;
+(Data *)getData:(NSString *)filename;
+(void)removeData:(NSInteger)slot;
+(NSMutableArray *)getAll;

@end
