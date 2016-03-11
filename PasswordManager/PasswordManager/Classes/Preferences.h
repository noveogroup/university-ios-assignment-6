#import <Foundation/Foundation.h>

extern NSString *const kPasswordLength;
extern NSString *const kIncludeLowercaseCharacters;
extern NSString *const kIncludeUppercaseCharacters;
extern NSString *const kIncludeNumbers;
extern NSString *const kIncludeSymbols;
extern NSString *const kSaveMode;

extern NSString *const kSettingsPasswordLength;
extern NSString *const kSettingsIncludeLowercaseCharacters;
extern NSString *const kSettingsIncludeUppercaseCharacters;
extern NSString *const kSettingsIncludeNumbers;
extern NSString *const kSettingsIncludeSymbols;
extern NSString *const kSettingsSaveMode;

typedef NS_ENUM(NSInteger, PasswordLength) {
    PasswordLengthShort    = 5,
    PasswordLengthSMedium  = 10,
    PasswordLengthDefault = PasswordLengthShort,
    PasswordLengthLong  = 15
};

typedef enum : NSUInteger {
    SaveInFile      = 0,
    SaveInDatabase,
} SaveMode;




@interface Preferences : NSObject
/**
 *  Returns the length of the passwords the applications generates.
 */
@property (nonatomic, readwrite) NSInteger passwordLength;
@property (nonatomic) SaveMode saveMode;
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
