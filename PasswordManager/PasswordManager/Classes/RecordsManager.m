//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import <FMDB.h>
#import <FMDatabaseQueue.h>
#import <FMResultSet.h>
#import "Preferences.h"
#import "Record.h"



@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize path = path_;
@synthesize db = db_;
@synthesize mutableRecords = mutableRecords_;

#pragma mark - Initialization

- (id)init
{
    NSLog(@"Please use -initWithURL: instead.");
    [self doesNotRecognizeSelector:_cmd];

    return nil;
}

- (instancetype)initWithURL:(NSURL *)url andPath:(NSString *)path
{
    if ((self = [super init])) {
        url_ = url;
        path_ = path;
        db_ = [FMDatabase databaseWithPath:path];
    }

    return self;
}

#pragma mark - Management of records

- (void)registerRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords addObject:record];
    }
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_)
    {
        if ([[Preferences standardPreferences] storage] == StorageFile)
        {
            mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
            if (!mutableRecords_)
            {
                mutableRecords_ = [NSMutableArray array];
            }
        }
        else
        {
            mutableRecords_ = [NSMutableArray array];
            [self.db open];
            [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS records (ServiceName TEXT PRIMARY KEY DEFAULT NULL, Password TEXT DEFAULT NULL)"];
            FMResultSet *results = [self.db executeQuery:@"SELECT * FROM records"];
            while ([results next])
            {
                NSDictionary *const record = @{kServiceName: [results stringForColumn:kServiceName], kPassword: [results stringForColumn:kPassword]};
                [mutableRecords_ addObject:record];
            }
            [self.db close];
        }
        
    }

    return mutableRecords_;
}

- (NSArray *)records
{
    return [self.mutableRecords copy];
}

- (void)deleteRecordAtIndex:(NSInteger) index
{
    [self.mutableRecords removeObjectAtIndex:index];
}

- (void)replaceRecord:(NSDictionary*)oldRecord withRecord:(NSDictionary*)newRecord
{
    if([self.mutableRecords containsObject:oldRecord])
    {
        NSInteger index = [self.mutableRecords indexOfObject:oldRecord];
        [self.mutableRecords removeObject:oldRecord];
        [self.mutableRecords insertObject:newRecord atIndex:index];
    }
}

#pragma mark - Synchronisation

- (BOOL)synchronize
{
    if ([[Preferences standardPreferences] storage] == StorageFile)
    {
        return [self.mutableRecords writeToURL:self.url atomically:YES];
    }
    else
    {
        FMDatabaseQueue *queue = [[FMDatabaseQueue alloc]initWithPath:self.path];
        [queue inDatabase:^(FMDatabase *db){
            [db beginTransaction];
            [db executeUpdate:@"DELETE FROM records"];
            for (NSDictionary *record in self.mutableRecords)
            {
                
                [db executeUpdate:@"INSERT INTO records (ServiceName, Password) VALUES (?, ?)", [record valueForKey:kServiceName], [record valueForKey:kPassword]];
            }
            [db commit];
         
        }];
        
        return YES;
    }
}

@end
