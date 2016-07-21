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
    PasswordStrengthStrong  = 15
};

typedef NS_ENUM(NSInteger, StorageType) {
    StorageTypeWithSerializer = 0,
    StorageTypeWithDB = 1
};

@interface Preferences : NSObject

/**
 *  Returns the strength rate of the passwords the applications generates.
 */
@property (nonatomic, readwrite) NSInteger passwordStrength;
@property (nonatomic, readwrite) NSInteger storageType;
@property (nonatomic, readwrite) NSInteger lastStorage;
/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
