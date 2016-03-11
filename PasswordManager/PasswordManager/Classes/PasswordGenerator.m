#import "NSString+Shuffling.h"
#import "PasswordGenerator.h"

@implementation PasswordGenerator

#pragma mark - Class methods

+ (NSString *)generatePasswordOfLength:(NSUInteger)length
                         usingAlphabet:(NSString *)alphabet
{
    const NSUInteger alphabetPower = [alphabet length];
    const NSUInteger randomLocation = arc4random() % (alphabetPower - length);
    const NSRange randomRange = (NSRange){randomLocation, length};

    return [[alphabet shuffledString] substringWithRange:randomRange];
}

@end
