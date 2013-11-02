//
//  RoutesDatabase.m
//  munibuzz2
//
//  Created by Kalai Wei on 10/29/13.
//  Copyright (c) 2013 Kalai Wei. All rights reserved.
//

#import "RoutesDatabase.h"
#import "Stops.h"

@implementation RoutesDatabase

static RoutesDatabase *_database;

+ (RoutesDatabase*)database {
    if (_database == nil) {
        _database = [[RoutesDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"data.sqlite3"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if (success == FALSE)
        {
            NSLog(@"Error finding path %@", dbPath);
        }
        if(sqlite3_open([dbPath UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"An error has occured.");
        }
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
}

- (NSArray *)RoutesInfo:(const char*) query {
    sqlite3_stmt *statement;
    NSMutableArray *retval = [[NSMutableArray alloc] init];

    if (sqlite3_prepare((_database), query, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int key = (int) sqlite3_column_text(statement, 0);
            char *titleChars = (char *) sqlite3_column_text(statement, 1);
            char *nameChars = (char *) sqlite3_column_text(statement, 2);
            char *stopidChars = (char *) sqlite3_column_text(statement, 3);
            char *dirChars = (char *) sqlite3_column_text(statement, 4);
            char *routeChars = (char *) sqlite3_column_text(statement, 5);
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *title = [[NSString alloc] initWithUTF8String:titleChars];
            NSString *stopid = [[NSString alloc] initWithUTF8String:stopidChars];
            NSString *direction = [[NSString alloc] initWithUTF8String:dirChars];
            NSString *route = [[NSString alloc] initWithUTF8String:routeChars];
            
            [retval addObject:[Stops stopsId:key sTag:name title:title sId:stopid dTag:direction rId:route]];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

- (NSArray *)DirectionsInfo:(const char*) query direction:(NSString*)direction route:(NSString*)route{
    sqlite3_stmt *statement;
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare((_database), query, -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int key = (int) sqlite3_column_int(statement, 0);
            char *titleChars = (char *) sqlite3_column_text(statement, 1);
            char *stopidChars = (char *) sqlite3_column_text(statement, 2);
            NSString *title = [[NSString alloc] initWithUTF8String:titleChars];
            NSString *stopid = [[NSString alloc] initWithUTF8String:stopidChars];

            [retval addObject:[Stops stopsId:key sTag:stopid title:title sId:@"" dTag:direction rId:route]];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

@end
