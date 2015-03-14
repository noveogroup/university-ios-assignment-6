//
//  RecordsManager.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordsManager : NSObject

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

/**
 *  Deletes the specified record.
 */
- (void)deleteRecord:(NSDictionary *)record;

/**
 *  Modifies the specified record by the new record.
 */
- (void)modifyRecord:(NSDictionary *)recordToBeModified byRecord:(NSDictionary *)newRecord;

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
