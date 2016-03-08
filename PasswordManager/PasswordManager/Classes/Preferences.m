//
//  Preferences.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "Preferences.h"

static NSString *const kPasswordStrength = @"PasswordStrength";

@interface Preferences ()

@property (strong, nonatomic) IBOutlet UISwitch *switchLowChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchUpChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchNum;
@property (strong, nonatomic) IBOutlet UISwitch *switchSymb;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)actionCancel:(UIButton *)sender;
- (IBAction)actionSave:(UIButton *)sender;


- (void)registerUserDefaultsFromSettingsBundle;

@end

NSString *const kSettingsPasswordLength              = @"PasswordLength";
NSString *const kSettingsIncludeLowercaseCharacters  = @"LowercaseCharacters";
NSString *const kSettingsIncludeUppercaseCharacters  = @"UppercaseCharacters";
NSString *const kSettingsIncludeNumbers              = @"Numbers";
NSString *const kSettingsInludeSymbols               = @"Symbols";

@implementation Preferences

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSettings];
    self.title = @"Settings";
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    
}

#pragma mark - Save and Load settings

- (void)saveSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:self.segmentedControl.selectedSegmentIndex forKey:kSettingsPasswordLength];
    [userDefaults setBool:self.switchLowChar.isOn forKey:kSettingsIncludeLowercaseCharacters];
    [userDefaults setBool:self.switchUpChar.isOn forKey:kSettingsIncludeUppercaseCharacters];
    [userDefaults setBool:self.switchNum.isOn forKey:kSettingsIncludeNumbers];
    [userDefaults setBool:self.switchSymb.isOn forKey:kSettingsInludeSymbols];
    
    [userDefaults synchronize];
    
}

- (void)loadSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.segmentedControl.selectedSegmentIndex = [userDefaults integerForKey:kSettingsPasswordLength];
    self.switchLowChar.on = [userDefaults boolForKey:kSettingsIncludeLowercaseCharacters];
    self.switchUpChar.on = [userDefaults boolForKey:kSettingsIncludeUppercaseCharacters];
    self.switchNum.on = [userDefaults boolForKey:kSettingsIncludeNumbers];
    self.switchSymb.on = [userDefaults boolForKey:kSettingsInludeSymbols];
    
}


#pragma mark - Actions

- (IBAction)actionCancel:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionSave:(UIButton *)sender
{
    [self saveSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

#pragma mark - Setters

- (void)setPasswordStrength:(NSInteger)passwordStrength
{
    [[NSUserDefaults standardUserDefaults] setInteger:passwordStrength
                                               forKey:kPasswordStrength];
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

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
