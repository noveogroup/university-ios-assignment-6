#import "RecordViewController.h"
#import "PasswordGenerator.h"
#import "Preferences.h"
#import "Record.h"


static const NSUInteger PasswordLengthShort = 5;
static const NSUInteger PasswordLengthMedium = 10;
static const NSUInteger PasswordLengthLong = 15;

static NSString *const LowercaseLetterAlphabet = @"abcdefghijklmnopqrstuvwxyz";
static NSString *const UppercaseLetterAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString *const DecimalDigitAlphabet = @"1234567890";


@implementation RecordViewController

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

#pragma mark - View's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!!self.navigationItem) {
        UIBarButtonItem *const cancelBarButtonItem = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                 target:self
                                 action:@selector(didTouchCancelBarButtonItem:)];
        [self.navigationItem setLeftBarButtonItem:cancelBarButtonItem];
    }
}

#pragma mark - Actions

- (void)didTouchCancelBarButtonItem:(UIBarButtonItem *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTouchRefreshButton:(UIButton *)sender
{
    [self refreshPassword];
}

@end