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
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
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

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [self.mutableRecords removeObject:[self.records objectAtIndex:index]];
}

- (NSMutableArray *)mutableRecords
{
    if (!mutableRecords_) {
        if ([[Preferences standardPreferences] storage] == StorageDocumentDirectory) {
            mutableRecords_ = [NSMutableArray arrayWithContentsOfURL:self.url];
            if (!mutableRecords_) {
                mutableRecords_ = [NSMutableArray array];
            }
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Passwords" ofType:@"plist"];
            
            NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
            mutableRecords_ = (NSMutableArray *)[dictionary objectForKey:@"Password"];
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
    if ([[Preferences standardPreferences] storage] == StorageDocumentDirectory) {
        return [self.mutableRecords writeToURL:self.url atomically:YES];

    } else {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Passwords" ofType:@"plist"];
        NSDictionary *passwords = [NSDictionary dictionaryWithObject:mutableRecords_ forKey:@"Password"];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:passwords format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
        if(plistData) {
            return [plistData writeToFile:path atomically:YES];
            NSLog(@"Data saved sucessfully");
        } else {
            NSLog(@"Data was not saved");
            return NO;
        }
    }
}

@end
