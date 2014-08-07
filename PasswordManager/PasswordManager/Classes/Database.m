//
//  Database.m
//  PasswordManager
//
//  Created by Admin on 05/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "Database.h"
#import "Record.h"
#import "fmdb/FMDatabaseQueue.h"
#import "fmdb/FMDatabase.h"
#import "fmdb/FMResultSet.h"

@interface Database ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation Database

- (instancetype)init {
    self = [super init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = paths[0];
   
    NSString *writableDBPath = [libraryDirectory stringByAppendingPathComponent:@"erundopel.sqlite"];

    _queue = [FMDatabaseQueue databaseQueueWithPath:writableDBPath];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"CREATE TABLE IF NOT EXISTS records ("
            "id INTEGER PRIMARY KEY,"
            "service_name TEXT,"
            "password TEXT"
            ")"
        ];
    }];

    return self;
}

- (void)saveRecords:(NSArray *)records {
    [self deleteAllRecords];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        for (NSDictionary *record in records) {
            [db executeUpdate:
                [NSString stringWithFormat:
                    @"INSERT INTO records "
                    "(service_name, password)"
                    "VALUES (:%@, :%@)",
                    kServiceName,
                    kPassword
                ]
                withParameterDictionary:record
            ];
        }
    }];
}

- (NSMutableArray *)loadRecords {
    NSMutableArray *__block mutableArray = [[NSMutableArray alloc] init];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:
            @"SELECT * "
            "FROM records"
        ];
        
        while ([rs next]) {
            NSDictionary *record = @{
                kServiceName: [rs stringForColumn:@"service_name"],
                kPassword: [rs stringForColumn:@"password"]
            };
            
            [mutableArray addObject:record];
        }
    }];
    
    return mutableArray;
}

- (void)deleteAllRecords {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:
            @"DELETE FROM records"
        ];
    }];
}

@end
