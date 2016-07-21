//
//  SettingsManager.h
//  PasswordManager
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property (nonatomic) NSUserDefaults *settings;

- (NSInteger)passwordStrength;

@end
