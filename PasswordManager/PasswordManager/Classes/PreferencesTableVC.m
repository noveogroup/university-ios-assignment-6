#import "PreferencesTableVC.h"
#import "Preferences.h"


@interface PreferencesTableVC () <UITabBarControllerDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UISwitch *switchLowChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchUpChar;
@property (strong, nonatomic) IBOutlet UISwitch *switchNum;
@property (strong, nonatomic) IBOutlet UISwitch *switchSymb;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray <UISwitch *>* switches;

- (IBAction)actionCancel:(UIButton *)sender;
- (IBAction)actionSave:(UIButton *)sender;

- (void)saveSettings;
- (void)loadSettings;

@end



@implementation PreferencesTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadSettings];
    
    self.switches = @[self.switchLowChar, self.switchUpChar, self.switchNum, self.switchSymb];
    
    self.title = @"Settings";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

#pragma mark - Save and Load settings

- (void)saveSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:@(self.segmentedControl.selectedSegmentIndex) forKey:kPasswordLength];
    [userDefaults setValue:@(self.switchLowChar.isOn) forKey:kIncludeLowercaseCharacters];
    [userDefaults setValue:@(self.switchUpChar.isOn) forKey:kIncludeUppercaseCharacters];
    [userDefaults setValue:@(self.switchNum.isOn) forKey:kIncludeNumbers];
    [userDefaults setValue:@(self.switchSymb.isOn) forKey:kIncludeSymbols];
    
    [userDefaults setValue:@(self.segmentedControl.selectedSegmentIndex) forKey:kSettingsPasswordLength];
    [userDefaults setValue:@(self.switchLowChar.isOn) forKey:kSettingsIncludeLowercaseCharacters];
    [userDefaults setValue:@(self.switchUpChar.isOn) forKey:kSettingsIncludeUppercaseCharacters];
    [userDefaults setValue:@(self.switchNum.isOn) forKey:kSettingsIncludeNumbers];
    [userDefaults setValue:@(self.switchSymb.isOn) forKey:kSettingsIncludeSymbols];

    [userDefaults synchronize];
    
}

- (void)loadSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.segmentedControl.selectedSegmentIndex = [[userDefaults valueForKey:kPasswordLength] integerValue];
    self.switchLowChar.on = [[userDefaults valueForKey:kIncludeLowercaseCharacters] boolValue];
    self.switchUpChar.on = [[userDefaults valueForKey:kIncludeUppercaseCharacters] boolValue];
    self.switchNum.on = [[userDefaults valueForKey:kIncludeNumbers] boolValue];
    self.switchSymb.on = [[userDefaults valueForKey:kIncludeSymbols] boolValue];
    
}

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



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView
        didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
