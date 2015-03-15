//
//  Preferences.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kSettingsStorageMethod = @"SettingsStorageMethod";

typedef NS_ENUM(NSInteger, PasswordStrength) {
    PasswordStrengthWeak    = 5,
    PasswordStrengthMedium  = 10,
    PasswordStrengthDefault = PasswordStrengthMedium,
    PasswordStrengthStrong  = 15
};

typedef NS_ENUM(NSInteger, StorageMethod) {
    StorageMethodFile,
    StorageMethodDatabase,
    StorageMethodDefault = StorageMethodFile
};

@interface Preferences : NSObject

/**
 *  Returns the strength rate of the passwords the applications generates.
 */
@property (nonatomic, readwrite) PasswordStrength passwordStrength;

/**
 *  Returns the storage method of persisting passwords.
 */
@property (nonatomic, readwrite) StorageMethod storageMethod;

/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
