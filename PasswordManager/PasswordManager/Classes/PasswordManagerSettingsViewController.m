#import "PasswordManagerSettingsViewController.h"
#import "Preferences.h"

static NSString *const kPasswordStrength = @"PasswordStrength";
static NSString *const kPasswordStorageMethod = @"PasswordStorageMethod";
const  NSInteger NumberOfSections = 2;
const  NSInteger RowsNumInStrengthSection = 3;
const  NSInteger RowsNumInStorageSection = 2;

@interface PasswordManagerSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) Preferences *preferences;
@property (strong, nonatomic) NSDictionary *mappingStrength;
@property (strong, nonatomic) NSDictionary *mappingStorageMethod;
@property (strong, nonatomic) NSArray *strenghtContent;
@property (strong, nonatomic) NSArray *storageContent;


@end

@implementation PasswordManagerSettingsViewController

@synthesize preferences = preferences_;
@synthesize mappingStrength = mappingStrength_;
@synthesize mappingStorageMethod = mappingStorageMethod_;
@synthesize strenghtContent = strenghtContent_;
@synthesize storageContent = storageContent_;


#pragma mark - Inits

-(id) init
{
    self = [super init];
    
    if (self)
    {
        preferences_ = [Preferences standardPreferences];
        
        // Init arrays by sectiont content
        strenghtContent_ = @[@"Weak", @"Medium", @"Strong"];
        storageContent_  = @[@"DataBase", @"MuttableArray"];
        
        // Init mapping dictinary
        mappingStrength_ = @{
                             @(PasswordStrengthWeak)   : @0,
                             @(PasswordStrengthMedium) : @1,
                             @(PasswordStrengthStrong) : @2
                             };
        mappingStorageMethod_ = @{
                                  @(PasswordStorageMethodDataBase) : @0,
                                  @(PasswordStorageMethodMuttableArray) : @1
                                  };
        
        
    }
    
    return self;
}

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
}

#pragma mark - Customize Sections

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NumberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return RowsNumInStrengthSection;
    else
        return RowsNumInStorageSection;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return kPasswordStrength;
    else
        return kPasswordStorageMethod;
}

#pragma mark - Customize TableView

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    NSInteger currentPasswordStrength = [preferences_ passwordStrength];
    NSInteger currentPasswordStorageMethod = [preferences_ passwordStorageMethod];
    
    if (indexPath.section == 0){
        // PasswordStrengthSection
        tableViewCell.textLabel.text = strenghtContent_[indexPath.row];
        
        NSInteger passwordStrengthIndex = [[mappingStrength_ objectForKey:[NSNumber numberWithInteger:currentPasswordStrength]] integerValue];
        if (passwordStrengthIndex == indexPath.row)
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    else if (indexPath.section == 1){
        // PasswordStorageMethod
        tableViewCell.textLabel.text = storageContent_[indexPath.row];
        
        NSInteger passwordStorageIndex = [[mappingStorageMethod_ objectForKey:[NSNumber numberWithInteger:currentPasswordStorageMethod]] integerValue];
        if (passwordStorageIndex == indexPath.row)
            tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSInteger newPasswordStrength = [[mappingStrength_ allKeysForObject:[NSNumber numberWithInteger:indexPath.row]][0] integerValue];
        [preferences_ setPasswordStrength:newPasswordStrength];
    }
    else if (indexPath.section == 1)
    {
        NSInteger newPasswordStrength = [[mappingStorageMethod_ allKeysForObject:[NSNumber numberWithInteger:indexPath.row]][0] integerValue];
        [preferences_ setPasswordStorageMethod:newPasswordStrength];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView reloadData];
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate newSettingsViewController:self];
}

@end
