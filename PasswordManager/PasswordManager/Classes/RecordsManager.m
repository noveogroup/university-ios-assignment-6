//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "Preferences.h"
#import "FMDBStorage.h"

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *urlToFile;
@property (nonatomic, strong) FMDBStorage *fmdbStorage;

@end

@implementation RecordsManager

@synthesize urlToFile = urlToFile_;
@synthesize mutableRecords = mutableRecords_;
@synthesize fmdbStorage = fmdbStorage_;

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
        
        urlToFile_ = [url URLByAppendingPathExtension:@"dat"];
        
        fmdbStorage_ = [[FMDBStorage alloc] initWithURL:[url URLByAppendingPathExtension:@"sqlite"]];
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
    if (!mutableRecords_) {
        
        switch ([Preferences standardPreferences].storageType) {
            case StorageTypeDatFile:
                
                mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.urlToFile];
                if (!mutableRecords_) {
                    mutableRecords_ = [NSMutableArray array];
                }
                break;
                
            case StorageTypeFMDBSQLite:
                
                mutableRecords_ = [self.fmdbStorage selectRecords];
                break;
        }
    }

    return mutableRecords_;
}

- (NSArray *)records
{
    return [self.mutableRecords copy];
}

- (void)removeRecord:(NSDictionary *)record
{
    [self.mutableRecords removeObject:record];
}

- (void)replaceRecord:(NSDictionary *)oldRecord withRecord:(NSDictionary *)newRecord
{
    [self.mutableRecords replaceObjectAtIndex:[self.mutableRecords indexOfObject:oldRecord] withObject:newRecord];
}

#pragma mark - Synchronisation

- (BOOL)synchronize
{
    switch ([Preferences standardPreferences].storageType) {
        case StorageTypeDatFile:
            return [self.mutableRecords writeToURL:self.urlToFile atomically:YES];
            
        case StorageTypeFMDBSQLite:
            ;BOOL succeed = [self.fmdbStorage deleteAllRecords];
            succeed = succeed && [self.fmdbStorage insertRecords:self.mutableRecords];
            return succeed;
    }
    
    return NO;
}

#pragma mark - Notification from Preferences if "storageType" was changed

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![change[@"old"] isEqual:change[@"new"]]) {

        [self synchronize];
    }
}

@end

















