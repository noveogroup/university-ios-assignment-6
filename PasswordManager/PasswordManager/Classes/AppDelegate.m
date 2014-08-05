//
//  AppDelegate.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordsViewController.h"

@interface AppDelegate ()

@property (nonatomic, weak) id<ShouldUpdateDefaultsDelegate> delegate;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate implementation

-           (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    RecordsViewController *const rootController = [[RecordsViewController alloc] init];
    self.delegate = rootController;
    self.window.rootViewController =
        [[UINavigationController alloc]
            initWithRootViewController:rootController];

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
    [self.delegate updateDefaults:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
