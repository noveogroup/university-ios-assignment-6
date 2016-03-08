//
//  PasswordEditVC.h
//  PasswordManager
//
//  Created by Vik on 06.03.16.
//  Copyright © 2016 Noveo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordsManager.h"

@interface PasswordEditVC : UIViewController

@property (copy, nonatomic) NSDictionary *passObject;
@property (strong, nonatomic) RecordsManager *recordsManager;

@end
