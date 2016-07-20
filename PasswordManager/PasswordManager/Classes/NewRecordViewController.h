//
//  NewRecordViewController.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class NewRecordViewController;

/**
 *  The protocol describing the duties the instance of @c NewRecordViewController
 *  are able to delegate.
 */
@protocol NewRecordViewControllerDelegate <NSObject>

- (void)newRecordViewController:(NewRecordViewController *)sender
            didFinishWithRecord:(NSDictionary *)record;

- (void)newRecordViewController:(NewRecordViewController *)sender
        didFinishEditWithRecord:(NSDictionary *)record atIndexPath:(NSIndexPath *)indexPath;

@end

@interface NewRecordViewController : UIViewController

@property (nonatomic, weak) id<NewRecordViewControllerDelegate> delegate;

- (instancetype)init;
- (instancetype)initWithRecord:(NSDictionary *)record AtIndexPath:(NSIndexPath *)indexPath;

@end
