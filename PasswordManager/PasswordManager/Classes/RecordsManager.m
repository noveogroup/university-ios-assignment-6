//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "FMDBHandler.h"
#import "Preferences.h"

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) FMDBHandler *dbHeandler;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize mutableRecords = mutableRecords_;
@synthesize dbHeandler = dbHeandler_;

#pragma mark - Initialization

- (id)init
{
    NSLog(@"Please use -initWithURL: instead.");
    
    [self doesNotRecognizeSelector:_cmd];

    
    return nil;
}

-(instancetype) initWithURL:(NSURL *)url passwordStorageMode:(PasswordStorageMethod *)mode
{
    if ((self = [super init])) {
        url_ = url;
        
        if (mode == PasswordStorageMethodDataBase)
            dbHeandler_ = [[FMDBHandler alloc] initDBWithUrl:url_];
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
        
        switch ([[Preferences standardPreferences] passwordStorageMethod]){
                
            case PasswordStorageMethodDataBase:
                mutableRecords_ = [dbHeandler_ loadPasswordArray];
                break;
                
            case PasswordStorageMethodMuttableArray:
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

-(void) deleteRecord:(NSDictionary *)record
{
    if ([record count] > 0)
    {
        [self.mutableRecords removeObject:record];
    }
}

#pragma mark - Synchronisation

- (BOOL)synchronize
{
    switch ([[Preferences standardPreferences] passwordStorageMethod]){
            
        case PasswordStorageMethodDataBase:
            [dbHeandler_ savePasswordArray:[self records]];
            return YES;
            break;
            
        case PasswordStorageMethodMuttableArray:
            [self.mutableRecords writeToURL:self.url atomically:YES];
            return YES;
            break;
    }
    
    return NO;
}

@end
