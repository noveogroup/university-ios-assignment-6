
#import "NewRecordViewController.h"
#import "Record.h"
#import "RecordsManager.h"
#import "RecordsDBManager.h"
#import "RecordsViewController.h"
#import "SettingsViewController.h"

static NSString *const DefaultFileNameForLocalStore = @"AwesomeFileName.dat";

@interface RecordsViewController ()
    <UITableViewDataSource,
     UITableViewDelegate,
     NewRecordViewControllerDelegate>

@property (nonatomic, readonly) RecordsDBManager *recordsDBManager;

@property (nonatomic, readonly) RecordsManager *recordsManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation RecordsViewController

@synthesize recordsManager = recordsManager_;

@synthesize recordsDBManager = recordsDBManager_;


@synthesize tableView = tableView_;

#pragma mark - VC life circle
- (void) viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem* settingsItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchSettingsBarButtonItem)];
    [self.navigationItem setRightBarButtonItem:settingsItem animated:NO];
}

#pragma mark - Getters

- (RecordsManager *)recordsManager
{
    if (!recordsManager_) {
        NSURL *const documentDirectoryURL =
            [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                    inDomains:NSUserDomainMask] lastObject];
        NSURL *const fileURLForLocalStore =
            [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForLocalStore];

        recordsManager_ = [[RecordsManager alloc] initWithURL:fileURLForLocalStore];
    }

    return recordsManager_;
}

- (RecordsDBManager *)recordsDBManager
{
    if (!recordsDBManager_) {
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:@"records.db"];
        recordsDBManager_ = [[RecordsDBManager alloc] initWithPath:filePath];
    }
    
    return recordsDBManager_;
}

#pragma mark - Actions

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender
{
    NewRecordViewController *const rootViewController = [[NewRecordViewController alloc] init];
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
    //return [[self.recordsManager records] count];
    return [[self.recordsDBManager records] count];
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
    //NSDictionary *const record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    NSDictionary *const record = [[self.recordsDBManager records] objectAtIndex:indexPath.row];
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
    
    //NSDictionary *const record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    NSDictionary *const record = [[self.recordsDBManager records] objectAtIndex:indexPath.row];

    
    NewRecordViewController *const rootViewController = [[NewRecordViewController alloc] init];
    rootViewController.delegate = self;
    rootViewController.changedRecord = record;

    [self.recordsDBManager removeRecord:record];
    [self.recordsDBManager synchronize];
    
    [tableView beginUpdates];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [tableView endUpdates];
    
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
        [self.recordsManager synchronize];
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        [tableView endUpdates];
    }
}

#pragma mark - NewRecordViewControllerDelegate implementation

- (void)newRecordViewController:(NewRecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record
{
    if (record) {
        [self.recordsDBManager registerRecord:record];
        [self.recordsDBManager synchronize];

        [self.tableView reloadData];
    } else {
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

@end
