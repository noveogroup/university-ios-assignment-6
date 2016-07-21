//
//  RecordsManager.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordsManager : NSObject

- (id)init;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithFileName:(NSString *)fileName;
- (void)registerRecord:(NSDictionary *)record;
- (NSArray *)records;
- (BOOL)synchronize;
- (void)removeObjectAtIndex:(NSUInteger)index;

@end
