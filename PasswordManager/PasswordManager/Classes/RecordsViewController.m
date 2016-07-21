//
//  RecordsViewController.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "NewRecordViewController.h"
#import "SettingsViewController.h"
#import "Record.h"
#import "RecordsManager.h"
#import "RecordsViewController.h"
#import "Preferences.h"

static NSString *const DefaultFileNameForLocalStore = @"AwesomeFileName.dat";

@interface RecordsViewController ()
    <UITableViewDataSource,
     UITableViewDelegate,
     NewRecordViewControllerDelegate,
     SettingsViewControllerDelegate>

@property (nonatomic, readonly) RecordsManager *recordsManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation RecordsViewController

@synthesize recordsManager = recordsManager_;
@synthesize tableView = tableView_;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:)
        name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[Preferences standardPreferences] storage] == StorageDocumentDirectory) {
        NSURL *const documentDirectoryURL =
        [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                inDomains:NSUserDomainMask] lastObject];
        NSURL *const fileURLForLocalStore =
        [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForLocalStore];
        recordsManager_ = [[RecordsManager alloc] initWithURL:fileURLForLocalStore];
    } else {
        recordsManager_ = [[RecordsManager alloc] initWithFileName:@"Passwords.plist"];
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
        name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - Getters

- (RecordsManager *)recordsManager
{
    if (!recordsManager_) {
        if ([[Preferences standardPreferences] storage] == StorageDocumentDirectory) {
            NSURL *const documentDirectoryURL =
            [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                    inDomains:NSUserDomainMask] lastObject];
            NSURL *const fileURLForLocalStore =
            [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForLocalStore];

            recordsManager_ = [[RecordsManager alloc] initWithURL:fileURLForLocalStore];
        } else {
            recordsManager_ = [[RecordsManager alloc] initWithFileName:@"Passwords.plist"];
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

- (IBAction)didTouchEditBarButtonItem:(UIBarButtonItem *)sender
{
    SettingsViewController *const rootViewController = [[SettingsViewController alloc] init];
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
    NSDictionary *record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = [record valueForKey:kServiceName];
    tableViewCell.detailTextLabel.text = [record valueForKey:kPassword];

    return tableViewCell;

#undef REUSABLE_CELL_ID
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.recordsManager removeObjectAtIndex:indexPath.row];
    [self.recordsManager synchronize];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    [tableView reloadData];
}

#pragma mark - UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *const record = [[self.recordsManager records] objectAtIndex:indexPath.row];

    NewRecordViewController *const rootViewController = [[NewRecordViewController alloc] initWithRecord:record AtIndexPath:indexPath];
    rootViewController.delegate = self;
    
    UINavigationController *const navigationController =
    [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];}

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

- (void)newRecordViewController:(NewRecordViewController *)sender
        didFinishEditWithRecord:(NSDictionary *)record atIndexPath:(NSIndexPath *)indexPath
{
    if (record) {
        NSDictionary *const oldRecord = [[self.recordsManager records] objectAtIndex:indexPath.row];
        [oldRecord setValue:[record valueForKey:kServiceName] forKey:kServiceName];
        [oldRecord setValue:[record valueForKey:kPassword] forKey:kPassword];
        [self.recordsManager synchronize];
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

#pragma mark - SettingsViewControllerDelegate implementation

- (void)settingsViewController:(NewRecordViewController *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
