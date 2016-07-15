//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Vladislav Librecht on 15.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Preferences.h"

static NSString *const kPasswordStorageSectionTitle = @"Password Storage";
static NSString *const kPasswordStrengthSectionTitle = @"Password Strength";

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray <NSString *> *passwordStorageType;
@property (strong, nonatomic) NSArray <NSString *> *passwordStrength;
@property (nonatomic) NSInteger selectedStorageType;
@property (nonatomic) NSInteger selectedPasswordStrength;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.passwordStorageType = @[@"NSMutableArray + writeToFile", @"FMDB"];
    self.selectedStorageType = 0;
    self.passwordStrength = @[@"Weak", @"Medium", @"Strong"];
    switch ([[Preferences standardPreferences] passwordStrength]) {
        case PasswordStrengthWeak:
            self.selectedPasswordStrength = 0;
            break;
            
        case PasswordStrengthMedium:
            self.selectedPasswordStrength = 1;
            break;
            
        case PasswordStrengthStrong:
            self.selectedPasswordStrength = 2;
            break;
    }
    
    if (!!self.navigationItem) {
        
        UIBarButtonItem *const doneBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
         target:self
         action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
    }
}

#pragma mark - Actions

- (void)didTouchDoneBarButtonItem:(UIBarButtonItem *)sender
{
    switch (self.selectedPasswordStrength) {
        case 0:
            [Preferences standardPreferences].passwordStrength = PasswordStrengthWeak;
            break;
            
        case 1:
            [Preferences standardPreferences].passwordStrength = PasswordStrengthMedium;
            break;
            
        case 2:
            [Preferences standardPreferences].passwordStrength = PasswordStrengthStrong;
            break;
    }
    
    [self.delegate settingsViewControllerDidFinish:self];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.passwordStorageType.count;
    }
    else {
        return self.passwordStrength.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"SettingsReusableCellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    if (indexPath.section == 0) {
        tableViewCell.textLabel.text = self.passwordStorageType[indexPath.row];
        if (indexPath.row == self.selectedStorageType) {
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        tableViewCell.textLabel.text = self.passwordStrength[indexPath.row];
        if (indexPath.row == self.selectedPasswordStrength) {
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kPasswordStorageSectionTitle;
    }
    else {
        return kPasswordStrengthSectionTitle;
    }
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.selectedStorageType = indexPath.row;
    }
    else {
        self.selectedPasswordStrength = indexPath.row;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

@end
