//
//  FMBDStorage.m
//  PasswordManager
//
//  Created by Vladislav Librecht on 16.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "FMDBStorage.h"
#import "Record.h"
#import <FMDB.h>

static NSString *const recordsTableName = @"records";
static NSString *const serviceNameColumnName = @"service_name";
static NSString *const passwordColumnName = @"password";

@interface FMDBStorage ()

@property (nonatomic, strong) NSURL *url;

@end

@implementation FMDBStorage

@synthesize url = url_;

#pragma mark - Initialization

- (id)init
{
    NSLog(@"Please use -initWithURL: instead.");
    [self doesNotRecognizeSelector:_cmd];
    
    return nil;
}

- (instancetype)initWithURL:(NSURL *)url
{
    if ((self = [super init])) {
        
        url_ = [url URLByAppendingPathExtension:@"sqlite"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:url_.absoluteString];
        [database open];
        if (![database tableExists:recordsTableName]) {
            
            NSString *createTableQuery = [NSString stringWithFormat:@"CREATE TABLE %@ (%@ TEXT PRIMARY KEY DEFAULT NULL, %@ TEXT DEFAULT NULL)", recordsTableName, serviceNameColumnName, passwordColumnName];
            [database executeUpdate:createTableQuery];
        }
        [database close];
    }
    
    return self;
}

#pragma mark - Management of database

- (NSMutableArray *)selectRecords
{
    NSMutableArray *records = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:self.url.absoluteString];
    
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:
                                [NSString stringWithFormat:@"SELECT * FROM %@", recordsTableName]];
        
        while ([results next]) {
            NSString *serviceName = [results stringForColumn:serviceNameColumnName];
            NSString *password = [results stringForColumn:passwordColumnName];
            [records addObject:@{kServiceName: serviceName,
                                 kPassword: password}];
        }
    }];
    
    return records;
}

- (BOOL)insertRecords:(NSArray *)records
{
    FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:self.url.absoluteString];
    
    BOOL __block succeed = YES;
    [queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        
        for (NSDictionary *record in records) {
            [db executeUpdate:[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@, %@) VALUES (?, ?)", recordsTableName, serviceNameColumnName, passwordColumnName],
             record[kServiceName], record[kPassword]];
        }
        
        succeed = [db commit];
    }];
    
    return succeed;
}

- (BOOL)deleteRecords:(NSArray *)records
{
    BOOL __block succeed = YES;
    
    if ([records count] != 0) {
        
        FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:self.url.absoluteString];
        
        [queue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            
            for (NSDictionary *record in records) {
                [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ?", recordsTableName, serviceNameColumnName, passwordColumnName],
                 record[kServiceName], record[kPassword]];
            }
            
            succeed = [db commit];
        }];
    }
    return succeed;
}

- (BOOL)deleteAllRecords
{
    BOOL __block succeed = YES;
    
    FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:self.url.absoluteString];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", recordsTableName]];
        
        succeed = [db commit];
    }];
    
    return succeed;
}

@end















