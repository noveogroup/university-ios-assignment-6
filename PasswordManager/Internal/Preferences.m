
#import "Preferences.h"

static NSString *const kPasswordLength = @"PasswordLength";
static NSString *const kPasswordSymbolsType = @"PasswordSymbolsType";

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
    return [[NSUserDefaults standardUserDefaults] integerForKey:kPasswordLength];
}

- (NSInteger)passwordSymbolsType
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kPasswordSymbolsType];
}

#pragma mark - Setters

- (void)setPasswordLength:(NSInteger)passwordLength
{
    [[NSUserDefaults standardUserDefaults] setInteger:passwordLength
                                               forKey:kPasswordLength];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPasswordSymbolsType:(NSInteger)passwordSymbolsType
{
    [[NSUserDefaults standardUserDefaults] setInteger:passwordSymbolsType
                                               forKey:kPasswordSymbolsType];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    [defaultsToRegister setObject:@(PasswordLengthDefault)
                           forKey:kPasswordLength];
    
    [defaultsToRegister setObject:@(IncludeDefaultSymbols)
                           forKey:kPasswordSymbolsType];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
