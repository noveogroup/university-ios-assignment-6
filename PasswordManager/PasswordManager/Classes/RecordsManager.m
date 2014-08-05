//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "Preferences.h"

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize mutableRecords = mutableRecords_;

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
    if (!mutableRecords_) {
        switch ([[Preferences standardPreferences]keepingMode]) {
            case KeepingModeEncoded:
                mutableRecords_ = [NSKeyedUnarchiver unarchiveObjectWithFile:
                    [self.url path]];
            break;

            case KeepingModePlist:
            default:
                mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
            break;
    }
    if (!mutableRecords_) {
        mutableRecords_ = [NSMutableArray array];
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
    switch ([[Preferences standardPreferences]keepingMode]) {
        case KeepingModeEncoded:
            return [NSKeyedArchiver archiveRootObject:mutableRecords_ toFile:[self.url path]];
            break;
            
        case KeepingModePlist:
        default:
            return [self.records writeToURL:self.url atomically:YES];
            break;
        }
}


@end
