//
//  RecordsViewController.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "NewRecordViewController.h"
#import "Record.h"
#import "RecordsManager.h"
#import "RecordsViewController.h"
#import "EditRecordViewController.h"
#import "StorageController.h"
#import "RecordsManagerFMDB.h"

static NSString *const DefaultFileNameForLocalStore = @"AwesomeFileName.dat";
static NSString *const DefaultFileNameForDataBase = @"AwesomeDataBase";

@interface RecordsViewController ()
    <UITableViewDataSource,
     UITableViewDelegate,
     NewRecordViewControllerDelegate,
     EditRecordViewControllerDelegate>

@property (nonatomic, readonly) id<StorageController> recordsManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSURL *fileURLForLocalStore;
@property (strong, nonatomic) NSURL *fileURLForDataBase;

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation RecordsViewController

@synthesize recordsManager = recordsManager_;

@synthesize tableView = tableView_;

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

#pragma mark - Getters

- (id<StorageController>)recordsManager
{
    if (!recordsManager_) {
        StorageMethod storageMethod = [[Preferences standardPreferences] storageMethod];
        NSLog(@"Storage method is set to '%@'", storageMethod ? @"Database" : @"File");
        switch (storageMethod) {
            case StorageMethodFile: {
                NSURL *const documentDirectoryURL =
                    [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                        inDomains:NSUserDomainMask] lastObject];
                self.fileURLForLocalStore =
                    [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForLocalStore];
                
                recordsManager_ = [[RecordsManager alloc] initWithURL:self.fileURLForLocalStore];
                break;
            }
            case StorageMethodDatabase: {
                NSURL *const documentDirectoryURL =
                    [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                            inDomains:NSUserDomainMask] lastObject];
                self.fileURLForDataBase =
                    [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForDataBase];
                
                recordsManager_ = [[RecordsManagerFMDB alloc]
                                   initWithDbPath:[self.fileURLForDataBase path]];
                break;
            }
            default: {
                break;
            }
        }
    }
    return recordsManager_;
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

- (IBAction)didTouchSettingsBarButtonItem:(UIBarButtonItem *)sender {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    settingsVC.recordsViewController = self;
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:settingsVC];
    [self presentViewController:navController animated:YES completion:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *const record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    
    EditRecordViewController *const rootViewController = [[EditRecordViewController alloc] init];
    rootViewController.record = record;
    rootViewController.delegate = self;
    
    UINavigationController *const navigationController =
    [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSDictionary *record = @{kServiceName: cell.textLabel.text,
                                 kPassword: cell.detailTextLabel.text};
        [self.recordsManager deleteRecord:record];
        [self.recordsManager synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationRight];
    }
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
                             completion:nil];
}

- (void)editRecordViewController:(EditRecordViewController *)sender
             didFinishEditRecord:(NSDictionary *)editedRecord
                        byRecord:(NSDictionary *)resultRecord
{
    if (![editedRecord isEqual:resultRecord]) {
        [self.recordsManager modifyRecord:editedRecord byRecord:resultRecord];
        [self.recordsManager synchronize];
        
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Switch storage method implementation

- (void)switchStorageMethodTo:(StorageMethod)storageMethod {
    NSLog(@"Switching to storage method %@...", storageMethod ? @"Database" : @"File");
    
    // Create "dump" of all records
    StorageMethod previousStorageMethod = [[Preferences standardPreferences] storageMethod];
    NSArray *allRecords = [self.recordsManager records];
    
    // Invalidate current record manager
    recordsManager_ = nil;
    
    // Initialize new record manager and copy the all records to it
    [[Preferences standardPreferences] setStorageMethod:storageMethod];
    [self.recordsManager setRecords:allRecords];
    [self.recordsManager synchronize];

    // Clear previous storage
    [self clearStorageForMethod:previousStorageMethod];
            
    NSLog(@"Switching to storage method %@... DONE", storageMethod ? @"Database" : @"File");
}

- (void)clearStorageForMethod:(StorageMethod)storageMethod {
    switch (storageMethod) {
        case StorageMethodFile: {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:self.fileURLForLocalStore.path]) {
                NSError *__autoreleasing error = nil;
                [fileManager removeItemAtURL:self.fileURLForLocalStore error:&error];
                if (error != nil) {
                    NSLog(@"An error occurred while trying to delete file: %@", error);
                }
                else {
                    NSLog(@"The local store file previously used is successfully deleted.");
                }
            }
            break;
        }
        case StorageMethodDatabase: {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:self.fileURLForDataBase.path]) {
                NSError *__autoreleasing error = nil;
                [fileManager removeItemAtURL:self.fileURLForDataBase error:&error];
                if (error != nil) {
                    NSLog(@"An error occurred while trying to delete database: %@", error);
                }
                else {
                    NSLog(@"The database previously used is successfully deleted.");
                }
            }
            break;
        }
        default:
            NSLog(@"Clearing of storage with type %ld is not implemented yet. Please implement it.",
                  storageMethod);
            break;
    }
}

@end
