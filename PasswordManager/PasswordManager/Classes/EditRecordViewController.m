#import "EditRecordViewController.h"
#import "PasswordGenerator.h"
#import "Preferences.h"
#import "Record.h"


@implementation EditRecordViewController

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!!self.navigationItem) {
        UIBarButtonItem *const saveBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemSave
         target:self
         action:@selector(didTouchSaveBarButtonItem:)];
        [self.navigationItem setRightBarButtonItem:saveBarButtonItem];
    }
    
    self.serviceNameTextField.text = self.record[kServiceName];
    self.serviceNameTextField.enabled = NO;
    self.serviceNameTextField.backgroundColor = [UIColor colorWithRed:221.0f/255.0f
                                                                green:221.0f/255.0f
                                                                 blue:221.0f/255.0f
                                                                alpha:1.0f];
    
    self.passwordLabel.text = self.record[kPassword];
}

#pragma mark - Auxiliaries

- (void)saveRecord
{
    NSDictionary *const record = @{kServiceName: self.serviceNameTextField.text,
                                   kPassword: self.passwordLabel.text};
    [self.delegate editRecordViewController:self didFinishEditRecord:self.record byRecord:record];
}

#pragma mark - Actions

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    [self saveRecord];
}

@end