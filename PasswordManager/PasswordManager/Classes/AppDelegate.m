//
//  AppDelegate.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordsViewController.h"
#import "Preferences.h"

@interface AppDelegate ()

@property (strong, nonatomic) RecordsViewController *recordsViewController;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate implementation

-           (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.recordsViewController = [[RecordsViewController alloc] init];
    
    self.window.rootViewController =
        [[UINavigationController alloc] initWithRootViewController:self.recordsViewController];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    StorageMethod settingsStorageMethod = [[NSUserDefaults standardUserDefaults]
                                           integerForKey:kSettingsStorageMethod];
    if (settingsStorageMethod != [[Preferences standardPreferences] storageMethod]) {
        [self.recordsViewController switchStorageMethodTo:settingsStorageMethod];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
