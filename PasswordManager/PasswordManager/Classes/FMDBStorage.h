//
//  FMBDStorage.h
//  PasswordManager
//
//  Created by Vladislav Librecht on 16.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBStorage : NSObject

- (instancetype)initWithURL:(NSURL *)url;

- (NSMutableArray *)selectRecords;

- (BOOL)insertRecords:(NSArray *)records;

- (BOOL)deleteRecords:(NSArray *)records;

- (BOOL)deleteAllRecords;

@end
