//
//  NSMutableString+Exchange.h
//  PasswordManager
//
//  Created by Maxim Zabelin on 20/02/14.
//  Copyright (c) 2014 Noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Exchange)

- (void)exchangeCharacterAtIndex:(NSUInteger)index1
            withCharacterAtIndex:(NSUInteger)index2;

@end
