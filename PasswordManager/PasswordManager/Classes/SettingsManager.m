//
//  SettingsManager.m
//  PasswordManager
//

#import "SettingsManager.h"

typedef NS_ENUM(NSInteger, PasswordStrength) {
    PasswordStrengthWeak    = 5,
    PasswordStrengthMedium  = 10,
    PasswordStrengthStrong  = 15
};

@implementation SettingsManager

- (instancetype)init
{
    if (self = [super init]) {
        _settings = [NSUserDefaults standardUserDefaults];
        [_settings setInteger:PasswordStrengthMedium forKey:@"passwordStrength"];
    }
    return self;
}

- (NSInteger)passwordStrength
{
    return [self.settings integerForKey:@"passwordStrength"];
}

@end
