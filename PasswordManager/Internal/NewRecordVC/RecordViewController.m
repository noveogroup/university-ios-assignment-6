
#import "RecordViewController.h"
#import "PasswordGenerator.h"
#import "Preferences.h"
#import "Record.h"

static NSString *const LowercaseLetterAlphabet = @"abcdefghijklmnopqrstuvwxyz";
static NSString *const UppercaseLetterAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString *const DecimalDigitAlphabet = @"1234567890";
static NSString *const AnotherSymbolsAndPunctuationsAlphabet = @"!@#$%^&*()_+{}[]|/,.±>?<";

@interface RecordViewController ()
    <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (nonatomic, strong) NSString *currentId;

- (void)refreshPassword;
- (void)saveRecord;

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender;

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender;

- (IBAction)didTouchRefreshButton:(UIButton *)sender;

@end

@implementation RecordViewController

@synthesize delegate = delegate_;

@synthesize serviceNameTextField = serviceNameTextField_;
@synthesize passwordLabel = passwordLabel_;

#pragma mark - Auxiliaries

- (void)refreshPassword
{
    NSUInteger passwordLength = [[Preferences standardPreferences] passwordLength];
    NSString *alphabet = [self createAlphabet];
    
    
    self.passwordLabel.text =
        [PasswordGenerator generatePasswordOfLength:passwordLength
                                      usingAlphabet:alphabet];
}

- (void)saveRecord
{
    if ([self.serviceNameTextField.text length] > 0) {
        NSDictionary *const record =
            @{kServiceName: self.serviceNameTextField.text,
              kPassword: self.passwordLabel.text,
              @"id": [PasswordGenerator uuid]};
        [self.delegate newRecordViewController:self didFinishWithRecord:record];
    }
}

- (void)updateRecord
{
    NSDictionary *const record =
    @{kServiceName: self.serviceNameTextField.text,
      kPassword: self.passwordLabel.text,
      @"id": self.changedRecord[@"id"]};
    [self.delegate newRecordViewController:self didFinishWithRecord:record];
}

#pragma mark - CreateAlphabet
- (NSString*) createAlphabet
{   
    NSInteger currentSymbolsType = [[Preferences standardPreferences] passwordSymbolsType];
    NSString* alphabet = @"";
    if (currentSymbolsType & IncludeUppercaseSymbols) {
        alphabet = [alphabet stringByAppendingString:UppercaseLetterAlphabet];
    }
    
    if (currentSymbolsType & IncludeLowercaseSymbols) {
        alphabet = [alphabet stringByAppendingString:LowercaseLetterAlphabet];
    }
    
    if (currentSymbolsType & IncludeDecimalDigit) {
        alphabet = [alphabet stringByAppendingString:DecimalDigitAlphabet];
    }
    
    if (currentSymbolsType & IncludeAnotherSymbolsAndPunctuations) {
        alphabet = [alphabet stringByAppendingString:AnotherSymbolsAndPunctuationsAlphabet];
    }
    return alphabet;
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

    if (!self.changedRecord) {
        [self refreshPassword];
    } else {
        self.serviceNameTextField.text = self.changedRecord[kServiceName];
        self.passwordLabel.text = self.changedRecord[kPassword];
    }
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.delegate newRecordViewController:self didFinishWithRecord:nil];

//    if (!self.changedRecord) {
//        [self.delegate newRecordViewController:self didFinishWithRecord:nil];
//    } else {
//        [self.delegate newRecordViewController:self didFinishWithRecord:self.changedRecord];
//    }
}

- (void)didTouchSaveBarButtonItem:(UIBarButtonItem *)sender
{
    if (!self.changedRecord) {
        [self saveRecord];
    } else {
        [self updateRecord];
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
