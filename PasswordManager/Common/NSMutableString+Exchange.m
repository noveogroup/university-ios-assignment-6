//
//  NSMutableString+Exchange.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "NSMutableString+Exchange.h"

@implementation NSMutableString (Exchange)

- (void)exchangeCharacterAtIndex:(NSUInteger)index1
            withCharacterAtIndex:(NSUInteger)index2
{
    @autoreleasepool {
        const NSRange range1 = (NSRange){index1, 1};
        NSString *const substring1 = [self substringWithRange:range1];

        const NSRange range2 = (NSRange){index2, 1};
        NSString *const substring2 = [self substringWithRange:range2];

        [self replaceCharactersInRange:range1 withString:substring2];
        [self replaceCharactersInRange:range2 withString:substring1];
    }
}

@end
