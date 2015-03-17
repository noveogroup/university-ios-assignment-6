//
//  PasswordGenerator.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 19/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "NSString+Shuffling.h"
#import "PasswordGenerator.h"

@implementation PasswordGenerator

#pragma mark - Class methods

+ (NSString *)generatePasswordOfStrength:(NSUInteger)strength
                         usingAlphabet:(NSString *)alphabet
                           cryptoLevel:(NSInteger)cryptoLevel
{
    const NSUInteger alphabetPower = [alphabet length];
    
    NSUInteger newStrength = strength + 5;
    char result[newStrength];
    
    for (NSUInteger i = 0; i < newStrength; i++)
    {
        if(i % 2 == 0)
            result[i] = [alphabet characterAtIndex:((arc4random() % (strength+cryptoLevel+i*2)) + (i*strength >> cryptoLevel)) % alphabetPower];
        else
            result[i] = [alphabet characterAtIndex:((arc4random() % (strength+cryptoLevel+i*3)) - (i*strength << cryptoLevel)) % alphabetPower];
    }
    
    return [NSString stringWithUTF8String:result];
}

@end
