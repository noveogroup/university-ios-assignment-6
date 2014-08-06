//
//  DataBaseManager.h
//  PasswordManager
//
//  Created by Admin on 06/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseManager : NSObject

-(instancetype)initWithURL:(NSURL*)url;

-(NSArray*)records;

-(BOOL)synchronizeWith:(NSArray*)records;

@end
