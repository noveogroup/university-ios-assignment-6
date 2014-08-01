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

@property (nonatomic) int selectedIndex;
@property (nonatomic, strong) NSMutableArray * /*of PasswordStrength*/strengths;

typedef NS_ENUM(NSInteger, Sections)
{
    Strength = 0
};

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.selectedIndex = NSNotFound;

        self.strengths = [[NSMutableArray alloc] initWithCapacity:3];

        [self.strengths addObject:@(PasswordStrengthWeak)];
        [self.strengths addObject:@(PasswordStrengthMedium)];
        [self.strengths addObject:@(PasswordStrengthStrong)];

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
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case Strength:
            return @"Password strength";
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
        case Strength:
            tableViewCell.textLabel.text = [self stringByEnum:[[self.strengths
                                objectAtIndex:indexPath.row] intValue]];

            if ([[self.strengths objectAtIndex:indexPath.row] intValue] == [Preferences
                    standardPreferences].passwordStrength)
            {
                tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.selectedIndex = indexPath.row;
            }

            break;
        default:
            break;
    }

    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectedIndex != NSNotFound)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath
                indexPathForRow:self.selectedIndex inSection:indexPath.section]];

        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    self.selectedIndex = indexPath.row;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    [[Preferences standardPreferences] setPasswordStrength:[[self.strengths
            objectAtIndex:indexPath.row] intValue]];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)stringByEnum:(NSInteger)strength
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

@end
