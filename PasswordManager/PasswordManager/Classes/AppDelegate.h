//
//  AppDelegate.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShouldUpdateDefaultsDelegate <NSObject>


- (void) updateDefaults:(id)sender;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
