#import <UIKit/UIKit.h>
@class RecordsManager;

@interface PasswordEditVC : UIViewController

@property (copy, nonatomic) NSDictionary *passObject;
@property (strong, nonatomic) RecordsManager *recordsManager;

@end
