//
//  FmdbHandler.h
//  PasswordManager
//
//  Created by Wadim on 8/6/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FmdbHandler : NSObject


- (instancetype)initWithContentsOfUrl:(NSURL *)url;
- (void) saveArrayToDb:(NSArray *)records;
- (NSArray *)loadArrayFromDb;

@end
