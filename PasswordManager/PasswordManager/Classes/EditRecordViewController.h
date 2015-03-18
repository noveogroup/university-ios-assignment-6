#import "RecordViewController.h"


@class EditRecordViewController;

/**
 *  The protocol describing the duties the instance of @c EditRecordViewController
 *  are able to delegate.
 */
@protocol EditRecordViewControllerDelegate <NSObject>

/**
 *  Notifies the receiver that the sender has finished its job.
 *
 *  @param[in]  record  The record the user wants to register.
 *                      If the user has pressed 'Cancel',
 *                      the @c record is @b nil.
 */
- (void)editRecordViewController:(EditRecordViewController *)sender
             didFinishEditRecord:(NSDictionary *)editedRecord
                        byRecord:(NSDictionary *)resultRecord;

@end


@interface EditRecordViewController : RecordViewController

/**
 *  Returns the object that handles the delegated duties.
 */
@property (weak, nonatomic) id<EditRecordViewControllerDelegate> delegate;

@property (strong, nonatomic) NSDictionary *record;

@end
