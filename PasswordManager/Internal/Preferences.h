
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PasswordLength) {
    PasswordLengthWeak    = 5,
    PasswordLengthMedium  = 10,
    PasswordLengthDefault = PasswordLengthMedium,
    PasswordLengthStrong  = 20
};

typedef NS_ENUM(NSInteger, DBType) {
    DBTypePlist    = 5,
    DBTypeSQLite  = 10,
};

typedef NS_OPTIONS(NSUInteger, IncludeSymbols) {
    IncludeUppercaseSymbols                 = 1 <<  0,
    IncludeLowercaseSymbols                 = 1 <<  1,
    IncludeDecimalDigit                     = 1 <<  2,
    IncludeAnotherSymbolsAndPunctuations    = 1 <<  3,
    IncludeDefaultSymbols                   = IncludeUppercaseSymbols | IncludeDecimalDigit
};


@interface Preferences : NSObject

/**
 *  Returns the strength rate of the passwords the applications generates.
 */
@property (nonatomic, readwrite) NSInteger passwordLength;
@property (nonatomic, readwrite) NSInteger passwordSymbolsType;
@property (nonatomic, readwrite) NSInteger DBType;


/**
 *  Returns the shared preferences object.
 */
+ (instancetype)standardPreferences;

@end
