//
//  SettingsViewController.h
//  PasswordManager
//
//  Created by Admin on 01/08/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate<NSObject>

- (void)kickRecordsManager;

@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
