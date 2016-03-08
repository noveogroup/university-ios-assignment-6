//
//  NewRecordViewController.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "NewRecordViewController.h"
#import "PasswordGenerator.h"
#import "Preferences.h"
#import "Record.h"


static NSString *const LowercaseLetterAlphabet = @"abcdefghijklmnopqrstuvwxyz";
static NSString *const UppercaseLetterAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString *const DecimalDigitAlphabet = @"1234567890";
static NSString *const SymbolsAlphabet = @"@#$%^&*";


@interface NewRecordViewController ()
    <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

- (void)refreshPassword;
- (void)saveRecord;

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender;

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender;

- (IBAction)didTouchRefreshButton:(UIButton *)sender;

@end

@implementation NewRecordViewController

@synthesize delegate = delegate_;

@synthesize serviceNameTextField = serviceNameTextField_;
@synthesize passwordLabel = passwordLabel_;

#pragma mark - Auxiliaries

- (void)refreshPassword
{
    NSUInteger passwordLength = [[Preferences standardPreferences] passwordLength];
    
    NSString *alphabet = [NSString string];
    
    if ([[Preferences standardPreferences] includeLowercaseChars]) {
        alphabet = [alphabet stringByAppendingString:LowercaseLetterAlphabet];
    }
    
    if ([[Preferences standardPreferences] includeUppercaseChars]) {
        alphabet = [alphabet stringByAppendingString:UppercaseLetterAlphabet];
    }

    if ([[Preferences standardPreferences] includeNumbers]) {
        alphabet = [alphabet stringByAppendingString:DecimalDigitAlphabet];
    }
    
    if ([[Preferences standardPreferences] includeSymbols]) {
        alphabet = [alphabet stringByAppendingString:SymbolsAlphabet];
    }
    
    self.passwordLabel.text =
        [PasswordGenerator generatePasswordOfLength:passwordLength
                                      usingAlphabet:alphabet];
}

- (void)saveRecord
{
    if ([self.serviceNameTextField.text length] > 0) {
        NSDictionary *const record =
            @{kServiceName: self.serviceNameTextField.text,
              kPassword: self.passwordLabel.text};
        [self.delegate newRecordViewController:self didFinishWithRecord:record];
    }
}

- (void)deleteRecord
{
    NSDictionary *const record =
        @{kServiceName: self.serviceNameTextField.text,
          kPassword: self.passwordLabel.text};
    
    
    [self.delegate newRecordViewController:self didFinishWithRecord:record];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self refreshPassword];
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate newRecordViewController:self didFinishWithRecord:nil];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    [self saveRecord];
}

- (IBAction)didTouchRefreshButton:(UIButton *)sender
{
    [self refreshPassword];
}

#pragma mark - UITextFieldDelegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveRecord];

    return YES;
}

@end
