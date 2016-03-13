//
//  NSMutableString+Shuffling.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "NSMutableString+Exchange.h"
#import "NSMutableString+Shuffling.h"

@implementation NSMutableString (Shuffling)

- (NSMutableString *)shuffle
{
    const NSUInteger length = [self length];
    for (NSUInteger index = length; index > 1; --index) {
        const NSUInteger randomIndex = arc4random_uniform((unsigned int)index);
        [self exchangeCharacterAtIndex:(index - 1) withCharacterAtIndex:randomIndex];
    }

    return self;
}

@end
