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
    if (indexPath.section == 0)
    {
        [[Preferences standardPreferences]setPasswordStrengthFromIndex:indexPath.row];
        [tableView reloadData];
        
    }
    else
    {
        [[Preferences standardPreferences]setStorage:indexPath.row];
        [tableView reloadData];
    }
}


- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:self completion:nil];
}

@end
