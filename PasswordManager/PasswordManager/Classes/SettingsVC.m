//
//  SettingsVC.m
//  PasswordManager
//
//  Created by Vik on 07.03.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "SettingsVC.h"




@interface SettingsVC ()
@property (strong, nonatomic) IBOutlet UISwitch *switchLowChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchUpChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchNum;
@property (strong, nonatomic) IBOutlet UISwitch *switchSymb;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)actionCancel:(UIButton *)sender;
- (IBAction)actionSave:(UIButton *)sender;

@end

static NSString *kSettingsPasswordLength              = @"PasswordLength";
static NSString *kSettingsIncludeLowercaseCharacters  = @"LowercaseCharacters";
static NSString *kSettingsIncludeUppercaseCharacters  = @"UppercaseCharacters";
static NSString *kSettingsIncludeNumbers              = @"Numbers";
static NSString *kSettingsInludeSymbols               = @"Symbols";

@implementation SettingsVC

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

@end
