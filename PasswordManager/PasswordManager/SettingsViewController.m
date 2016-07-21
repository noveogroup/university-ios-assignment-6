//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Sergey Plotnikov on 19.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Preferences.h"

static NSString *const kStorageName = @"StorageName";
static NSString *const kPasswordStrength = @"PasswordStrength";

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) Preferences *preferences;
@property (weak, nonatomic) NSString *strengthName;
@property (weak, nonatomic) NSString *storageName;
@property (nonatomic) NSInteger selectedStorage;
@property (nonatomic) NSInteger selectedStrength;
@property (nonatomic) NSIndexPath *lastSelectedStorage;
@property (nonatomic) NSIndexPath *lastSelectedStrength;

@end

@implementation SettingsViewController

@synthesize delegate = delegate_;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];

    self.preferences = [Preferences standardPreferences];
    self.strengthName = [self.preferences passwordStrengthName];
    self.storageName = [self.preferences storageName];

    if (!!self.navigationItem) {
        UIBarButtonItem *const cancelBarButtonItem = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
         action:@selector(didTouchCancelBarButtonItem:)];
        
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
        
        UIBarButtonItem *const saveBarButtonItem = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
         action:@selector(didTouchSaveBarButtonItem:)];
        
        [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    switch ([self.preferences passwordStrength]) {
        case PasswordStrengthWeak:
            _selectedStrength = 0;
            break;
        case PasswordStrengthMedium:
            _selectedStrength = 1;
            break;
        case PasswordStrengthStrong:
            _selectedStrength = 2;
            break;
    }
    
    switch ([self.preferences storage]) {
        case StorageDocumentDirectory:
            _selectedStorage = 0;
            break;
        case StoragePList:
            _selectedStorage = 1;
            break;
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
        name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)setSelectedStorage:(NSInteger)selectedStorage
{
    _selectedStorage = selectedStorage;
}

- (void)setSelectedStrength:(NSInteger)selectedStrength
{
    _selectedStrength = selectedStrength;
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate settingsViewController:self];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    switch (self.selectedStorage) {
        case 0:
            [[Preferences standardPreferences] setStorage:StorageDefault];
            break;
        case 1:
            [[Preferences standardPreferences] setStorage:StoragePList];
            break;
    }
    
    switch (self.selectedStrength) {
        case 0:
            [[Preferences standardPreferences] setPasswordStrength:PasswordStrengthWeak];
            break;
        case 1:
            [[Preferences standardPreferences] setPasswordStrength:PasswordStrengthMedium];
            break;
        case 2:
            [[Preferences standardPreferences] setPasswordStrength:PasswordStrengthStrong];
            break;
    }
    [self.delegate settingsViewController:self];

}

#pragma mark - UITableViewDataSource implementation

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Password Strength";
    }
    else {
        return @"Storage";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[self.preferences passwordStrengths] count];
    }
    
    else {
        return [[self.preferences storages] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *passwordSettingsTableIdentifier = @"SettingsItem";
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:passwordSettingsTableIdentifier];
    
    if (indexPath.section == 1) {
        if (!tableViewCell) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:passwordSettingsTableIdentifier];
        }
        
        NSArray *storages = [self.preferences storages];
        tableViewCell.textLabel.text = [storages objectAtIndex:indexPath.row];
        
        if ([tableViewCell.textLabel.text isEqualToString:storages[self.selectedStorage]]) {
            self.lastSelectedStorage = indexPath;
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
        return tableViewCell;
    }
    
    else {
        if (!tableViewCell) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:passwordSettingsTableIdentifier];
        }
        NSArray *passwordStrengths = [self.preferences passwordStrengths];
        tableViewCell.textLabel.text = [passwordStrengths objectAtIndex:indexPath.row];

        if ([tableViewCell.textLabel.text isEqualToString:passwordStrengths[self.selectedStrength]]) {
            self.lastSelectedStrength = indexPath;
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
        return tableViewCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (indexPath.section == 0) {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastSelectedStrength];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastSelectedStrength = indexPath;
        self.selectedStrength = indexPath.row;
    } else {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastSelectedStorage];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastSelectedStorage = indexPath;
        self.selectedStorage = indexPath.row;
    }
}

@end
