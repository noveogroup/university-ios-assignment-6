#import "PasswordManagerSettingsViewController.h"
#import "Preferences.h"

static NSString *const kPasswordStrength = @"PasswordStrength";
static NSString *const kPasswordStorageMethod = @"PasswordStorageMethod";

@interface PasswordManagerSettingsViewController () <UITableViewDataSource,
UITableViewDelegate>
- (void) saveSettings;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *mutableOptions;
@property (nonatomic, strong) NSMutableDictionary *mutablePasswordStorageMode;

@end

@implementation PasswordManagerSettingsViewController

@synthesize mutableOptions = mutableOptions_;
@synthesize mutablePasswordStorageMode = mutablePasswordStorageMode_;

-(id) init
{
    self = [super init];
    
    if (self)
    {
        mutableOptions_ = [@{kPasswordStrength: @([[Preferences standardPreferences]passwordStrength])} mutableCopy];
        mutablePasswordStorageMode_ = [@{kPasswordStorageMethod: @([[Preferences standardPreferences]passwordStorageMethod])} mutableCopy];
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
        
        UIBarButtonItem *const saveBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
         target:self
         action:@selector(didTouchSaveBarButtonItem:)];
        [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
    }
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate newSettingsViewController:self];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    [self saveSettings];
}

#pragma mark - Auxiliaries

- (void) saveSettings
{
    [[Preferences standardPreferences] setPasswordStrength:20];
    [self.delegate newSettingsViewController:self];
}

#pragma mark - Customize TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [mutableOptions_ count];
    else
        return [mutablePasswordStorageMode_ count];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @("Password strength options");
    else
        return @("Password storage mode");
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    
    
    
    if (indexPath.section == 0)
    {
        NSString *const key = [[mutableOptions_ allKeys] objectAtIndex:indexPath.row];
        tableViewCell.textLabel.text = key;
        tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", mutableOptions_[key]];
    }
    else if (indexPath.section == 1)
    {
        NSString *const key = [[mutablePasswordStorageMode_ allKeys] objectAtIndex:indexPath.row];
        tableViewCell.textLabel.text = key;
        tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", mutablePasswordStorageMode_[key]];
    }
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}








@end
