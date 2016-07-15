//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 14.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Preferences.h"


NSString *kPasswordStrengthSection = @"PasswordStrengthSection";
NSString *kPasswordStorageSection = @"PasswordStorageSection";
NSString *kPasswordStrengthSectionTitle = @"Password strength";
NSString *kPasswordStorageSectionTile = @"Password storage";

NSString *kName = @"name";
NSString *kCheck = @"check";
NSString *kTitle = @"title";

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic) NSIndexPath *checkedIndexPathPasswordStrengthSection;
@property (nonatomic) NSIndexPath *checkedIndexPathPasswordStorageSection;
@end

@implementation SettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!!self.navigationItem) {        
        UIBarButtonItem *const doneBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
         target:self
         action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
    }
    
    self.data = @{
                  kPasswordStrengthSection: @[
                          [@{
                              kName: @(PasswordStrengthWeak),
                              kCheck: @NO,
                              kTitle: @"Weak"
                              } mutableCopy],
                          [@{
                              kName: @(PasswordStrengthMedium),
                              kCheck: @NO,
                              kTitle: @"Medium"
                              } mutableCopy],
                          [@{
                              kName: @(PasswordStrengthStrong),
                              kCheck: @NO,
                              kTitle: @"Strong"
                              } mutableCopy]
                          ],
                  kPasswordStorageSection: @[
                          [@{
                              kName: @(PasswordStorageSQLite),
                              kCheck: @NO,
                              kTitle: @"SQLite"
                              } mutableCopy],
                          [@{
                              kName: @(PasswordStorageOld),
                              kCheck: @NO,
                              kTitle: @"Old"
                              } mutableCopy]
                          ]
                  };
//    NSMutableArray *passwordStrengthArray = [NSMutableArray array];
//    id object;
//    object = [[NSObject alloc] init];
    
    NSInteger passwordStrength = [[Preferences standardPreferences] passwordStrength];
    for (NSMutableDictionary *dictionary in [self.data objectForKey:kPasswordStrengthSection]) {
        if ([dictionary[kName] integerValue] == passwordStrength) {
            [dictionary setValue:@YES forKey:kCheck];
        }
    }
    
    NSInteger passwordStorage = [[Preferences standardPreferences] passwordStorage];
    for (NSMutableDictionary *dictionary in [self.data objectForKey:kPasswordStorageSection]) {
        if ([dictionary[kName] integerValue] == passwordStorage) {
            [dictionary setValue:@YES forKey:kCheck];
        }
    }
}

- (void)updatePasswordStrength:(NSInteger)passwordStrength
{
    [Preferences standardPreferences].passwordStrength = passwordStrength;
}

- (void)updatePasswordStorage:(NSInteger)passwordStorage
{
    [Preferences standardPreferences].passwordStorage = passwordStorage;
}

- (IBAction)didTouchDoneBarButtonItem:(id)sender
{
    [self.delegate settingsViewControllerdidFinish:self];
}

#pragma mark - UITableViewDataSource implementation


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [self.data.allKeys objectAtIndex:section];
    NSArray *sectionData = [self.data objectForKey:sectionTitle];
    return [sectionData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.allKeys.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.data.allKeys objectAtIndex:section] isEqualToString:kPasswordStrengthSection]){
        return kPasswordStrengthSectionTitle;
    } else if ([[self.data.allKeys objectAtIndex:section] isEqualToString:kPasswordStorageSection]){
        return kPasswordStorageSectionTile;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#define REUSABLE_CELL_ID @"ReusableCellID"
    
    UITableViewCell *tableViewCell =
    [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:REUSABLE_CELL_ID];
    }
    NSString *sectionTitle = [self.data.allKeys objectAtIndex:indexPath.section];
    NSArray *sectionData = [self.data objectForKey:sectionTitle];
    tableViewCell.textLabel.text = [sectionData[indexPath.row] valueForKey:kTitle];
    
//    if ([[sectionData[indexPath.row] valueForKey:kCheck] boolValue]) {
//        tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else{
//        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}

#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [self.data.allKeys objectAtIndex:indexPath.section];
    NSArray *sectionData = [self.data objectForKey:sectionTitle];
//    NSArray *objects = [self.data objectForKey:sectionTitle];
//    for (int i=0; i<objects.count; i++) {
//        NSMutableDictionary *dictionary = objects[i];
//        if (i == indexPath.row) {
//            [dictionary setValue:@YES forKey:kCheck];
//        } else{
//            [dictionary setValue:@NO forKey:kCheck];
//        }
//    }
    if ([sectionTitle isEqualToString:kPasswordStrengthSection]) {
        NSInteger oldRow = (self.checkedIndexPathPasswordStrengthSection != nil) ? self.checkedIndexPathPasswordStrengthSection.row : -1;
        if (indexPath.row != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                        indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                        self.checkedIndexPathPasswordStrengthSection];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            self.checkedIndexPathPasswordStrengthSection = indexPath;
            [self updatePasswordStrength:[[sectionData[indexPath.row] valueForKey:kName] integerValue]];
        }
    } else if ([sectionTitle isEqualToString:kPasswordStorageSection]) {
        
        NSInteger oldRow = (self.checkedIndexPathPasswordStorageSection != nil) ? self.checkedIndexPathPasswordStorageSection.row : -1;
        if (indexPath.row != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                        indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                        self.checkedIndexPathPasswordStorageSection];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            self.checkedIndexPathPasswordStorageSection = indexPath;
            [self updatePasswordStorage:[[sectionData[indexPath.row] valueForKey:kName] integerValue]];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}



@end
