//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"

static NSString *identifier = @"RecordDictionary";

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

- (void)removeRecordAtIndex:(NSInteger)index
{
    [self.mutableRecords removeObjectAtIndex:index];
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_) {
        switch ([Preferences standardPreferences].storageMode) {
            case StorageModeNSCoding:
                mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
                break;

            case StorageModeNSUserDefaults:
                mutableRecords_ = [[[NSUserDefaults standardUserDefaults]
                        arrayForKey:identifier] mutableCopy];


                break;
            default:
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
    BOOL result;

    switch ([Preferences standardPreferences].storageMode) {
        case StorageModeNSCoding: {
            result = [self.mutableRecords writeToURL:self.url atomically:YES];

            if (result) {
                self.mutableRecords = nil;
            }

            break;
        }
        case StorageModeNSUserDefaults:
            [[NSUserDefaults standardUserDefaults] setObject:self.mutableRecords forKey:identifier];
            self.mutableRecords = nil;
            result = YES;
            break;
        default:
            result = NO;
    }

    return result;
}

@end
