//
//  Data.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/15/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject <NSCoding> {
    NSMutableString *_startLabel;
    NSMutableString *_startStopTag;
    NSMutableString *_startStopId;
    NSMutableString *_destLabel;
    NSMutableString *_routeId;
#ifdef USEDEFAULT
    NSMutableString *_useDefault;
#endif
#ifdef REPEAT
    NSMutableString *_repeatLabel;
    NSMutableString *_repeat_default_label;
#endif
    NSMutableString *_remindLabel;
#ifdef USEDEFAULT
    NSMutableString *_remind_default_label;
#endif
    NSMutableString *_filename;
    NSMutableString *_alarm;
}

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
