#import "RecordViewController.h"
#import "PasswordGenerator.h"
#import "Preferences.h"
#import "Record.h"


static const NSUInteger passwordLengthShort = 5;
static const NSUInteger passwordLengthMedium = 10;
static const NSUInteger passwordLengthLong = 15;

static NSString *const lowercaseLetterAlphabet = @"abcdefghijklmnopqrstuvwxyz";
static NSString *const uppercaseLetterAlphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString *const decimalDigitAlphabet = @"1234567890";


@implementation RecordViewController

#pragma mark - Auxiliaries

- (void)refreshPassword
{
    NSUInteger passwordLength = 0;
    NSString *alphabet = lowercaseLetterAlphabet;
    switch ([[Preferences standardPreferences] passwordStrength]) {
        case passwordStrengthStrong: {
            passwordLength = passwordLengthLong;
            alphabet = [alphabet stringByAppendingString:uppercaseLetterAlphabet];
            alphabet = [alphabet stringByAppendingString:decimalDigitAlphabet];
            break;
        }
        case passwordStrengthMedium: {
            passwordLength = passwordLengthMedium;
            alphabet = [alphabet stringByAppendingString:uppercaseLetterAlphabet];
            break;
        }
        case passwordStrengthWeak:
        default: {
            passwordLength = passwordLengthShort;
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