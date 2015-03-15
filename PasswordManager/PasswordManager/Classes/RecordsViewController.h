//
//  RecordsViewController.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "Preferences.h"

@interface RecordsViewController : UIViewController

- (void)switchStorageMethodTo:(StorageMethod)storageMethod;

@end
