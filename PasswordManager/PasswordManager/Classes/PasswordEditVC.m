#import "PasswordEditVC.h"
#import "PreferencesTableVC.h"
#import "Preferences.h"
#import "Record.h"
#import "RecordsViewController.h"
#import "NewRecordViewController.h"

@interface PasswordEditVC () <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UISwitch *switchChangePassword;
@property (strong, nonatomic) IBOutlet UIButton *buttonGenerate;

@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *previousPassword;
@property (copy, nonatomic) NSString *tempString;

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
    
    UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleTap:)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    self.textFieldPassword.delegate = self;
    self.title = @"Edit password";
    [self refreshData];
}


#pragma mark - Gestures

- (void) handleTap:(UITapGestureRecognizer *) tapGesture
{
    if (!CGRectContainsPoint(self.textFieldPassword.frame, [tapGesture locationInView:self.view])) {
        [self.textFieldPassword resignFirstResponder];
        self.password = self.tempString;
    }
}

#pragma mark - Methods



- (void)refreshData
{
    self.labelName.text = [self.passObject objectForKey:kServiceName];
    self.textFieldPassword.text = [self.passObject objectForKey:kPassword];
    self.password = self.textFieldPassword.text;
    
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
    if ([textField.text length] < [[Preferences standardPreferences] passwordLength]) {
        
        self.tempString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        
        

        return YES;
    } else {
        return NO;
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.previousPassword = self.password;
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


- (IBAction)actionGenerate:(UIButton *)sender
{
    NewRecordViewController *vc = [[NewRecordViewController alloc] init];
    self.textFieldPassword.text = self.password = [vc generatePassword];
}

- (IBAction)actionSave:(UIButton *)sender
{
    if (![self.password isEqualToString:self.previousPassword]) {
        
        NSDictionary *rec = @{kServiceName : self.passObject[kServiceName],
                              kPassword : self.password};
        
        [self.recordsManager replaceRecord:self.passObject withNewRecord:rec];
        
        
        
        
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
