//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 14.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *data;
@end

@implementation SettingsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
//    NSDictionary *const record =
//    [[self.recordsManager records] objectAtIndex:indexPath.row];
//    tableViewCell.textLabel.text = [record valueForKey:kServiceName];
//    tableViewCell.detailTextLabel.text = [record valueForKey:kPassword];
    
    return tableViewCell;
    
#undef REUSABLE_CELL_ID
}

#pragma mark - UITableViewDelegate implementation

-       (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
