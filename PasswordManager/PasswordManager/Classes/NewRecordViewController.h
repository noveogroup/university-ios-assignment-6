//
//  NewRecordViewController.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewRecordViewController;

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
- (void)newRecordViewController:(NewRecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record;

-(void)newRecordViewController:(NewRecordViewController *)sender
                       replace:(NSDictionary *)oldRecord
                          with:(NSDictionary*)newRecord;

@end

@interface NewRecordViewController : UIViewController

-(instancetype)initWithRecord:(NSDictionary*)currentRecord;
/**
 *  Returns the object that handles the delegated duties.
 */
@property (nonatomic, weak) id<NewRecordViewControllerDelegate> delegate;

@end
