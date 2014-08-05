//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 05/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSDictionary *sectionsContent;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sections = @[
            @"Strength",
            @"Storage"
        ];
        
        _sectionsContent = @{
            _sections[0]: @[
                @"Padawan",
                @"Jedi",
                @"Jedi Master"
            ],
            _sections[1]: @[
                @"Coding",
                @"SQLite"
            ]
        };
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!!self.navigationItem) {
        UIBarButtonItem *const backBarButtonItem =
            [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(didTouchDoneBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    }
}

#pragma mark - TableViewDataSourceDeletgate implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionKey = [self.sections objectAtIndex:section];
    NSArray *sectionContent = [self.sectionsContent valueForKey:sectionKey];

    return [sectionContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSString *sectionTitle = [self.sections objectAtIndex:indexPath.section];
    NSArray *sectionContents = [self.sectionsContent objectForKey:sectionTitle];
    NSString *menuTitle = [sectionContents objectAtIndex:indexPath.row];
    
    cell.textLabel.text = menuTitle;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}

#pragma mark - Actions

- (void)didTouchDoneBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate settingsViewControllerDone:self];
}

@end
