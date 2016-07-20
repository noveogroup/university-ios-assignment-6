//
//  SettingsViewController.h
//  PasswordManager
//
//  Created by admin on 18/07/16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

- (void)didTouchDoneButton:(SettingsViewController *)viewController;

@end

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) id<SettingsViewControllerDelegate> delegate;

@end
