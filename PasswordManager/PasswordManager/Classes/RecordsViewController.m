#import "NewRecordViewController.h"
#import "Record.h"
#import "RecordsViewController.h"
#import "PreferencesTableVC.h"
#import "PasswordEditVC.h"
#import "Preferences.h"

static NSString *const DefaultFileNameForLocalStore = @"AwesomeFileName.dat";

@interface RecordsViewController ()
    <UITableViewDataSource,
    UITableViewDelegate,
    NewRecordViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender;


@end

@implementation RecordsViewController

@synthesize recordsManager = recordsManager_;

@synthesize tableView = tableView_;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData]; 
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.editing = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Password manager";
    
    UIBarButtonItem *editButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                      target:self
                                                      action:@selector(actionEdit:)];
    
    self.navigationItem.leftBarButtonItem = editButton;
    
    UIImage *image = [UIImage imageNamed:@"settings"];
    UIBarButtonItem *settingsButton =
        [[UIBarButtonItem alloc] initWithImage:image
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(actionSettings:)];
    
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    
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

#pragma mark - Actions

- (void)actionSettings:(UIBarButtonItem *)sender
{
    UIStoryboard *storyBoard =
        [UIStoryboard storyboardWithName:@"PreferencesStoryboard"
                                  bundle:[NSBundle mainBundle]];
    
    PreferencesTableVC *preferences = [storyBoard instantiateViewControllerWithIdentifier:@"Preferences"];
    
    [self presentViewController:preferences animated:YES completion:NULL];
    
}

- (void)actionEdit:(UIBarButtonItem *)sender
{
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    
}

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender
{
    NewRecordViewController *const rootViewController = [[NewRecordViewController alloc] init];
    rootViewController.delegate = self;

    UINavigationController *const navigationController =
        [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    
    [self presentViewController:navigationController animated:YES completion:NULL];
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
    NSDictionary *const record =
        [[self.recordsManager records] objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = [record valueForKey:kServiceName];
    tableViewCell.detailTextLabel.text = [record valueForKey:kPassword];

    return tableViewCell;

#undef REUSABLE_CELL_ID
}

#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PasswordEditVC *passEditVC =
        [[PasswordEditVC alloc] initWithNibName:NSStringFromClass([PasswordEditVC class])
                                         bundle:[NSBundle mainBundle]];
    
    NSDictionary *record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    
    passEditVC.passObject = record;
    passEditVC.recordsManager = self.recordsManager;
    
    [self.navigationController pushViewController:passEditVC animated:YES];
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
        NSDictionary *record = [[self.recordsManager records] objectAtIndex:indexPath.row];
        
        [self.recordsManager removeRecord:record];
        [self.recordsManager synchronize];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tableView endUpdates];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - NewRecordViewControllerDelegate implementation

- (void)newRecordViewController:(NewRecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record
{
    if (record) {
        [self.recordsManager registerRecord:record];
        [self.recordsManager synchronize];

        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}




@end
