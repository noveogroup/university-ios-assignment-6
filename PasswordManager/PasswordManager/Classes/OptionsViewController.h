//
//  OptionsViewController.h
//  PasswordManager
//
//  Created by Wadim on 8/4/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionsViewController;
@protocol OptionsViewControllerDelegate <NSObject>

- (void) didCloseOptionsMenu:(OptionsViewController *)sender;

@end

@interface OptionsViewController : UIViewController

- (id)initWithDelegate:(id<OptionsViewControllerDelegate>) delegate;

@end


