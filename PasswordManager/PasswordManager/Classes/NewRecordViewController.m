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
@synthesize indexPath = indexPath_;
@synthesize record = record_;

#pragma mark - Implementation

- (instancetype)initWithMode:(NewRecordViewControllerMode)mode
                      record:(NSDictionary *)record
                 atIndexPath:(NSIndexPath *)indexPath
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _mode = mode;
        if (mode == NewRecordViewControllerNewRecordMode) {
            indexPath_ = indexPath;
            record_ = record;
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithMode:NewRecordViewControllerNewRecordMode record:nil atIndexPath:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithMode:NewRecordViewControllerNewRecordMode record:nil atIndexPath:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithMode:NewRecordViewControllerNewRecordMode record:nil atIndexPath:nil];
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
    self.passwordLabel.text =
        [PasswordGenerator generatePasswordOfLength:passwordLength
                                      usingAlphabet:alphabet];
}

- (void)saveRecord
{
    if ([self.serviceNameTextField.text length] > 0) {
        NSDictionary *record =
            @{kServiceName: self.serviceNameTextField.text,
              kPassword: self.passwordLabel.text};
        [self.delegate newRecordViewController:self didFinishWithRecord:record];
    }
}

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.serviceNameTextField.text = self.record[kServiceName];
    self.passwordLabel.text = self.record[kPassword];
    if (!!self.navigationItem) {
        UIBarButtonItem *const cancelBarButtonItem =
            [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
        if (self.mode == NewRecordViewControllerNewRecordMode) {
            UIBarButtonItem *const saveBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                          target:self
                                                          action:@selector(didTouchSaveBarButtonItem:)];
            [self.navigationItem setRightBarButtonItem:saveBarButtonItem];

        }
        else {
            UIBarButtonItem *const doneBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                          target:self
                                                          action:@selector(didTouchDoneBarButtonItem:)];
            [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.mode == NewRecordViewControllerNewRecordMode) {
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
    [self saveRecord];
}

- (IBAction)didTouchRefreshButton:(UIButton *)sender
{
    [self refreshPassword];
}

- (void)didTouchDoneBarButtonItem:(UIBarButtonItem *)sender
{
    [self saveRecord];
}

#pragma mark - UITextFieldDelegate implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
