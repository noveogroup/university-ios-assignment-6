//
//  FmdbHandler.m
//  PasswordManager
//
//  Created by Wadim on 8/6/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "FmdbHandler.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Record.h"

@interface FmdbHandler ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation FmdbHandler

- (instancetype)initWithContentsOfUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        NSLog(@"FMDB Path: %@",[url path]);
        _queue = [FMDatabaseQueue databaseQueueWithPath:[url path]];
        [_queue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS myrecords ("
            "id INTEGER PRIMARY KEY,"
            "service_name TEXT,"
            "password TEXT)"];
        }];
    }
    return self;
}

- (void) saveArrayToDb:(NSArray *)records
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM myrecords"];
        for (NSDictionary *record  in records) {
            [db executeUpdate:@"INSERT INTO myrecords (service_name, password) "
            "VALUES (?,?)", record[kServiceName], record[kPassword]];
        }
    }];
}

- (NSArray *)loadArrayFromDb
{
    NSMutableArray *__block newMutableArray = [[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *newResultSet = [db executeQuery:@"SELECT * FROM myrecords"];
        while ([newResultSet next]) {
            NSDictionary *newRecord = @{
                kServiceName: [newResultSet stringForColumn:@"service_name"],
                kPassword: [newResultSet stringForColumn:@"password"]
            };
         [newMutableArray addObject:newRecord];
        }
    }];
    return [newMutableArray copy];
}

@end
