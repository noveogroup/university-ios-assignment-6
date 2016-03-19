//
//  NSString+Shuffling.m
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import "NSMutableString+Shuffling.h"
#import "NSString+Shuffling.h"

@implementation NSString (Shuffling)

- (NSString *)shuffledString
{
    return [[[self mutableCopy] shuffle] copy];
}

@end
