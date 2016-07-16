//
//  Preferences.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PasswordStrength) {
    PasswordStrengthWeak    = 5,
    PasswordStrengthMedium  = 10,
    PasswordStrengthDefault = PasswordStrengthMedium,
    PasswordStrengthStrong  = 15
};

typedef NS_ENUM(NSInteger, StorageType) {
    StorageTypeDatFile,
    StorageTypeFMDBSQLite,
    StorageTypeDefault = StorageTypeFMDBSQLite
};

@interface Preferences : NSObject

/**
 *  Returns the strength rate of the passwords the applications generates.
 */
@property (nonatomic, readwrite) NSInteger passwordStrength;

/**
 *  Storage type the application use
 */
@property (nonatomic, readwrite) NSInteger storageType;

/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
