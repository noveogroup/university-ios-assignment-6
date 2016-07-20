//
//  SettingsViewController.h
//  PasswordManager
//
//  Created by Sergey Plotnikov on 19.07.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(SettingsViewController *)sender;

@end


@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
