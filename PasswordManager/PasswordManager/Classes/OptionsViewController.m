//
//  OptionsViewController.m
//  PasswordManager
//
//  Created by Wadim on 8/4/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "OptionsViewController.h"
#import "Preferences.h"

static NSString *const kKeepingModeString = @"Keeping Mode";
static NSString *const kPasswordStrengthString = @"Password Strength";

static NSString *const kKeepingModePlistStringValue = @"Plist";
static NSString *const kKeepingModeEncodedStringValue = @"Encoded";
static NSString *const kKeepingModeFmdbStringValue = @"FMDB";

@interface OptionsViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    UIApplicationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *mutableOptions;
@property (strong, nonatomic) NSMutableDictionary *mutableKeepingModes;
@property (strong, nonatomic) NSArray *stringModes;

@property (weak,nonatomic) id<OptionsViewControllerDelegate> delegate;

@end

@implementation OptionsViewController

#pragma mark - Inits

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.mutableOptions = [@{kPasswordStrengthString:
            @([[Preferences standardPreferences]passwordStrength])} mutableCopy];
        self.mutableKeepingModes = [@{kKeepingModeString:
            @([[Preferences standardPreferences]keepingMode])} mutableCopy];
        self.stringModes = @[kKeepingModePlistStringValue,
            kKeepingModeEncodedStringValue, kKeepingModeFmdbStringValue];
    }
    return self;
}

- (id)initWithDelegate:(id<OptionsViewControllerDelegate>) delegate
{
    self.delegate = delegate;
    return [self init];
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!!self.navigationItem) {
        UIBarButtonItem *const doneBarButtonItem =
            [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:doneBarButtonItem];
    }

}

#pragma mark - Actions

- (void)didTouchDoneBarButtonItem:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
    [self.delegate didCloseOptionsMenu:self];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.mutableOptions count];
    }
    else return [self.mutableKeepingModes count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Password Strength Options";
    }
    else return @"Password Keeping Options";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"

    UITableViewCell *tableViewCell =
        [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    if (indexPath.section == 0) {
        NSString *const key =
            [[self.mutableOptions allKeys]objectAtIndex:indexPath.row];
        tableViewCell.textLabel.text = key;
        tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.mutableOptions[key]];
    }
    else if (indexPath.section == 1)  {
            NSString *const key =
            [[self.mutableKeepingModes allKeys]objectAtIndex:indexPath.row];
        tableViewCell.textLabel.text = key;
        NSString *const modeStringValue =
            self.stringModes [[self.mutableKeepingModes[key]intValue]];
        tableViewCell.detailTextLabel.text = modeStringValue;
    }
    return tableViewCell;

#undef REUSABLE_CELL_ID
}

- (BOOL) tableView:tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // Process Password Strength
        switch ([[Preferences standardPreferences]passwordStrength]) {
            case PasswordStrengthStrong:
                [[Preferences standardPreferences]setPasswordStrength:PasswordStrengthWeak];
                break;
            
            case PasswordStrengthMedium:
                [[Preferences standardPreferences]setPasswordStrength:PasswordStrengthStrong];
                break;

            case PasswordStrengthWeak:
            default:
                [[Preferences standardPreferences]setPasswordStrength:PasswordStrengthMedium];
                break;
        }
        self.mutableOptions = [@{kPasswordStrengthString:
                    @([[Preferences standardPreferences]passwordStrength])} mutableCopy];
    }
    else if (indexPath.section == 1) {
        // Process Keeping Options
        switch ([[Preferences standardPreferences]keepingMode]) {
            case KeepingModeFmdb:
                [[Preferences standardPreferences]setKeepingMode:KeepingModePlist];
                break;
                
            case KeepingModeEncoded:
                [[Preferences standardPreferences]setKeepingMode:KeepingModeFmdb];
            break;
                
            case KeepingModePlist:
            default:
                [[Preferences standardPreferences]setKeepingMode:KeepingModeEncoded];
                break;
        }
        self.mutableKeepingModes = [@{kKeepingModeString:
                    @([[Preferences standardPreferences]keepingMode])} mutableCopy];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}



@end
