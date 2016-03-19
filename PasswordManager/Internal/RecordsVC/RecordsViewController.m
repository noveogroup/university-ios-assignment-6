
#import "RecordViewController.h"
#import "Record.h"
#import "RecordsPlistStorageManager.h"
#import "RecordsSQLiteManager.h"
#import "RecordsViewController.h"
#import "SettingsViewController.h"
#import "Preferences.h"

static NSString *const DefaultFileNameForLocalStore = @"AwesomeFileName.dat";

@interface RecordsViewController ()
    <UITableViewDataSource,
     UITableViewDelegate,
     NewRecordViewControllerDelegate>

@property (nonatomic, readonly) id<RecordsManagerProtocol> recordsManager;
@property (nonatomic, readonly) RecordsSQLiteManager *recordsSQLiteManager;
@property (nonatomic, readonly) RecordsPlistStorageManager *recordsPlistManager;


@property (nonatomic, assign) NSInteger changedRowIndex;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTouchAddBarButtonItem;

@end

@implementation RecordsViewController

@synthesize recordsManager = recordsManager_;
@synthesize recordsSQLiteManager = recordsSQLiteManager_;
@synthesize recordsPlistManager = recordsPlistManager_;


@synthesize tableView = tableView_;

#pragma mark - VC life circle
- (void) viewDidLoad
{
    self.changedRowIndex = -1;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem* settingsItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchSettingsBarButtonItem)];
    [self.navigationItem setRightBarButtonItem:settingsItem animated:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Getters

- (id<RecordsManagerProtocol>)recordsManager
{
    NSInteger currentDBType = [[Preferences standardPreferences] DBType];
    if (currentDBType == DBTypePlist) {
        
        return self.recordsPlistManager;
        
    } else if (currentDBType == DBTypeSQLite) {
        
        return self.recordsSQLiteManager;
        
    }
    
    return nil;
}

- (RecordsPlistStorageManager *)recordsPlistManager
{
    if (!recordsPlistManager_) {
        NSURL *const documentDirectoryURL =
        [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                inDomains:NSUserDomainMask] lastObject];
        NSURL *const fileURLForLocalStore =
        [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForLocalStore];
        
        recordsPlistManager_ = [[RecordsPlistStorageManager alloc] initWithURL:fileURLForLocalStore];
    }
    return recordsPlistManager_;
}

- (RecordsSQLiteManager *)recordsSQLiteManager
{
    if (!recordsSQLiteManager_){
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:@"records.db"];
        recordsSQLiteManager_ = [[RecordsSQLiteManager alloc] initWithPath:filePath];
    }
    return recordsSQLiteManager_;
}



#pragma mark - Actions

- (IBAction)didTouchAddBarButtonItem
{
    RecordViewController *const rootViewController = [[RecordViewController alloc] init];
    rootViewController.delegate = self;

    UINavigationController *const navigationController =
        [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)didTouchSettingsBarButtonItem
{
    UIStoryboard* settingsStoryboard = [UIStoryboard storyboardWithName:settingsStoryboardName bundle:nil];
    SettingsViewController* vc = [settingsStoryboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[self.recordsManager records] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"

    UITableViewCell *tableViewCell =
        [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    NSDictionary *const record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = [record valueForKey:kServiceName];
    tableViewCell.detailTextLabel.text = [record valueForKey:kPassword];

    return tableViewCell;

#undef REUSABLE_CELL_ID
}

#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *const record = [[self.recordsManager records] objectAtIndex:indexPath.row];

    
    RecordViewController *const rootViewController = [[RecordViewController alloc] init];
    rootViewController.delegate = self;
    rootViewController.changedRecord = record;
    
    self.changedRowIndex = indexPath.row;
    
    UINavigationController *const navigationController =
    [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *deletedRecord = [[self.recordsManager records] objectAtIndex:indexPath.row];
        [self.recordsManager removeRecord:deletedRecord];
        
        SEL synchronize = @selector(synchronize);
        if ([self.recordsManager respondsToSelector:synchronize]) {
            [self.recordsManager performSelector:synchronize];
        }
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        [tableView endUpdates];
    }
}

#pragma mark - NewRecordViewControllerDelegate implementation

- (void)newRecordViewController:(RecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record
{
    if (record) {
        if (self.changedRowIndex < 0) {
            [self.recordsManager registerRecord:record];
        } else {
            [self.recordsManager updateRecord:record];
        }
        
        SEL synchronize = @selector(synchronize);
        if ([self.recordsManager respondsToSelector:synchronize]) {
            [self.recordsManager performSelector:synchronize];
        }
    }
    
    self.changedRowIndex = -1;
    [self.tableView reloadData];

    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

@end
