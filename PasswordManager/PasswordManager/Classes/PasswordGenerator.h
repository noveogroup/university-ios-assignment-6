#import <Foundation/Foundation.h>

@interface PasswordGenerator : NSObject

/**
 *  Generates a password of the specified length using
 *  characters of the particular alphabet.
 */
+ (NSString *)generatePasswordOfLength:(NSUInteger)length
                         usingAlphabet:(NSString *)alphabet;

@end
