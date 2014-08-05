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

static const NSUInteger PasswordLengthShort = 5;
static const NSUInteger PasswordLengthMedium = 10;
static const NSUInteger PasswordLengthLong = 15;

static const NSUInteger StrengthSegmentWeak = 0;
static const NSUInteger StrengthSegmentMedium = 1;
static const NSUInteger StrengthSegmentStrong = 2;

static NSString *const LowercaseLetterAlphabet = @"abcdefghijklmnopqrstuvwxyz";
static NSString *const UppercaseLetterAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString *const DecimalDigitAlphabet = @"1234567890";

@interface NewRecordViewController ()
    <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) NSDictionary *record;
@property (weak, nonatomic) IBOutlet UISegmentedControl *passwordStrengthControl;
@property (readwrite, nonatomic) NSInteger passwordStrength;

- (void)refreshPassword;
- (void)saveRecord;

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender;

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender;

- (IBAction)didTouchRefreshButton:(UIButton *)sender;

- (IBAction)changePasswordStrangth:(UISegmentedControl *)sender;

@end

@implementation NewRecordViewController

@synthesize delegate = delegate_;

@synthesize serviceNameTextField = serviceNameTextField_;
@synthesize passwordLabel = passwordLabel_;


#pragma mark - Inits

- (instancetype) initWithRecord:(NSDictionary *)record
{
    if (self = [super init]) {
        self.record = record;
    }
    return self;
}

- (instancetype) init
{
    return [self initWithRecord:nil];
}


#pragma mark - Auxiliaries

- (void)refreshPassword
{
    NSUInteger passwordLength = 0;
    NSString *alphabet = LowercaseLetterAlphabet;
    switch (self.passwordStrength) {
        case PasswordStrengthStrong: {
            passwordLength = PasswordLengthLong;
            alphabet = [alphabet stringByAppendingString:UppercaseLetterAlphabet];
            alphabet = [alphabet stringByAppendingString:DecimalDigitAlphabet];
            break;
        }
        case PasswordStrengthMedium: {
            passwordLength = PasswordLengthMedium;
            alphabet = [alphabet stringByAppendingString:UppercaseLetterAlphabet];
            break;
        }
        case PasswordStrengthWeak:
        default: {
            passwordLength = PasswordLengthShort;
            break;
        }
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
    self.passwordStrength = [[Preferences standardPreferences] passwordStrength];
    switch (self.passwordStrength) {
        case PasswordStrengthStrong: {
            [self.passwordStrengthControl setSelectedSegmentIndex:StrengthSegmentStrong];
            break;
        }
        case PasswordStrengthMedium: {
            [self.passwordStrengthControl setSelectedSegmentIndex:StrengthSegmentMedium];
            break;
        }
        case PasswordStrengthWeak:
        default: {
            [self.passwordStrengthControl setSelectedSegmentIndex:StrengthSegmentWeak];
            break;
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.record) {
        [self refreshPassword];
    }
    else {
        self.passwordLabel.text = self.record[kPassword];
        self.serviceNameTextField.text = self.record[kServiceName];
    }
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    if (self.record) {
        [self.delegate newRecordViewController:self didFinishWithRecord:self.record];
    }
    else {
        [self.delegate newRecordViewController:self didFinishWithRecord:nil];
    }
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    [self saveRecord];
}

- (IBAction)didTouchRefreshButton:(UIButton *)sender
{
    [self refreshPassword];
}

- (IBAction)changePasswordStrangth:(UISegmentedControl *)sender
{
        switch (sender.selectedSegmentIndex) {
        case StrengthSegmentStrong: {
            self.passwordStrength = PasswordStrengthStrong;
            break;
        }
        case StrengthSegmentMedium: {
            self.passwordStrength = PasswordStrengthMedium;
            break;
        }
        case StrengthSegmentWeak:
        default: {
            self.passwordStrength = PasswordStrengthWeak;
            break;
        }
    }
    [self refreshPassword];
}

#pragma mark - UITextFieldDelegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveRecord];
    return YES;
}

@end
