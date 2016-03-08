//
//  Preferences.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "Preferences.h"

NSString *const kPasswordStrength            = @"PasswordStrength";
NSString *const kPasswordLength              = @"PasswordLength";
NSString *const kIncludeLowercaseCharacters  = @"LowercaseCharacters";
NSString *const kIncludeUppercaseCharacters  = @"UppercaseCharacters";
NSString *const kIncludeNumbers              = @"Numbers";
NSString *const kInludeSymbols               = @"Symbols";


@interface Preferences ()

@property (strong, nonatomic) IBOutlet UISwitch *switchLowChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchUpChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchNum;
@property (strong, nonatomic) IBOutlet UISwitch *switchSymb;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSArray <UISwitch *>* switches;


- (IBAction)actionCancel:(UIButton *)sender;
- (IBAction)actionSave:(UIButton *)sender;



- (void)registerUserDefaultsFromSettingsBundle;

@end



@implementation Preferences

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSettings];
    
    self.switches = @[self.switchLowChar, self.switchUpChar, self.switchNum, self.switchSymb];
    
    self.title = @"Settings";
    self.navigationItem.backBarButtonItem.title = @"Back";
    
    
}

#pragma mark - Save and Load settings

- (void)saveSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setInteger:self.segmentedControl.selectedSegmentIndex forKey:kPasswordLength];
    [userDefaults setBool:self.switchLowChar.isOn forKey:kIncludeLowercaseCharacters];
    [userDefaults setBool:self.switchUpChar.isOn forKey:kIncludeUppercaseCharacters];
    [userDefaults setBool:self.switchNum.isOn forKey:kIncludeNumbers];
    [userDefaults setBool:self.switchSymb.isOn forKey:kInludeSymbols];
    
    [userDefaults synchronize];
    
}

- (void)loadSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.segmentedControl.selectedSegmentIndex = [userDefaults integerForKey:kPasswordLength];
    self.switchLowChar.on = [userDefaults boolForKey:kIncludeLowercaseCharacters];
    self.switchUpChar.on = [userDefaults boolForKey:kIncludeUppercaseCharacters];
    self.switchNum.on = [userDefaults boolForKey:kIncludeNumbers];
    self.switchSymb.on = [userDefaults boolForKey:kInludeSymbols];
    
}


#pragma mark - Actions

- (IBAction)actionCancel:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionSave:(UIButton *)sender
{
    if ([self enabledSwitch]) {
        [self saveSettings];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"Warning!"
                                                message:@"At least one switch must be selected."
                                         preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction =
            [UIAlertAction actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleCancel
                                   handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
    
}

#pragma mark - Methods

- (BOOL)enabledSwitch
{
    
    __block NSInteger count = 0;
    
    [self.switches enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UISwitch *swtch = (UISwitch *)obj;
        
        count = swtch.isOn ? count + 1 : count;
        
    }];
    
    if (count == 0) {
        return NO;
    } else {
        return YES;
    }
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

- (NSInteger)passwordLength
{
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:kPasswordLength]) {
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
    return [[NSUserDefaults standardUserDefaults] integerForKey:kIncludeLowercaseCharacters];
}

- (BOOL)includeUppercaseChars
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kIncludeUppercaseCharacters];
}

- (BOOL)includeNumbers
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kIncludeNumbers];
}

- (BOOL)includeSymbols
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kInludeSymbols];
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
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
