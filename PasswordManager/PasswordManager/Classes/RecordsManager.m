//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "Preferences.h"
#import "Database.h"

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, weak) Preferences *preferences;

@property (nonatomic, strong) Database *db;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize mutableRecords = mutableRecords_;
@synthesize preferences = preferences_;
@synthesize db = db_;

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
        url_ = url;
        preferences_ = [Preferences standardPreferences];
        db_ = [[Database alloc] init];
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

- (void)deleteRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords removeObject:record];
    }
}

- (NSMutableArray *)mutableRecords
{
    switch (self.preferences.storageType) {
        case StorageTypeCoding: {
            if (!mutableRecords_) {
                mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
                if (!mutableRecords_) {
                    mutableRecords_ = [NSMutableArray array];
                }
            }
            break;
        }
        
        case StorageTypeDatabase: {
            if (!mutableRecords_) {
                mutableRecords_ = [self.db loadRecords];
                if (!mutableRecords_) {
                    mutableRecords_ = [NSMutableArray array];
                }
            }
            break;
        }

        default:
            break;
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
    switch (self.preferences.storageType) {
        case StorageTypeCoding: {
            return [self.mutableRecords writeToURL:self.url atomically:YES];
            break;
        }
        
        case StorageTypeDatabase: {
            [self.db saveRecords:self.mutableRecords];
            
            return YES;
            break;
        }

        default:
            break;
    }
    
    return NO;
}

- (void)storageTypeChanged {
    self.mutableRecords = nil;
}

@end
