#import <Foundation/Foundation.h>

extern NSString *const kPasswordLength;
extern NSString *const kIncludeLowercaseCharacters;
extern NSString *const kIncludeUppercaseCharacters;
extern NSString *const kIncludeNumbers;
extern NSString *const kIncludeSymbols;

extern NSString *const kSettingsPasswordLength;
extern NSString *const kSettingsIncludeLowercaseCharacters;
extern NSString *const kSettingsIncludeUppercaseCharacters;
extern NSString *const kSettingsIncludeNumbers;
extern NSString *const kSettingsIncludeSymbols;

typedef NS_ENUM(NSInteger, PasswordLength) {
    PasswordLengthShort    = 5,
    PasswordLengthSMedium  = 10,
    PasswordLengthDefault = PasswordLengthShort,
    PasswordLengthLong  = 15
};



@interface Preferences : NSObject
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

- (void)syncSettingsBundleAndSettingsApp;

@end
