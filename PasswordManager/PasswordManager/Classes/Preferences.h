//
//  Preferences.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>



extern NSString *const kPasswordLength;
extern NSString *const kIncludeLowercaseCharacters;
extern NSString *const kIncludeUppercaseCharacters;
extern NSString *const kIncludeNumbers;
extern NSString *const kInludeSymbols;

typedef NS_ENUM(NSInteger, PasswordLength) {
    PasswordLengthShort    = 5,
    PasswordLengthSMedium  = 10,
    PasswordLengthDefault = PasswordLengthShort,
    PasswordLengthLong  = 15
};



@interface Preferences : UITableViewController


/**
 *  Returns the length of the passwords the applications generates.
 */
@property (nonatomic, readwrite) NSInteger passwordLength;

@property (nonatomic) BOOL includeLowercaseChars;
@property (nonatomic) BOOL includeUppercaseChars;
@property (nonatomic) BOOL includeNumbers;
@property (nonatomic) BOOL includeSymbols;

/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
