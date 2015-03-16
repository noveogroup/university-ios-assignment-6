//
//  PasswordManagerSettingsViewController.h
//  PasswordManager
//
//  Created by Пользователь on 13/03/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordManagerSettingsViewController;

@protocol PasswordManagerSettingsVCDelegat <NSObject>

- (void)newSettingsViewController:(PasswordManagerSettingsViewController *)sender;

@end

@interface PasswordManagerSettingsViewController : UIViewController

@property (nonatomic, weak) id<PasswordManagerSettingsVCDelegat> delegate;

@end
