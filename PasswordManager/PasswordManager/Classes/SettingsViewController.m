//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 01/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int selectedIndex;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedIndex = NSNotFound;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!!self.navigationItem) {
        self.navigationItem.title = @"Settings";

        UIBarButtonItem *const cancelBarButtonItem =
                [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                        target:self
                        action:@selector(dismiss)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Password strength";
        default:
            return @"Other";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView");

    UITableViewCell *cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:@"ololo"];
    cell.textLabel.text = @"Test cell";
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectedIndex != NSNotFound)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath
                indexPathForRow:self.selectedIndex inSection:indexPath.section]];

        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    self.selectedIndex = indexPath.row;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
