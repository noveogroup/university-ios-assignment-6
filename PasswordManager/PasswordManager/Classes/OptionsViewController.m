//
//  OptionsViewController.m
//  PasswordManager
//
//  Created by Wadim on 8/4/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "OptionsViewController.h"
#import "Preferences.h"

@interface OptionsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableDictionary *mutableOptions;
@property (strong, nonatomic) NSMutableDictionary *mutableSafeModes;

@end

@implementation OptionsViewController

#pragma mark - Inits

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mutableOptions = [@{@"Password Strength":
            @([[Preferences standardPreferences]passwordStrength])} mutableCopy];
        self.mutableSafeModes = [@{@"Safe Mode":@(0)} mutableCopy];
    }
    return self;
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
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
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{

}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.mutableOptions count];
    }
    else return [self.mutableSafeModes count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Password Strength Options";
    }
    else return @"Password Keeping Options";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"

    UITableViewCell *tableViewCell =
        [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    if (indexPath.section == 0) {
        NSString *const key =
            [[self.mutableOptions allKeys]objectAtIndex:indexPath.row];
        tableViewCell.textLabel.text = key;
        tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.mutableOptions[key]];
    }
    else {
            NSString *const key =
            [[self.mutableSafeModes allKeys]objectAtIndex:indexPath.row];
        tableViewCell.textLabel.text = key;
        tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.mutableSafeModes[key]];
    }
    return tableViewCell;

#undef REUSABLE_CELL_ID
}

- (BOOL) tableView:tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end
