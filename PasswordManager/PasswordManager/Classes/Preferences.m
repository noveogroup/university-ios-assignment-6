//
//  Preferences.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "Preferences.h"

static NSString *const kPasswordStrength = @"PasswordStrength";
static NSString *const kKeepingMode = @"KeepingMode";

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

- (NSInteger)passwordStrength
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kPasswordStrength];
}

- (NSInteger)keepingMode
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kKeepingMode];
}

#pragma mark - Setters

- (void)setPasswordStrength:(NSInteger)passwordStrength
{
    [[NSUserDefaults standardUserDefaults] setInteger:passwordStrength
                                               forKey:kPasswordStrength];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setKeepingMode:(NSInteger)keepingMode
{
    [[NSUserDefaults standardUserDefaults] setInteger:keepingMode
                                               forKey:kKeepingMode];
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
    [defaultsToRegister setObject:@(PasswordStrengthDefault)
                           forKey:kPasswordStrength];
    
    [defaultsToRegister setObject:@(KeepingModeDefault)
                           forKey:kKeepingMode];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
