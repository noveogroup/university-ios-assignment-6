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

@property (weak, nonatomic) IBOutlet UITableView *strengthTableView;
@property (weak, nonatomic) IBOutlet UITableView *storageTableView;
@property (nonatomic) Preferences *preferences;
@property (weak, nonatomic) NSString *strengthName;
@property (weak, nonatomic) NSString *storageName;
@property (nonatomic) NSInteger selectedStorage;
@property (nonatomic) NSInteger selectedStrength;

@end

@implementation SettingsViewController

@synthesize delegate = delegate_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferences = [Preferences standardPreferences];
    self.strengthName = [self.preferences passwordStrengthName];
    self.storageName = [self.preferences storageName];
    
    switch ([self.preferences passwordStrength]) {
        case PasswordStrengthWeak:
            _selectedStrength = 0;
            break;
        case PasswordStrengthMedium:
            _selectedStrength = 1;
            break;
        case PasswordStrengthStrong:
            _selectedStrength = 2;
        default:
            _selectedStrength = 0;
            break;
    }
    
    switch ([self.preferences storage]) {
        case StorageDocumentDirectory:
            _selectedStorage = 0;
            break;
        case StoragePList:
            _selectedStrength = 1;
        default:
            _selectedStorage = 0;
            break;
    }
  
    [self.strengthTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedStrength inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.storageTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedStorage inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    
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
        default:
            [[Preferences standardPreferences] setStorage:StorageDefault];
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
        default:
            break;
    }
    [self.delegate settingsViewController:self];

}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.storageTableView) {
        return [[self.preferences storages] count];
    }
    
    else {
        return [[self.preferences passwordStrengths] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *passwordSettingsTableIdentifier = @"SettingsItem";
    UITableViewCell *tableViewCell;
    
    if (tableView == self.storageTableView) {

        tableViewCell = [tableView dequeueReusableCellWithIdentifier:passwordSettingsTableIdentifier];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:passwordSettingsTableIdentifier];
    }
        tableViewCell.textLabel.text = [[self.preferences storages] objectAtIndex:indexPath.row];
        if ([tableViewCell.textLabel.text isEqualToString:self.storageName]) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
        }
        return tableViewCell;
    }
    
    else {
        
        tableViewCell = [tableView dequeueReusableCellWithIdentifier:passwordSettingsTableIdentifier];
        if (!tableViewCell) {
            tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:passwordSettingsTableIdentifier];
        }
        tableViewCell.textLabel.text = [[self.preferences passwordStrengths] objectAtIndex:indexPath.row];
        if ([tableViewCell.textLabel.text isEqualToString:self.strengthName]) {
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

        }
    
        return tableViewCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.storageTableView) {
        self.selectedStorage = indexPath.row;
    }
    
    else {
        self.selectedStrength = indexPath.row;
    }
}


@end
