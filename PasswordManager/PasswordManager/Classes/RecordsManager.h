//
//  RecordsManager.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordsManager : NSObject

- (void)registerRecord:(NSDictionary *)record;
- (void)deleteRecordAtIndexPath:(NSIndexPath *)indexPath;
- (void)replaceRecordAtIndexPath:(NSIndexPath *)indexPath byRecord:(NSDictionary *)record;

- (NSArray *)records;

- (BOOL)synchronize;

@end
