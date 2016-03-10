#import "Preferences.h"
#import "PreferencesTableVC.h"


NSString *const kPasswordLength                         = @"kPasswordLength";
NSString *const kIncludeLowercaseCharacters             = @"kIncludeLowercaseCharacters";
NSString *const kIncludeUppercaseCharacters             = @"kIncludeUppercaseCharacters";
NSString *const kIncludeNumbers                         = @"kIncludeNumbers";
NSString *const kIncludeSymbols                         = @"kIncludeSymbols";

NSString *const kSettingsPasswordLength                 = @"kSettingsPasswordLength";
NSString *const kSettingsIncludeLowercaseCharacters     = @"kSettingsIncludeLowercaseCharacters";
NSString *const kSettingsIncludeUppercaseCharacters     = @"kSettingsIncludeUppercaseCharacters";
NSString *const kSettingsIncludeNumbers                 = @"kSettingsIncludeNumbers";
NSString *const kSettingsIncludeSymbols                 = @"kSettingsIncludeSymbols";

@interface Preferences ()
- (void)registerUserDefaultsFromSettingsBundle;
@end

@implementation Preferences

#pragma mark - Class methods

+ (instancetype)standardPreferences
{
    static dispatch_once_t onceToken = 0;
    static Preferences *standardPreferences_ = nil;
    dispatch_once(&onceToken, ^{
        standardPreferences_ = [[self alloc] init];
    });
    
    return standardPreferences_;
}

#pragma mark - Getters



- (NSInteger)passwordLength
{
    switch ([[[NSUserDefaults standardUserDefaults] valueForKey:kPasswordLength] integerValue]) {
        case 0:
            return PasswordLengthShort;
            break;
            
        case 1:
            return PasswordLengthSMedium;
            break;
            
        case 2:
            return PasswordLengthLong;
            break;
    }
    
    return PasswordLengthDefault;
}

- (BOOL)includeLowercaseChars
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kIncludeLowercaseCharacters] integerValue];
}

- (BOOL)includeUppercaseChars
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kIncludeUppercaseCharacters] integerValue];
}

- (BOOL)includeNumbers
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kIncludeNumbers] integerValue];
}

- (BOOL)includeSymbols
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kIncludeSymbols] integerValue];
}



#pragma mark - Initialization

- (id)init
{
    if ((self = [super init])) {
        
        
        [self registerUserDefaultsFromSettingsBundle];
    }
    
    return self;
}


#pragma mark - Registering settings bundle

- (void)registerUserDefaultsFromSettingsBundle
{
    NSString *const settingsBundlePath =
    [[NSBundle mainBundle] pathForResource:@"Settings"
                                    ofType:@"bundle"];
    
    NSMutableDictionary *const defaultsToRegister = [NSMutableDictionary dictionary];
    
    if (settingsBundlePath) {
        NSString *const rootPlistPath =
        [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
        NSDictionary *const preferences =
        [NSDictionary dictionaryWithContentsOfFile:rootPlistPath];
        
        NSArray *const preferenceSpecifiers =
        [preferences objectForKey:@"PreferenceSpecifiers"];
        
        for (NSDictionary *specifier in preferenceSpecifiers) {
            NSString *const key = [specifier objectForKey:@"Key"];
            if (key) {
                [defaultsToRegister setValue:[specifier objectForKey:@"DefaultValue"]
                                      forKey:key];
            }
        }
    }
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Methods

- (void)syncSettingsBundleAndSettingsApp
{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsPasswordLength] isEqual:
        [[NSUserDefaults standardUserDefaults] valueForKey:kPasswordLength]]) {
        
        id value = [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsPasswordLength];
        [[NSUserDefaults standardUserDefaults] setValue:value
                                                 forKey:kPasswordLength];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeLowercaseCharacters] isEqual:
          [[NSUserDefaults standardUserDefaults] valueForKey:kIncludeLowercaseCharacters]]) {
        
        id value = [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeLowercaseCharacters];
        [[NSUserDefaults standardUserDefaults] setValue:value
                                                 forKey:kIncludeLowercaseCharacters];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeUppercaseCharacters] isEqual:
          [[NSUserDefaults standardUserDefaults] valueForKey:kIncludeUppercaseCharacters]]) {
        
        id value = [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeUppercaseCharacters];
        [[NSUserDefaults standardUserDefaults] setValue:value
                                                 forKey:kIncludeUppercaseCharacters];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeNumbers] isEqual:
          [[NSUserDefaults standardUserDefaults] valueForKey:kIncludeNumbers]]) {
        
        id value = [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeNumbers];
        [[NSUserDefaults standardUserDefaults] setValue:value
                                                 forKey:kIncludeNumbers];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeSymbols] isEqual:
          [[NSUserDefaults standardUserDefaults] valueForKey:kIncludeSymbols]]) {
        
        id value = [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsIncludeSymbols];
        [[NSUserDefaults standardUserDefaults] setValue:value
                                                 forKey:kIncludeSymbols];
    }

}

@end
