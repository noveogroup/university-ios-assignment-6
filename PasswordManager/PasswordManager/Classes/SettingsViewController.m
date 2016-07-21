//
//  SettingsViewController.m
//  PasswordManager
//

#import "SettingsViewController.h"
#import "Preferences.h"

NSString *const passwordLabelWeak = @"Weak";
NSString *const passwordLabelMedium = @"Medium";
NSString *const passwordLabelStrong = @"Strong";
NSString *const storageTypeLabelSerializer = @"By serializer";
NSString *const storageTypeLabelDB = @"By Data Base";

NSString *stringFromPasswordStrength(PasswordStrength strenght) {
    switch (strenght) {
        case PasswordStrengthWeak:
            return passwordLabelWeak;
            break;
        case PasswordStrengthMedium:
            return passwordLabelMedium;
            break;
        case PasswordStrengthStrong:
            return passwordLabelStrong;
            break;
    }
}

NSString *stringFromStorageType(StorageType type) {
    switch (type) {
        case StorageTypeWithSerializer:
            return storageTypeLabelSerializer;
            break;
        case StorageTypeWithDB:
            return storageTypeLabelDB;
            break;
    }
}

NSInteger passwordStrengthFromString(NSString *string) {
    if ([string isEqualToString:passwordLabelWeak]) {
        return PasswordStrengthWeak;
    }
    if ([string isEqualToString:passwordLabelMedium]) {
        return PasswordStrengthMedium;
    }
    if ([string isEqualToString:passwordLabelStrong]) {
        return PasswordStrengthStrong;
    }
    return 0;
}

NSInteger storageTypeFromString(NSString *string) {
    if ([string isEqualToString:storageTypeLabelSerializer]) {
        return StorageTypeWithSerializer;
    }
    if ([string isEqualToString:storageTypeLabelDB]) {
        return StorageTypeWithDB;
    }
    return 0;
}

NSInteger const kDefaultSectionNumber = 2;


@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSIndexPath *previousPasswordCellIndexPath;
@property (nonatomic) NSIndexPath *previousStorageCellIndexPath;

- (void)doneButtonTouched:(UIBarButtonItem *)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!!self.navigationItem) {
        UIBarButtonItem *const doneBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self
                                                      action:@selector(doneButtonTouched:)];
        [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
    }
}

#pragma mark - Actions

- (void)doneButtonTouched:(UIBarButtonItem *)sender
{
    [self.delegate didTouchDoneButton:self];
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if ((![indexPath isEqual:self.previousPasswordCellIndexPath]) && (![indexPath isEqual:self.previousStorageCellIndexPath])) {
        if (indexPath.section == 0) {
            UITableViewCell *previousCell =
                [self.tableView cellForRowAtIndexPath:self.previousPasswordCellIndexPath];
            previousCell.accessoryType = UITableViewCellAccessoryNone;
            self.previousPasswordCellIndexPath = indexPath;
            [Preferences standardPreferences].passwordStrength = passwordStrengthFromString(cell.textLabel.text);
        }
        else {
            UITableViewCell *previousCell =
            [self.tableView cellForRowAtIndexPath:self.previousStorageCellIndexPath];
            previousCell.accessoryType = UITableViewCellAccessoryNone;
            self.previousStorageCellIndexPath = indexPath;
            [Preferences standardPreferences].storageType = storageTypeFromString(cell.textLabel.text);
            [Preferences standardPreferences].lastStorage = storageTypeFromString(cell.textLabel.text);
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kDefaultSectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else {
        return 2;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Password";
    }
    else {
        return @"Storage";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *labels = @[@[passwordLabelWeak, passwordLabelMedium, passwordLabelStrong],
                        @[storageTypeLabelSerializer, storageTypeLabelDB]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    cell.textLabel.text = labels[indexPath.section][indexPath.row];
    if ([cell.textLabel.text isEqual:stringFromPasswordStrength([Preferences standardPreferences].passwordStrength)]) {
        self.previousPasswordCellIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if ([cell.textLabel.text isEqual:stringFromStorageType([Preferences standardPreferences].storageType)]) {
        self.previousStorageCellIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

@end
