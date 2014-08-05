//
//  SettingsViewController.h
//  PasswordManager
//
//  Created by Admin on 05/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDone:(SettingsViewController *)sender;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
