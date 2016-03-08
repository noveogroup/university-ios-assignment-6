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

extern NSString *const kSettingsPasswordLength;
extern NSString *const kSettingsIncludeLowercaseCharacters;
extern NSString *const kSettingsIncludeUppercaseCharacters;
extern NSString *const kSettingsIncludeNumbers;
extern NSString *const kSettingsInludeSymbols;

@interface Preferences : UIViewController

/**
 *  Returns the strength rate of the passwords the applications generates.
 */
@property (nonatomic, readwrite) NSInteger passwordStrength;

/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
