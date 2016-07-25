//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "FMDBStorage.h"
#import "Preferences.h"

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) FMDBStorage *fmdbStorage;

@end

@implementation RecordsManager

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
        _url = url;
        _fmdbStorage = [[FMDBStorage alloc] initWithURL:[url URLByDeletingPathExtension]];
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

- (void)replaceRecord:(NSDictionary *)record withRecord:(NSDictionary *)newRecord
{
    [self.mutableRecords replaceObjectAtIndex:[self.mutableRecords indexOfObject:record] withObject:newRecord];
}

- (NSMutableArray *)mutableRecords
{
    if (!_mutableRecords) {
        switch ([Preferences standardPreferences].passwordStorage) {
            case PasswordStorageOld:
                _mutableRecords = [NSMutableArray arrayWithContentsOfURL:self.url];
                if (!_mutableRecords) {
                    _mutableRecords = [NSMutableArray array];
                }
                break;
                
            case PasswordStorageSQLite:
                _mutableRecords = [self.fmdbStorage records];
                break;
            default:
                break;
        }
        
    }

    return _mutableRecords;
}

- (NSArray *)records
{
    return [self.mutableRecords copy];
}

- (void)deleteRecord:(NSDictionary *)record
{
    [self.mutableRecords removeObject:record];
}

#pragma mark - Synchronisation

- (BOOL)synchronize
{
    switch ([Preferences standardPreferences].passwordStorage) {
        case PasswordStorageOld:
            return [self.mutableRecords writeToURL:self.url atomically:YES];
            break;
            
        case PasswordStorageSQLite:
            [self.fmdbStorage deleteAllRecords];
            if ([self.fmdbStorage addRecords:[self.mutableRecords copy]]) {
                return YES;
            }
            
            break;
        default:
            break;
    }
    
    return NO;
}

@end
