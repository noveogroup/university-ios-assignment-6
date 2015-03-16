//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Александр on 14.03.15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Preferences.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *passwords;
@property (nonatomic) NSArray *storages;
@property (nonatomic) NSInteger checkedPassword;
@property (nonatomic) NSInteger checkedStorage;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!!self.navigationItem) {
        UIBarButtonItem *const cancelBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
         target:self
         action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    }
    self.passwords = @[@"Weak", @"Medium", @"Strong"];
    self.storages = @[@"Files", @"Data base"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.passwords count];
    }
    else
    {
        return [self.storages count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    if (indexPath.section == 0)
    {
        tableViewCell.textLabel.text = self.passwords[indexPath.row];
        if ([[Preferences standardPreferences] indexOfPasswordStrength] == indexPath.row)
        {
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    else
    {
        tableViewCell.textLabel.text = self.storages[indexPath.row];
        if ([[Preferences standardPreferences] storage] == indexPath.row)
        {
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return tableViewCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Password Strength";
    }
    else
    {
        return @"Storage";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        [self uncheckRowsInSection:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if (indexPath.section == 0)
        {
            [[Preferences standardPreferences]setPasswordStrengthFromIndex:indexPath.row];
            self.checkedPassword = indexPath.row;
            
        }
        else
        {
            [[Preferences standardPreferences]setStorage:indexPath.row];
            self.checkedStorage = indexPath.row;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate didCloseSettingsMenu:self];
}

- (void)applicationDidBecomeActive
{
    if (self.checkedPassword != [[Preferences standardPreferences]indexOfPasswordStrength] || self.checkedStorage != [[Preferences standardPreferences]storage])
    {
        [self.tableView reloadData];
    }
}

- (void)uncheckRowsInSection:(NSInteger)section
{
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:section]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
