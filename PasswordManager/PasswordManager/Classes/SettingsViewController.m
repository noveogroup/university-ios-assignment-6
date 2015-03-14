#import "SettingsViewController.h"
#import "Preferences.h"


static NSString *const kSectionTitle = @"SectionTitle";
static NSString *const kSectionItems = @"SectionItems";
static NSDictionary *localizedPasswordStrengthOptions = nil;
static NSDictionary *localizedStorageMethodOptions = nil;
static NSString *const passwordStrengthSectionTitle = @"Password Strength";
static NSString *const storageMethodSectionTitle = @"Storage Method";
typedef NS_ENUM(NSInteger, StorageMethod) {
    File,
    Database
};


@interface SettingsViewController ()

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *checkedOptions;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation SettingsViewController

+ (void)initialize {
    localizedPasswordStrengthOptions = @{
                                         @(PasswordStrengthWeak): @"Weak",
                                         @(PasswordStrengthMedium): @"Medium",
                                         @(PasswordStrengthStrong): @"Strong"
                                         };
    localizedStorageMethodOptions = @{
                                      @(File): @"UserDefaults",
                                      @(Database): @"Database"
                                      };
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        // Define password strength section
        NSDictionary *sectionPasswordStrength =
            @{kSectionTitle: passwordStrengthSectionTitle,
              kSectionItems: @[
                      localizedPasswordStrengthOptions[@(PasswordStrengthWeak)],
                      localizedPasswordStrengthOptions[@(PasswordStrengthMedium)],
                      localizedPasswordStrengthOptions[@(PasswordStrengthStrong)],
            ]};
        
        // Define storage method section
        NSDictionary *sectionStorageMethod =
            @{kSectionTitle: storageMethodSectionTitle,
              kSectionItems: @[
                      localizedStorageMethodOptions[@(File)],
                      localizedStorageMethodOptions[@(Database)]
            ]};
        
        // Define sections list
        self.sections = @[sectionPasswordStrength, sectionStorageMethod];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize 'Done' button
    if (!!self.navigationItem) {
        UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                              target:self
                                              action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
    }
    
    // Define checked options
    PasswordStrength passwordStrength = [[Preferences standardPreferences] passwordStrength];
    self.checkedOptions = @[localizedPasswordStrengthOptions[@(passwordStrength)]];
    // TODO: Add storage method persisted in preferences
}

- (void)didTouchDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *sectionDict = self.sections[section];
    return ((NSArray *)sectionDict[kSectionItems]).count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionDict = self.sections[section];
    return sectionDict[kSectionTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReuseID"
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    NSDictionary *section = self.sections[indexPath.section];
    NSString *option = (section[kSectionItems])[indexPath.row];
    tableViewCell.textLabel.text = option;
    
    // Mark as checked options which are persisted in preferences
    if ([self.checkedOptions containsObject:option]) {
        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];

    /* If selected option is not checked yet then uncheck all options of the section and check
       the selected option */
    if (selectedCell.accessoryType != UITableViewCellAccessoryCheckmark) {
        NSInteger sectionIndex = indexPath.section;
        [self uncheckOptionsOfSection: sectionIndex];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSString *sectionTitle = (self.sections[sectionIndex])[kSectionTitle];
        
        // Handle choosing of password strength
        if ([sectionTitle isEqual:passwordStrengthSectionTitle]) {
            NSDictionary *section = self.sections[sectionIndex];
            NSString *option = (section[kSectionItems])[indexPath.row];
            PasswordStrength passwordStrength = [((NSNumber *)[localizedPasswordStrengthOptions
                                                 allKeysForObject:option][0]) integerValue];
            [[Preferences standardPreferences] setPasswordStrength:passwordStrength];
        }
        
        // Handle chooseing of storage method
        else if ([sectionTitle isEqual:storageMethodSectionTitle]) {
            // TODO: Handle changing of storage method
        }
    }
}

- (void)uncheckOptionsOfSection:(NSInteger)sectionIndex {
    NSInteger optionsCount = ((NSArray *)(self.sections[sectionIndex])[kSectionItems]).count;
    for (NSInteger i = 0; i < optionsCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
        UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
