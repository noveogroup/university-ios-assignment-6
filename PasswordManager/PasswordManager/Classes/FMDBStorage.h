//
//  FMDBStorage.h
//  PasswordManager
//
//  Created by Menzarar on 25.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBStorage : NSObject

/**
 *  Performs no initialization; please use @c -initWithURL: instead.
 */
- (id)init;

/**
 *  Initializes a newly created instance with the specifed URL.
 */
- (instancetype)initWithURL:(NSURL *)url;

- (BOOL)deleteRecords:(NSArray *)records;

- (BOOL)addRecords:(NSArray *)records;

- (BOOL)deleteAllRecords;

/**
 *  Returns the records
 */
- (NSMutableArray *)records;

@end
