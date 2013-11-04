//
//  RoutesDatabase.h
//  munibuzz2
//
//  Created by Kalai Wei on 10/29/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface RoutesDatabase : NSObject {
    sqlite3 *_database;
}

+ (RoutesDatabase*)database;
- (NSArray *)RoutesInfo:(const char*)query;
- (NSArray *)DirectionsInfo:(const char*)query
                  direction:(NSString*)direction
                      route:(NSString*)route;

@end
