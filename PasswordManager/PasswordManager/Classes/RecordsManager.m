//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "Record.h"
#import "Preferences.h"
#import "FMDB.h"

static NSString *const DefaultFileNameForSerializer = @"Storage.ser";
static NSString *const DefaultFileNameForDB = @"Storage.db";

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, readonly) NSString *pathSerializer;
@property (nonatomic, readonly) NSString *pathDB;
@property (nonatomic) FMDatabase *database;
@end

@implementation RecordsManager

@synthesize pathSerializer = pathSerializer_;
@synthesize mutableRecords = mutableRecords_;
@synthesize pathDB = pathDB_;
@synthesize database = database_;

#pragma mark - Initialization

- (id)init
{
    if (self=[super init]) {
        NSArray *docsDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = docsDirs.firstObject;
        pathSerializer_ = [docsDir stringByAppendingPathComponent:DefaultFileNameForSerializer];
    }
    return self;
}

#pragma mark - Management of records


- (FMDatabase *)database
{
    if (database_ == nil) {
        NSArray *docsDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = docsDirs.firstObject;
        pathDB_ = [docsDir stringByAppendingPathComponent:DefaultFileNameForDB];
        database_ = [FMDatabase databaseWithPath:self.pathDB];
        database_.logsErrors = NO;
        [database_ open];
        NSString *tableCreation =
        [NSString stringWithFormat:@"CREATE TABLE records (id INTEGER  PRIMARY KEY DEFAULT NULL, %@ TEXT DEFAULT NULL, %@ TEXT DEFAULT NULL)", kServiceName, kPassword];
        [database_ executeUpdate:tableCreation];
        [database_ close];
    }
    return database_;
}

- (void)registerRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords addObject:record];
    }
}

- (void)deleteRecordAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mutableRecords removeObject:self.mutableRecords[indexPath.row]];
}

- (void)replaceRecordAtIndexPath:(NSIndexPath *)indexPath byRecord:(NSDictionary *)record
{
    self.mutableRecords[indexPath.row] = record;
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_) {
        if ([Preferences standardPreferences].lastStorage == StorageTypeWithSerializer) {
            mutableRecords_ = [NSMutableArray arrayWithContentsOfFile:self.pathSerializer];
            if (!mutableRecords_) {
                mutableRecords_ = [NSMutableArray array];
            }
        }
        else {
            [self.database open];
            FMResultSet *records = [self.database executeQuery: @"SELECT * FROM records"];
            mutableRecords_ = [[NSMutableArray alloc] init];
            while ([records next]) {
                NSDictionary *record = @{kServiceName: [records stringForColumn:kServiceName],
                                         kPassword: [records stringForColumn:kPassword]};
                [mutableRecords_ addObject:record];
            }
            [self.database close];
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
    if ([Preferences standardPreferences].storageType == StorageTypeWithSerializer) {
        return [self.mutableRecords writeToFile:self.pathSerializer atomically:YES];
    }
    else {
        [self.database open];
        [self.database executeUpdate:@"DELETE FROM records"];
        for (NSDictionary *record in self.mutableRecords) {
            NSString *tableQuery =
            [NSString stringWithFormat:@"INSERT INTO records(%@, %@) VALUES(?, ?)",kServiceName, kPassword];
            [self.database executeUpdate:tableQuery,record[kServiceName],record[kPassword]];
        }
        [self.database close];
        return YES;
    }
}

@end
