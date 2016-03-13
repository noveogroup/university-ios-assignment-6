
#import <UIKit/UIKit.h>

@class RecordViewController;

/**
 *  The protocol describing the duties the instance of @c NewRecordViewController
 *  are able to delegate.
 */
@protocol NewRecordViewControllerDelegate <NSObject>

/**
 *  Notifies the receiver that the sender has finished its job.
 *
 *  @param[in]  record  The record the user wants to register.
 *                      If the user has pressed 'Cancel',
 *                      the @c record is @b nil.
 */
- (void)newRecordViewController:(RecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record;

//- (void)newRecordViewController:(NewRecordViewController *)sender
//            didFinishWithRecord:(NSDictionary *)record
//    ;

@end

@interface RecordViewController : UIViewController

/**
 *  Returns the object that handles the delegated duties.
 */
@property (nonatomic, weak) id<NewRecordViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDictionary *changedRecord;

@end
