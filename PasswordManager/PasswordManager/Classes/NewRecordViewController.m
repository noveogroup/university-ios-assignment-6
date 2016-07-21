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

static NSString *const LowercaseLetterAlphabet = @"abcdefghijklmnopqrstuvwxyz";
static NSString *const UppercaseLetterAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString *const DecimalDigitAlphabet = @"1234567890";

@interface NewRecordViewController ()
    <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) NSDictionary *record;
@property (nonatomic, getter = isEdit) BOOL edit;
@property (nonatomic) NSIndexPath *indexPath;

- (void)refreshPassword;
- (void)saveRecord;

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender;

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender;

- (IBAction)didTouchRefreshButton:(UIButton *)sender;

@end

@implementation NewRecordViewController

@synthesize delegate = delegate_;

@synthesize serviceNameTextField = serviceNameTextField_;
//@synthesize passwordTextField = _passwordTextField;

#pragma mark - Initialization

- (instancetype)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _edit = NO;
    }
    return self;
}

- (instancetype)initWithRecord:(NSDictionary *)record AtIndexPath:(NSIndexPath *)indexPath
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        _indexPath = indexPath;
        _record = record;
        _edit = YES;
    }
    return self;
}

#pragma mark - Auxiliaries

- (void)refreshPassword
{
    NSUInteger passwordLength = 0;
    NSString *alphabet = LowercaseLetterAlphabet;
    switch ([[Preferences standardPreferences] passwordStrength]) {
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
    self.passwordTextField.text =
        [PasswordGenerator generatePasswordOfLength:passwordLength
                                      usingAlphabet:alphabet];
}

- (void)saveRecord
{
    if (([self.serviceNameTextField.text length] > 0) && !(self.isEdit)) {
        NSDictionary *const record =
            @{kServiceName: self.serviceNameTextField.text,
              kPassword: self.passwordTextField.text};
        [self.delegate newRecordViewController:self didFinishWithRecord:record];
    } else {
        NSDictionary *const record =
        @{kServiceName: self.serviceNameTextField.text,
          kPassword: self.passwordTextField.text};
        [self.delegate newRecordViewController:self didFinishEditWithRecord:record atIndexPath:self.indexPath];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isEdit) {
        self.serviceNameTextField.text = [self.record valueForKey:kServiceName];
        self.passwordTextField.text = [self.record valueForKey:kPassword];
    } else {
        [self refreshPassword];
    }
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate newRecordViewController:self didFinishWithRecord:nil];
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    if (([self.serviceNameTextField.text length] > 0) && ([self.passwordTextField.text length] > 0)) {
        [self saveRecord];
    } else {
        UIAlertController *alertConrtoller = [UIAlertController alertControllerWithTitle:@"Empty Field" message:nil preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault   handler:nil];
        [alertConrtoller addAction:cancelAction];
        [self presentViewController:alertConrtoller animated:YES completion:nil];

    }
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
