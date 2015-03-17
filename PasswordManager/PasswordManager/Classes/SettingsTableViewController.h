//
//  SettingsTableViewController.h
//  PasswordManager
//
//  Created by Иван Букшев on 3/17/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Preferences.h"

@interface SettingsTableViewController : UITableViewController
{
    NSMutableDictionary *mutableBlocks;
}

@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *mutableBlocks;

- (NSArray *)currentBlocks:(NSInteger)index;

@property (nonatomic, strong) UILabel *cryptoLabel;
@property (nonatomic, strong) UISlider *cryptoSlider;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UISlider *passwordSlider;

@end
