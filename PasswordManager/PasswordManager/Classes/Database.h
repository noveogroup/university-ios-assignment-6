//
//  Database.h
//  PasswordManager
//
//  Created by Admin on 05/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

- (void)saveRecords:(NSArray *)records;
- (NSMutableArray *)loadRecords;

@end
