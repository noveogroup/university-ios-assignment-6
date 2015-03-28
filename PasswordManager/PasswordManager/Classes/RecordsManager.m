//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"

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
    [self.mutableRecords removeObject:record];
}

- (void)modifyRecord:(NSDictionary *)recordToBeModified byRecord:(NSDictionary *)newRecord
{
    NSInteger recordIndex = [self.mutableRecords indexOfObject:recordToBeModified];
    self.mutableRecords[recordIndex] = newRecord;
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_) {
        mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
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

- (void)setRecords:(NSArray *)records
{
    self.mutableRecords = [records mutableCopy];
}

#pragma mark - Synchronisation

- (BOOL)synchronize
{
    return [self.mutableRecords writeToURL:self.url atomically:YES];
}

@end
