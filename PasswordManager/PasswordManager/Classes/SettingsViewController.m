//
//  SettingsViewController.m
//  PasswordManager
//
//  Created by Admin on 05/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!!self.navigationItem) {
        UIBarButtonItem *const backBarButtonItem =
            [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
    }
    
//    self.serviceNameTextField.text = self.oldRecord[kServiceName];
//    self.passwordTextField.text = self.oldRecord[kPassword];
}

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate settingsViewControllerDone:self];
}

@end
