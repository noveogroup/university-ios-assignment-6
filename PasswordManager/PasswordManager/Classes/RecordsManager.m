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
        if ([[Preferences standardPreferences] storage] == 0)
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
            //self.db = [FMDatabase databaseWithPath:self.path];
            [self.db open];
            [self.db executeUpdate:@"CREATE TABLE records (ServiceName TEXT PRIMARY KEY DEFAULT NULL, Password TEXT DEFAULT NULL)"];
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

#pragma mark - Synchronisation

- (BOOL)synchronize
{
    if ([[Preferences standardPreferences] storage] == 0)
    {
        return [self.mutableRecords writeToURL:self.url atomically:YES];
    }
    else
    {
        [self.db open];
        [self.db beginTransaction];
        for (NSDictionary *record in self.mutableRecords)
        {
            
            [self.db executeUpdate:@"INSERT INTO records (ServiceName, Password) VALUES (?, ?)", [record valueForKey:kServiceName], [record valueForKey:kPassword]];
        }
        [self.db commit];
        return [self.db close];
    }
}

@end
