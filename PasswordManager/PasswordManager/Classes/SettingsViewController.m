//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 05/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Preferences.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSDictionary *sectionsContent;

@property (nonatomic, strong) NSMutableArray *selectedRowsInSections;
@property (nonatomic, strong) NSMutableArray *previousIndexPaths;

@property (nonatomic, weak) Preferences *preferences;

@property (nonatomic, strong) NSDictionary *passwordStrength;
@property (nonatomic, strong) NSDictionary *storageType;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sections = @[
            @"Strength",
            @"Storage"
        ];
        
        _sectionsContent = @{
            _sections[0]: @[
                @"Padawan",
                @"Jedi",
                @"Jedi Master"
            ],
            _sections[1]: @[
                @"Coding",
                @"SQLite"
            ]
        };
        
        _selectedRowsInSections = [[NSMutableArray alloc] initWithArray:@[
            [NSNumber numberWithInt:0],
            [NSNumber numberWithInt:0]
        ]];
        
        _previousIndexPaths = [[NSMutableArray alloc] initWithArray:@[
            [NSIndexPath indexPathForRow:0 inSection:0],
            [NSIndexPath indexPathForRow:0 inSection:1]
        ]];
        
        _preferences = [Preferences standardPreferences];
        
        _passwordStrength = @{
            [NSNumber numberWithInteger:PasswordStrengthWeak]: [NSNumber numberWithInteger:0],
            [NSNumber numberWithInteger:PasswordStrengthMedium]: [NSNumber numberWithInteger:1],
            [NSNumber numberWithInteger:PasswordStrengthStrong]: [NSNumber numberWithInteger:2]
        };
        
        _storageType = @{
            [NSNumber numberWithInteger:StorageTypeCoding]: [NSNumber numberWithInteger:0],
            [NSNumber numberWithInteger:StorageTypeDatabase]: [NSNumber numberWithInteger:1]
        };
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!!self.navigationItem) {
        UIBarButtonItem *const backBarButtonItem =
            [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    }
    
    NSLog(@"reload settings view: \npassword: %d, \nstorage: %d",
        self.preferences.passwordStrength,
        self.preferences.storageType
    );
}

#pragma mark - TableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionKey = [self.sections objectAtIndex:section];
    NSArray *sectionContent = [self.sectionsContent valueForKey:sectionKey];

    return [sectionContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
    NSArray *sectionContents = [self.sectionsContent objectForKey:sectionTitle];
    NSString *menuTitle = [sectionContents objectAtIndex:indexPath.row];
    
    switch (indexPath.section) {
        // password strength
        case 0: {
            NSInteger currentStrengthValue = self.preferences.passwordStrength;
            NSNumber *currentStrength = [NSNumber numberWithInteger:currentStrengthValue];
            
            NSInteger currentStrengthIndex = [self.passwordStrength[currentStrength] integerValue];
            
            if (indexPath.row == currentStrengthIndex) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            break;
        }
        
        // storage type
        case 1: {
            NSInteger currentStorageTypeValue = self.preferences.storageType;
            NSNumber *currentStorageType = [NSNumber numberWithInteger:currentStorageTypeValue];
            
            if (indexPath.row == [self.storageType[currentStorageType] integerValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            
            break;
        }

        default:
            break;
    }

    cell.textLabel.text = menuTitle;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}

#pragma mark - TableViewDeletgate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *index = [NSNumber numberWithInt:indexPath.row];

    switch (indexPath.section) {
        // password strength
        case 0: {
            NSNumber *strength = [self.passwordStrength allKeysForObject:index][0];
            [self.preferences setPasswordStrength:[strength intValue]];
            
            break;
        }
        
        // storage type
        case 1: {
            NSNumber *type = [self.storageType allKeysForObject:index][0];
            [self.preferences setStorageType:[type intValue]];
            
            break;
        }

        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView beginUpdates];
    [tableView reloadData];
    [tableView endUpdates];
}

#pragma mark - Actions

- (void)didTouchDoneBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate settingsViewControllerDone:self];
}

@end
