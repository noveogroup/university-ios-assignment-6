//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"

static NSString *const kPasswordStorage = @"PasswordStorage";
static NSString *const DefaultPLISTFileName = @"AwesomeFileName";
static NSString *const DefaultEncodedFileName = @"WonderfulFileName";

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSString *path;

@end

@implementation RecordsManager

@synthesize path = path_;
@synthesize passwordStorage = passwordStorage_;
@synthesize mutableRecords = mutableRecords_;

#pragma mark - Initialization

- (instancetype)init
{
    if ((self = [super init])) {
        passwordStorage_ = 1;
        path_ = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        switch (passwordStorage_) {
            case PasswordStoragePLIST:
            {
                path_ = [path_ stringByAppendingPathComponent:DefaultPLISTFileName];
            }
                break;
            case PasswordStorageEncodedFile:
            {
                path_ = [path_ stringByAppendingPathComponent:DefaultEncodedFileName];
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

#pragma mark - Management of records

- (void)registerRecord:(NSDictionary *)record
{
    if ([record count] > 0) {
        [self.mutableRecords addObject:record];
    }
}

-(void)replaceRecord:(NSDictionary*)oldRecord
                with:(NSDictionary*)newRecord
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
    NSLog(@"%@",self.path);
    if (!mutableRecords_) {
        switch (self.passwordStorage) {
            case PasswordStoragePLIST:
                {
                    NSURL* url = [NSURL fileURLWithPath:self.path];
                    mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:url];
                }
                break;
            case PasswordStorageEncodedFile:
                {
                    mutableRecords_ = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];
                }
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
    switch (self.passwordStorage) {
        case PasswordStoragePLIST:
        {
            NSURL* url = [NSURL fileURLWithPath:self.path];
            return [self.mutableRecords writeToURL:url atomically:YES];
        }
            break;
        case PasswordStorageEncodedFile:
        {
            return [NSKeyedArchiver archiveRootObject:self.mutableRecords toFile:self.path];
        }
            break;
            
        default:
            break;
    }
    return NO;
}

@end
