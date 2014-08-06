//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "DataBaseManager.h"

static NSString *const kPasswordStorage = @"PasswordStorage";
static NSString *const DefaultPLISTFileName = @"AwesomeFileName";
static NSString *const DefaultEncodedFileName = @"WonderfulFileName";
static NSString *const DefaultDataBaseFileName = @"Records.db";

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) DataBaseManager* dbManager;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize passwordStorage = passwordStorage_;
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
        passwordStorage_ = 2;
        url_ = url;
        switch (passwordStorage_) {
            case PasswordStoragePLIST:
            {
                url_ = [url_ URLByAppendingPathComponent:DefaultPLISTFileName];
            }
                break;
            case PasswordStorageEncodedFile:
            {
                url_ = [url_ URLByAppendingPathComponent:DefaultEncodedFileName];
            }
                break;
            case PasswordStorageDataBase:
            {
                url_ = [url_ URLByAppendingPathComponent:DefaultDataBaseFileName];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

#pragma mark - Setter

- (void)setPasswordStorage:(NSInteger)passwordStorage
{
    self.passwordStorage = passwordStorage;
    [[NSUserDefaults standardUserDefaults] setInteger:passwordStorage
                                               forKey:kPasswordStorage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(DataBaseManager*)dbManager
{
    if(!_dbManager){
        _dbManager = [[DataBaseManager alloc]initWithURL:self.url];
    }
    return _dbManager;
}

#pragma mark - Management of records

- (void)registerRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords addObject:record];
    }
}

-(void)replaceRecord:(NSDictionary*)oldRecord
                withRecord:(NSDictionary*)newRecord
{
    if([self.mutableRecords containsObject:oldRecord]){
        NSInteger index = [self.mutableRecords indexOfObject:oldRecord];
        [self.mutableRecords removeObject:oldRecord];
        [self.mutableRecords insertObject:newRecord atIndex:index];
    }
}

-(void)deleteRecord:(NSDictionary *)record
{
    [self.mutableRecords removeObject:record];
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_) {
        switch (self.passwordStorage) {
            case PasswordStoragePLIST:
                {
                    mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
                }
                break;
            case PasswordStorageEncodedFile:
                {
                    mutableRecords_ = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.url path]];
                }
                break;
            case PasswordStorageDataBase:
            {
                mutableRecords_ = [[self.dbManager records] mutableCopy];
            }
                
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
    switch (self.passwordStorage) {
        case PasswordStoragePLIST:
        {
            return [self.mutableRecords writeToURL:self.url atomically:YES];
        }
            break;
        case PasswordStorageEncodedFile:
        {
            return [NSKeyedArchiver archiveRootObject:self.mutableRecords toFile:[self.url path]];
        }
            break;
        case PasswordStorageDataBase:
        {
            return [self.dbManager synchronizeWith:self.mutableRecords];
        }
            
        default:
            break;
    }
    return NO;
}

@end
