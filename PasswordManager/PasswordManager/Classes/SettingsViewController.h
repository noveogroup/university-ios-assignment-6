//
//  SettingsViewController.h
//  PasswordManager
//
//  Created by Александр on 14.03.15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>


- (void)didCloseSettingsMenu:(SettingsViewController *)sender;

@end


@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsViewControllerDelegate> delegate;

@end
