//
//  RecordsManager.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PasswordStorage) {
    PasswordStoragePLIST,
    PasswordStorageEncodedFile,
    PasswordStorageDataBase
};

@interface RecordsManager : NSObject

@property (nonatomic) NSInteger passwordStorage;

/**
 *  Performs no initialization; please use @c -initWithURL: instead.
 */
- (id)init;

/**
 *  Initializes a newly created instance with the specifed URL.
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 *  Registers the specified record.
 */
- (void)registerRecord:(NSDictionary *)record;

-(void)replaceRecord:(NSDictionary*)oldRecord
                withRecord:(NSDictionary*)newRecord;

-(void)deleteRecord:(NSDictionary*)record;

/**
 *  Returns the records the receiver manages.
 */
- (NSArray *)records;

/**
 *  Writes any modifications to the persistent domains to disk.
 *
 *  @return @c YES if the records were saved successfully to disk.
 */
- (BOOL)synchronize;

@end
