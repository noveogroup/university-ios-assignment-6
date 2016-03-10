#import "AppDelegate.h"
#import "RecordsViewController.h"
#import "Preferences.h"

@interface AppDelegate ()
@property (strong, nonatomic) UITabBarController *tabController;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate implementation

-           (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController =
        [[UINavigationController alloc]
            initWithRootViewController:[[RecordsViewController alloc] init]];
    
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
    [[Preferences standardPreferences] syncSettingsBundleAndSettingsApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
