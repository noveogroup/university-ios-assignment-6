#import <UIKit/UIKit.h>


@interface RecordViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *serviceNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;

- (IBAction)didTouchRefreshButton:(UIButton *)sender;

- (void)refreshPassword;

@end
