//
//  RecordsManager.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "RecordsManager.h"
#import "Preferences.h"
#import "Record.h"

NSString* getFilePathInLibrarySubdirectoryAndCopy(NSString *fileName, NSString *directory)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:directory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        [fileManager copyItemAtPath:bundle toPath:path error:NULL];
    }
    
    return path;
}

@interface RecordsManager ()

@property (nonatomic, strong) NSMutableArray *mutableRecords;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, weak) NSString *fileName;

@end

@implementation RecordsManager

@synthesize url = url_;
@synthesize mutableRecords = mutableRecords_;
@synthesize fileName = fileName_;

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

- (instancetype)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        fileName_ = fileName;
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
            NSString *path = getFilePathInLibrarySubdirectoryAndCopy(self.fileName, @"records");
            NSArray *root = [[NSArray alloc] initWithContentsOfFile:path];
            mutableRecords_ = [root mutableCopy];
            if (!mutableRecords_) {
                mutableRecords_ = [NSMutableArray array];
            }
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
        NSString *path = getFilePathInLibrarySubdirectoryAndCopy(self.fileName, @"records");
        return [self.mutableRecords writeToFile:path atomically:YES];
    }
}

@end
