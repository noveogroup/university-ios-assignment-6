//
//  SettingsTableViewController.m
//  PasswordManager
//
//  Created by Иван Букшев on 3/17/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

#import "SettingsTableViewController.h"

#define titleCryptoSettings @"Crypto Settings"
#define titlePasswordStrength @"Password Strength"
#define titleStorageMethod @"Storage Method"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize mutableBlocks;

- (NSArray *)currentBlocks:(NSInteger)index
{
    NSArray *keys = [mutableBlocks allKeys];
    NSString *currentKey = [keys objectAtIndex:index];
    
    return [mutableBlocks objectForKey:currentKey];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    if (!!self.navigationItem)
    {
        UIBarButtonItem *const cancelBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self
                                                      action:@selector(didTouchCancelBarButtonItem)];
        
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    }
    
    CGRect frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
    self.cryptoLabel = [[UILabel alloc] initWithFrame:frame];
    self.cryptoSlider = [[UISlider alloc] initWithFrame:frame];
    self.passwordLabel = [[UILabel alloc] initWithFrame:frame];
    self.passwordSlider = [[UISlider alloc] initWithFrame:frame];
    
    [self constructDictionaryOfSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didTouchCancelBarButtonItem
{
    Preferences *preferences = [Preferences standardPreferences];
    
    [preferences setCryptoVariable:[[self.cryptoLabel text] integerValue]];
    [preferences setPasswordStrength:[[self.passwordLabel text] integerValue]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Populating the data source dictionary

- (void)constructDictionaryOfSettings
{
    self.mutableBlocks = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *mutableCryptoSettings = [[NSMutableArray alloc] initWithObjects:@"Crypto Key:", @"Set Value:", nil];
    NSMutableArray *mutablePasswordStrength = [[NSMutableArray alloc] initWithObjects:@"Pass Strength:", @"Set Value:", nil];
    NSMutableArray *mutableStorageMethod = [[NSMutableArray alloc] initWithObjects:@"FMDB", @"UserDefaults", nil];
    
    [self.mutableBlocks setObject:mutableCryptoSettings forKey:titleCryptoSettings];
    [self.mutableBlocks setObject:mutableStorageMethod forKey:titleStorageMethod];
    [self.mutableBlocks setObject:mutablePasswordStrength forKey:titlePasswordStrength];
    
    [self.cryptoSlider setMinimumValue:1.0f];
    [self.cryptoSlider setMaximumValue:100.0f];
    [self.cryptoSlider setValue:[[Preferences standardPreferences] cryptoVariable]];
    [self.passwordSlider setMinimumValue:1.0f];
    [self.passwordSlider setMaximumValue:10.0f];
    [self.passwordSlider setValue:[[Preferences standardPreferences] passwordStrength]];
    
    [self.cryptoLabel setText:[NSString stringWithFormat:@"%.0f", [self.cryptoSlider value]]];
    [self.passwordLabel setText:[NSString stringWithFormat:@"%.0f", [self.passwordSlider value]]];
    
    [self.cryptoSlider addTarget:self
                          action:@selector(sliderValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.passwordSlider addTarget:self
                          action:@selector(sliderValueChanged:)
                forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mutableBlocks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self currentBlocks:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"Bukshev";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:myCellIdentifier];
    }
    
    NSArray *currentBlocks = [self currentBlocks:indexPath.section];
    cell.textLabel.text = [currentBlocks objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.accessoryView = self.passwordLabel;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        cell.accessoryView = self.passwordSlider;
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        cell.accessoryView = self.cryptoLabel;
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        cell.accessoryView = self.cryptoSlider;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    result = [[self.mutableBlocks allKeys] objectAtIndex:section];
    
    return result;
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    if ([sender isEqual:self.cryptoSlider])
    {
        [self.cryptoLabel setText:[NSString stringWithFormat:@"%.0f", [sender value]]];
    }
    else if ([sender isEqual:self.passwordSlider])
    {
        [self.passwordLabel setText:[NSString stringWithFormat:@"%.0f", [sender value]]];
    }
}

@end
