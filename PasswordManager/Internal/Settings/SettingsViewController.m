
#import "SettingsViewController.h"
#import "Preferences.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *complexitySegmentedControl;
@property (weak, nonatomic) IBOutlet UISlider *symbolsCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *symboldCountLabel;

@property (weak, nonatomic) IBOutlet UISwitch *uppercaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lowercaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *decimalSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *anotherSymbolsSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *DBSwitch;

@end

#pragma mark - View's lifecycle
@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tuneSwitchs];
    [self tuneSlider];
}

#pragma mark - TuneControls
//tune - maybe it isnt best word for this

- (void) tuneSwitchs
{
    NSInteger currentSymbolsType = [[Preferences standardPreferences] passwordSymbolsType];
    
    self.uppercaseSwitch.on = (currentSymbolsType & IncludeUppercaseSymbols) != 0;
    self.lowercaseSwitch.on = (currentSymbolsType & IncludeLowercaseSymbols) != 0;
    self.decimalSwitch.on = (currentSymbolsType & IncludeDecimalDigit) != 0;
    self.anotherSymbolsSwitch.on = (currentSymbolsType & IncludeAnotherSymbolsAndPunctuations) != 0;
    
    NSInteger currentDBType = [[Preferences standardPreferences] DBType];
    if (currentDBType == DBTypePlist) {
        self.DBSwitch.selectedSegmentIndex = 0;
    }
    if (currentDBType == DBTypeSQLite) {
        self.DBSwitch.selectedSegmentIndex = 1;
    }
}

- (void) tuneSlider
{
    NSInteger currentPasswordlLength = [[Preferences standardPreferences] passwordLength];
    
    self.symbolsCountSlider.value = currentPasswordlLength;
    self.symboldCountLabel.text = [@(currentPasswordlLength) stringValue];
}

#pragma mark - Actions
- (IBAction)DBTypeChanged:(id)sender {
    switch (self.DBSwitch.selectedSegmentIndex) {
        case 0:
            [[Preferences standardPreferences] setDBType:DBTypePlist];
            break;
           
        case 1:
            [[Preferences standardPreferences] setDBType:DBTypeSQLite];
            break;
            
        default:
            break;
    }
    
}


- (IBAction)complexityChanged
{
    switch (self.complexitySegmentedControl.selectedSegmentIndex) {
        case 0:
            [[Preferences standardPreferences] setPasswordSymbolsType:IncludeUppercaseSymbols | IncludeDecimalDigit];
            [[Preferences standardPreferences] setPasswordLength:PasswordLengthWeak];
            break;
            
        case 1:
            [[Preferences standardPreferences] setPasswordSymbolsType:IncludeUppercaseSymbols | IncludeDecimalDigit | IncludeLowercaseSymbols];
            [[Preferences standardPreferences] setPasswordLength:PasswordLengthMedium];
            break;
            
        case 2:
            [[Preferences standardPreferences] setPasswordSymbolsType:IncludeUppercaseSymbols | IncludeDecimalDigit | IncludeLowercaseSymbols | IncludeAnotherSymbolsAndPunctuations];
            [[Preferences standardPreferences] setPasswordLength:PasswordLengthStrong];
            break;
            
        default:
            break;
    }
    [self tuneSwitchs];
    [self tuneSlider];
}

- (IBAction)symboldCountChanged
{
    NSInteger newSymbolsCount = (NSInteger)self.symbolsCountSlider.value;
    self.symboldCountLabel.text = [NSString stringWithFormat:@"%@", @(newSymbolsCount)];
    [[Preferences standardPreferences] setPasswordLength:newSymbolsCount];
    
    self.complexitySegmentedControl.selectedSegmentIndex = 3;
}


- (IBAction)settingsChanged
{
    NSInteger symbolsType = 0;
    if (self.uppercaseSwitch.on) {
        symbolsType = symbolsType | IncludeUppercaseSymbols;
    }
    if (self.lowercaseSwitch.on) {
        symbolsType = symbolsType | IncludeLowercaseSymbols;
    }
    if (self.decimalSwitch.on) {
        symbolsType = symbolsType | IncludeDecimalDigit;
    }
    if (self.anotherSymbolsSwitch.on) {
        symbolsType = symbolsType | IncludeAnotherSymbolsAndPunctuations;
    }
    [[Preferences standardPreferences] setPasswordSymbolsType:symbolsType];
    
    self.complexitySegmentedControl.selectedSegmentIndex = 3;
}




@end
