//
//  FMDBStorage.m
//  PasswordManager
//
//  Created by Menzarar on 25.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "FMDBStorage.h"
#import <FMDB.h>
#import "Record.h"


@interface FMDBStorage ()

@property (nonatomic, strong) NSURL *url;

@end

@implementation FMDBStorage

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
        
        _url = [url URLByAppendingPathExtension:@"sqlite"];
        
        FMDatabase *db = [FMDatabase databaseWithPath:_url.absoluteString];
        if ([db open]) {
            if (![db tableExists:kDataBaseNameRecords]) {
                NSString *sql = [NSString stringWithFormat: @"CREATE TABLE %@ (%@ TEXT PRIMARY KEY DEFAULT NULL, %@ TEXT DEFAULT NULL)", kDataBaseNameRecords, kDataBaseColumnServiceName, kDataBaseColumnPassword];
                BOOL success = [db executeUpdate:sql];
                if(!success) {
                    NSLog(@"error = %@", [db lastErrorMessage]);
                }
            }
            [db close];
        }
        
    }
    
    return self;
}

- (NSMutableArray *)records
{
    NSMutableArray *mutableRecords = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.url.absoluteString];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@", kDataBaseNameRecords]];
        while ([rs next]) {
            NSString * serviceName = [rs stringForColumn:kDataBaseColumnServiceName];
            NSString * password = [rs stringForColumn:kDataBaseColumnPassword];
            [mutableRecords addObject:@{
                                        kServiceName: serviceName,
                                        kPassword: password
                                        }
             ];
            
        }
    }];
    return mutableRecords;
}

- (BOOL)addRecords:(NSArray *)records
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.url.absoluteString];
    
    BOOL __block success = YES;
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for(NSDictionary *record in records) {
            success = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES (?, ?)", kDataBaseNameRecords, kDataBaseColumnServiceName, kDataBaseColumnPassword], record[kServiceName], record[kPassword]];
            
            if(!success) {
                *rollback = YES;
                return;
            }
        }
        
    }];
    
    return success;
}

- (BOOL)deleteRecords:(NSArray *)records
{
    BOOL __block success = YES;
    
    if (records.count) {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.url.absoluteString];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for(NSDictionary *record in records) {
            success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ? AND %@ = ?", kDataBaseNameRecords, kDataBaseColumnServiceName, kDataBaseColumnPassword], record[kDataBaseColumnServiceName], record[kDataBaseColumnPassword]];
                if(!success) {
                    *rollback = YES;
                    return;
                }
            }
        }];
    }
    
    return success;
}

-(BOOL)deleteAllRecords
{
    BOOL __block success = YES;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.url.absoluteString];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        success = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", kDataBaseNameRecords]];
        if(!success) {
            *rollback = YES;
            return;
        }
    }];
    
    return success;
}

@end
