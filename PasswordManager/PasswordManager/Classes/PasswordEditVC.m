//
//  PasswordEditVC.m
//  PasswordManager
//
//  Created by Vik on 06.03.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import "PasswordEditVC.h"
#import "PreferencesTableVC.h"
#import "Record.h"
#import "RecordsViewController.h"
#import "NewRecordViewController.h"

@interface PasswordEditVC () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UISwitch *switchChangePassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonGenerate;

@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *previousPassword;

- (IBAction)actionGenerate:(UIButton *)sender;
- (IBAction)actionSave:(UIButton *)sender;
- (IBAction)actionSwitch:(UISwitch *)sender;
@end

@implementation PasswordEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"settings"];
    UIBarButtonItem *settingsButton =
    [[UIBarButtonItem alloc] initWithImage:image
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(actionSettings:)];
    
    self.navigationItem.rightBarButtonItem = settingsButton;
    
    
    self.textFieldPassword.delegate = self;
    self.title = @"Edit password";
    [self refreshData];
}



#pragma mark - Methods

- (void)refreshData
{
    self.labelName.text = [self.passObject objectForKey:kServiceName];
    self.textFieldPassword.text = [self.passObject objectForKey:kPassword];
    self.previousPassword = self.textFieldPassword.text;
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.textFieldPassword) {
        [self.textFieldPassword resignFirstResponder];
        
    }
    return NO;
    
}

- (BOOL)textField:(UITextField *)textField
        shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string
{
    if ([textField.text length] < [[PreferencesTableVC standardPreferences] passwordLength]) {
        return YES;
    } else {
        return NO;
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.password = textField.text;
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


- (IBAction)actionGenerate:(UIButton *)sender {
    NewRecordViewController *vc = [[NewRecordViewController alloc] init];
    self.textFieldPassword.text = self.password = [vc generatePassword];
}

- (IBAction)actionSave:(UIButton *)sender
{
    if ([self.password isEqualToString:self.textFieldPassword.text]) {
        
        NSDictionary *rec = @{kServiceName : self.labelName.text,
                              kPassword : self.password};
        
        NSDictionary *prevRec = @{kServiceName : self.labelName.text,
                                  kPassword : self.previousPassword};
        
        [self.recordsManager changePasswordForRecord:rec
                                      withPrevRecord:prevRec];
        
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"Success!"
                                            message:@"Password is saved."
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];

    }
    
}



- (IBAction)actionSwitch:(UISwitch *)sender {
    if (sender.isOn) {
        self.textFieldPassword.enabled = YES;
        self.buttonGenerate.enabled = YES;
    } else {
        self.textFieldPassword.enabled = NO;
        self.buttonGenerate.enabled = NO;
    }
}
@end
