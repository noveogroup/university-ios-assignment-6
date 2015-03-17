//
//  PasswordGenerator.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasswordGenerator : NSObject

/**
 *  Generates a password of the specified length using
 *  characters of the particular alphabet.
 */
+ (NSString *)generatePasswordOfStrength:(NSUInteger)strength
                         usingAlphabet:(NSString *)alphabet
                           cryptoLevel:(NSInteger)cryptoLevel;

@end
