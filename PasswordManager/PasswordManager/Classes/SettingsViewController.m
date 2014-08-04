//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 01/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Preferences.h"

static NSString *settingsID = @"ReusableSettingsCellID";

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int selectedStrengthIndex;
@property (nonatomic) int selectedModeIndex;
@property (nonatomic, strong) NSMutableArray * /*of PasswordStrength*/strengths;
@property (nonatomic, strong) NSMutableArray * /*of StorageMode*/modes;

typedef NS_ENUM(NSInteger, Sections)
{
    Strength = 0,
    Mode = 1
};

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.selectedStrengthIndex = NSNotFound;

        self.strengths = [[NSMutableArray alloc] initWithCapacity:3];

        [self.strengths addObject:@(PasswordStrengthWeak)];
        [self.strengths addObject:@(PasswordStrengthMedium)];
        [self.strengths addObject:@(PasswordStrengthStrong)];

        self.modes = [[NSMutableArray alloc] initWithCapacity:2];

        [self.modes addObject:@(StorageModeNSCoding)];
        [self.modes addObject:@(StorageModeNSUserDefaults)];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!!self.navigationItem) {
        self.navigationItem.title = @"Settings";

        UIBarButtonItem *const cancelBarButtonItem =
                [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                        target:self
                        action:@selector(dismiss)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case Strength:
            return [self.strengths count];
        case Mode:
            return [self.modes count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case Strength:
            return @"Password strength";
        case Mode:
            return @"Storage mode";
        default:
            return @"Other";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:settingsID];

    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:settingsID];
    }

    switch (indexPath.section) {
        case Strength: {
            tableViewCell.textLabel.text =
                    [self stringByStrength:[self.strengths[indexPath.row] intValue]];

            if ([self.strengths[indexPath.row] intValue] == [Preferences
                    standardPreferences].passwordStrength) {
                tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.selectedStrengthIndex = indexPath.row;
            }

            break;
        }
        case Mode: {
            tableViewCell.textLabel.text = [self stringByMode:[self.modes[indexPath.row] intValue]];

            if ([self.modes[indexPath.row] intValue] == [Preferences standardPreferences]
                    .storageMode) {
                tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.selectedModeIndex = indexPath.row;
            }
        }
        default:
            break;
    }

    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case Strength: {
            if (self.selectedStrengthIndex != NSNotFound) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath
                        indexPathForRow:self.selectedStrengthIndex inSection:indexPath.section]];

                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            self.selectedStrengthIndex = indexPath.row;

            [Preferences standardPreferences].passwordStrength = [(self.strengths)[indexPath.row]
                    intValue];

            break;
        }
        case Mode: {
            if (self.selectedModeIndex != NSNotFound) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath
                        indexPathForRow:self.selectedModeIndex inSection:indexPath.section]];

                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            self.selectedModeIndex = indexPath.row;

            [Preferences standardPreferences].storageMode = [(self.modes)[indexPath.row]
                    intValue];

            [self.delegate kickRecordsManager];

            break;
        }
        default:
            break;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)stringByStrength:(NSInteger)strength
{
    switch (strength)
    {
        case PasswordStrengthWeak:
            return @"Weak";
        case PasswordStrengthMedium:
            return @"Medium";
        case PasswordStrengthStrong:
            return @"Strong";
        default:
            return @"";
    }
}

- (NSString *)stringByMode:(NSInteger)mode
{
    switch (mode) {
        case StorageModeNSCoding:
            return @"NSCoding";
        case StorageModeNSUserDefaults:
            return @"UserDefaults";
        default:
            return @"";
    }
}

@end
