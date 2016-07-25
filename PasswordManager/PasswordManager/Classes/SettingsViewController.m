//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 14.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Preferences.h"


NSString *kPasswordStrengthSection = @"PasswordStrengthSection";
NSString *kPasswordStorageSection = @"PasswordStorageSection";
NSString *kPasswordStrengthSectionTitle = @"Password strength";
NSString *kPasswordStorageSectionTile = @"Password storage";
NSString *kPasswordStorageSQLite = @"SQLite";
NSString *kPasswordStorageOld = @"Old";
NSString *kPasswordStrengthWeak = @"Weak";
NSString *kPasswordStrengthMedium = @"Medium";
NSString *kPasswordStrengthStrong = @"Strong";

NSString *kName = @"name";
NSString *kCheck = @"check";
NSString *kTitle = @"title";

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic) NSIndexPath *checkedIndexPathPasswordStrengthSection;
@property (nonatomic) NSIndexPath *checkedIndexPathPasswordStorageSection;

@property (nonatomic, strong) NSArray *dataPasswordStorage;
@property (nonatomic, strong) NSArray *dataPasswordStrength;
@end

@implementation SettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!!self.navigationItem) {        
        UIBarButtonItem *const doneBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
         target:self
         action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
    }
    
    self.dataPasswordStorage = @[kPasswordStorageSQLite, kPasswordStorageOld];
    self.dataPasswordStrength = @[kPasswordStrengthWeak, kPasswordStrengthMedium,kPasswordStrengthStrong];
    
    switch ([[Preferences standardPreferences] passwordStrength]) {
        case PasswordStrengthWeak:
            self.checkedIndexPathPasswordStrengthSection = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
        case PasswordStrengthMedium:
            self.checkedIndexPathPasswordStrengthSection = [NSIndexPath indexPathForRow:1 inSection:0];
            break;
        case PasswordStrengthStrong:
            self.checkedIndexPathPasswordStrengthSection = [NSIndexPath indexPathForRow:2 inSection:0];
            break;
        default:
            break;
    }
    
    switch ([[Preferences standardPreferences] passwordStorage]) {
        case PasswordStorageSQLite:
            self.checkedIndexPathPasswordStorageSection = [NSIndexPath indexPathForRow:0 inSection:1];
            break;
        case PasswordStorageOld:
            self.checkedIndexPathPasswordStorageSection = [NSIndexPath indexPathForRow:1 inSection:1];
            break;
            
        default:
            break;
    }
}

- (void)updatePasswordStrength:(NSInteger)passwordStrength
{
    [Preferences standardPreferences].passwordStrength = passwordStrength;
}

- (void)updatePasswordStorage:(NSInteger)passwordStorage
{
    [Preferences standardPreferences].passwordStorage = passwordStorage;
}

- (IBAction)didTouchDoneBarButtonItem:(id)sender
{
    switch (self.checkedIndexPathPasswordStrengthSection.row) {
        case 0:
            [self updatePasswordStrength:PasswordStrengthWeak];
            break;
        case 1:
            [self updatePasswordStrength:PasswordStrengthMedium];
            break;
        case 2:
            [self updatePasswordStrength:PasswordStrengthStrong];
            break;
            
        default:
            break;
    }
    
    switch (self.checkedIndexPathPasswordStorageSection.row) {
        case 0:
            [self updatePasswordStorage:PasswordStorageSQLite];
            break;
        case 1:
            [self updatePasswordStorage:PasswordStorageOld];
            break;
            
        default:
            break;
    }
    [self.delegate settingsViewControllerDidFinish:self];
}

#pragma mark - UITableViewDataSource implementation


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return self.dataPasswordStrength.count;
    } else {
        return self.dataPasswordStorage.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        return kPasswordStrengthSectionTitle;
    } else {
        return kPasswordStorageSectionTile;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    if (indexPath.section == 0){
        tableViewCell.textLabel.text = self.dataPasswordStrength[indexPath.row];
        tableViewCell.accessoryType = (indexPath.row == self.checkedIndexPathPasswordStrengthSection.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else {
        tableViewCell.textLabel.text = self.dataPasswordStorage[indexPath.row];
        tableViewCell.accessoryType = (indexPath.row == self.checkedIndexPathPasswordStorageSection.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}

#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *oldIndexPath;
    if (indexPath.section == 0) {
        if (indexPath.row == self.checkedIndexPathPasswordStrengthSection.row) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        oldIndexPath = self.checkedIndexPathPasswordStrengthSection;
        self.checkedIndexPathPasswordStrengthSection = indexPath;
    } else {
        if (indexPath.row == self.checkedIndexPathPasswordStorageSection.row) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        oldIndexPath = self.checkedIndexPathPasswordStorageSection;
        self.checkedIndexPathPasswordStorageSection = indexPath;
    }

    [tableView reloadRowsAtIndexPaths:@[oldIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
