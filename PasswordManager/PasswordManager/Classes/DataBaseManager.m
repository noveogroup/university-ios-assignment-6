//
//  DataBaseManager.m
//  PasswordManager
//
//  Created by Admin on 06/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "Record.h"

@interface DataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue* queue;

@end

@implementation DataBaseManager

-(instancetype)initWithURL:(NSURL *)url
{
    if(self = [super init]){
        _queue = [FMDatabaseQueue databaseQueueWithPath:[url path]];
        [_queue inDatabase:^(FMDatabase *db) {
            NSString* query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS records (id INTEGER PRIMARY KEY, %@ TEXT, %@ TEXT)",kServiceName,kPassword];
            [db executeUpdate:query];
        }];
    }
    return self;
}

-(NSArray*)records
{
    NSMutableArray* mutableRecords = [[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet* results = [db executeQuery:@"SELECT * FROM records"];
        while([results next]){
            NSDictionary* newRecord = @{ kServiceName : [results stringForColumn:kServiceName], kPassword : [results stringForColumn:kPassword] };
            [mutableRecords addObject:newRecord];
        }
    }];
    return [mutableRecords copy];
}
         
-(BOOL)synchronizeWith:(NSArray *)records
{
    NSMutableArray* dbRecords = [[NSMutableArray alloc]init];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet* results = [db executeQuery:@"SELECT * FROM records"];
        while([results next]){
            NSDictionary* newRecord = @{ kServiceName : [results stringForColumn:kServiceName], kPassword : [results stringForColumn:kPassword] };
            [dbRecords addObject:newRecord];
        }
    }];
    for(NSDictionary* dbRecord in dbRecords){
        if(![records containsObject:dbRecord]){
            [self.queue inDatabase:^(FMDatabase *db) {
                NSString* query = [NSString stringWithFormat:@"DELETE FROM records WHERE %@ = ? AND %@ = ?",kServiceName,kPassword];
                [db executeUpdate:query,dbRecord[kServiceName],dbRecord[kPassword]];
                
            }];
        }
    }
    for(NSDictionary* record in records){
        if(![dbRecords containsObject:record]){
            [self.queue inDatabase:^(FMDatabase *db) {
                NSString* query = [NSString stringWithFormat:@"INSERT INTO records(%@,%@) VALUES(?,?)",kServiceName,kPassword];
                [db executeUpdate:query,record[kServiceName],record[kPassword]];                
            }];
        }
    }
    return YES;
}

@end
