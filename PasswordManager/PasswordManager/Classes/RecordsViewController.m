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
#import "SettingsViewController.h"

static NSString *const DefaultFileNameForLocalStore = @"AwesomeFileName.dat";
static NSString *const DefaultDBNameForLocalStore = @"AwesomeDBName.db";

@interface RecordsViewController ()
    <UITableViewDataSource,
     UITableViewDelegate,
     NewRecordViewControllerDelegate,
     SettingsViewControllerDelegate>

@property (nonatomic, readonly) RecordsManager *recordsManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)didTouchAddBarButtonItem:(UIBarButtonItem *)sender;
- (IBAction)didTouchSettingsBarButtonItem:(UIBarButtonItem *)sender;

@end

@implementation RecordsViewController

@synthesize recordsManager = recordsManager_;

@synthesize tableView = tableView_;

#pragma mark - Getters

- (RecordsManager *)recordsManager
{
    if (!recordsManager_) {
        NSURL *const documentDirectoryURL =
            [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                    inDomains:NSUserDomainMask] lastObject];
        NSURL *const fileURLForLocalStore =
            [documentDirectoryURL URLByAppendingPathComponent:DefaultFileNameForLocalStore];
        
        NSArray *libDirs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libDir = [[libDirs objectAtIndex:0] stringByAppendingString:DefaultDBNameForLocalStore];

        recordsManager_ = [[RecordsManager alloc] initWithURL:fileURLForLocalStore andPath:libDir];
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

- (IBAction)didTouchSettingsBarButtonItem:(UIBarButtonItem *)sender
{
    SettingsViewController *settingsVC = [[SettingsViewController alloc]init];
    settingsVC.delegate = self;
    UINavigationController *const navigationController =
    [[UINavigationController alloc] initWithRootViewController:settingsVC];
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
    NewRecordViewController *const editViewController = [[NewRecordViewController alloc] init];
    editViewController.record = [[self.recordsManager records] objectAtIndex:indexPath.row];
    editViewController.delegate = self;
    
    UINavigationController *const navigationController =
    [[UINavigationController alloc] initWithRootViewController:editViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.recordsManager deleteRecordAtIndex:indexPath.row];
        [self.recordsManager synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}

#pragma mark - NewRecordViewControllerDelegate implementation

- (void)newRecordViewController:(NewRecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record
{
    if (record)
    {
        if (sender.record)
        {
            [self.recordsManager replaceRecord:sender.record withRecord:record];
        }
        else
        {
            [self.recordsManager registerRecord:record];

        }
        
        [self.recordsManager synchronize];

        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

#pragma mark - SettingsViewControllerDelegate implementation

- (void)didCloseSettingsMenu:(SettingsViewController *)sender
{
    [self.recordsManager synchronize];
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

@end
